import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;

import '../../../core/infrastructure/error/app_exception.dart';
import '../../../core/infrastructure/network/network_info.dart';
import '../../../core/presentation/utils/fp_framework.dart';
import '../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/auth_failure.dart';
import '../../domain/sign_in_with_email.dart';
import '../../domain/user.dart' as domain;
import '../data_sources/auth_local_data_source.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../dtos/user_dto.dart';

part 'auth_repo.g.dart';

@Riverpod(keepAlive: true)
AuthRepo authRepo(Ref ref) {
  return AuthRepo(
    networkInfo: ref.watch(networkInfoProvider),
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
}

class AuthRepo {
  AuthRepo({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final NetworkInfo networkInfo;
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  Future<domain.User> signInWithEmail(SignInWithEmail params) async {
    final userFromCredential = await remoteDataSource.signInWithEmail(params);
    return userFromCredential.toDomain();
  }

  Future<domain.User> registerWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    final userDto = await remoteDataSource.registerWithEmail(
      email: email,
      password: password,
      name: name,
    );
    return userDto.toDomain();
  }

  Future<String> getUserAuthUid() async {
    final uid = await remoteDataSource.getUserAuthUid();
    return uid;
  }

  Future<domain.User> getUserData(String uid) async {
    if (await networkInfo.hasInternetConnection) {
      final user = await remoteDataSource.getUserData(uid);
      try {
        await localDataSource.cacheUserData(user);
      } catch (_) {}
      return user.toDomain();
    } else {
      final user = localDataSource.getUserData();
      return user.toDomain();
    }
  }

  /// This is no longer needed.
  /// as user doc should be created at Firestore when registering the user.
  Future<void> setUserData(domain.User user) async {
    final userDto = UserDto.fromDomain(user);
    await remoteDataSource.setUserData(userDto);
    try {
      await localDataSource.cacheUserData(userDto);
    } catch (_) {}
  }

  Future<void> signOut() async {
    await remoteDataSource.signOut();
    try {
      await localDataSource.clearUserData();
    } catch (_) {}
  }

  Future<Either<AuthFailure, Unit>> sendPasswordResetEmail(String email) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email);
      return right(unit);
    } on FirebaseAuthException catch (e) {
      return left(_mapFirebaseAuthException(e));
    } on ServerException catch (e) {
      if (e.type == ServerExceptionType.noInternet) {
        return left(const AuthFailure.networkError());
      }
      return left(AuthFailure.serverError(e.message));
    } catch (e) {
      return left(AuthFailure.serverError(e.toString()));
    }
  }

  Future<Either<AuthFailure, Unit>> sendEmailVerification() async {
    try {
      await remoteDataSource.sendEmailVerification();
      return right(unit);
    } on ServerException catch (e) {
      if (e.type == ServerExceptionType.unauthorized) {
        return left(const AuthFailure.userNotFound());
      }
      if (e.type == ServerExceptionType.noInternet) {
        return left(const AuthFailure.networkError());
      }
      return left(AuthFailure.serverError(e.message));
    } on FirebaseAuthException catch (e) {
      return left(_mapFirebaseAuthException(e));
    } catch (e) {
      return left(AuthFailure.serverError(e.toString()));
    }
  }

  Future<Either<AuthFailure, bool>> checkEmailVerified() async {
    try {
      final isVerified = await remoteDataSource.checkEmailVerified();
      return right(isVerified);
    } on ServerException catch (e) {
      if (e.type == ServerExceptionType.unauthorized) {
        return left(const AuthFailure.userNotFound());
      }
      if (e.type == ServerExceptionType.noInternet) {
        return left(const AuthFailure.networkError());
      }
      return left(AuthFailure.serverError(e.message));
    } catch (e) {
      return left(AuthFailure.serverError(e.toString()));
    }
  }

  AuthFailure _mapFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return const AuthFailure.userNotFound();
      case 'invalid-email':
        return const AuthFailure.invalidEmail();
      case 'email-already-in-use':
        return const AuthFailure.emailAlreadyInUse();
      case 'wrong-password':
        return const AuthFailure.wrongPassword();
      case 'too-many-requests':
        return const AuthFailure.tooManyRequests();
      case 'user-disabled':
        return const AuthFailure.userDisabled();
      case 'network-request-failed':
        return const AuthFailure.networkError();
      default:
        return AuthFailure.serverError(e.message);
    }
  }
}
