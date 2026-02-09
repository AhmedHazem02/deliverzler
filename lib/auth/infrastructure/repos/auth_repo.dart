import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuthException, PhoneAuthCredential;
import 'package:flutter/foundation.dart';

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

import '../../../core/infrastructure/network/main_api/extensions/firebase_error_extension.dart';

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
    try {
      final userDto = await remoteDataSource.registerWithEmail(
        email: email,
        password: password,
        name: name,
      );
      debugPrint('✅ [AuthRepo] registerWithEmail SUCCESS');
      return userDto.toDomain();
    } catch (e, stackTrace) {
      if (e is FirebaseAuthException) {
        debugPrint('❌ [AuthRepo] CloudAuth Error: ${e.code}');
      } else {
        debugPrint('❌ [AuthRepo] registerWithEmail ERROR!');
        debugPrint('❌ [AuthRepo] Error: $e');
        debugPrint('❌ [AuthRepo] Stack: $stackTrace');
      }
      throw e.firebaseErrorToServerException();
    }
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

  /// Check if user is verified via either email OR phone.
  Future<Either<AuthFailure, bool>> checkUserVerified() async {
    try {
      final isVerified = await remoteDataSource.checkUserVerified();
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

  /// Check if the phone number is verified (linked).
  Future<Either<AuthFailure, bool>> checkPhoneVerified() async {
    try {
      final isVerified = await remoteDataSource.checkPhoneVerified();
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

  /// Start phone number verification (sends OTP SMS).
  Future<Either<AuthFailure, Unit>> sendPhoneVerification({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(String verificationId) codeAutoRetrievalTimeout,
    required void Function(PhoneAuthCredential credential)
        verificationCompleted,
    required void Function(FirebaseAuthException error) verificationFailed,
    int? forceResendingToken,
  }) async {
    try {
      await remoteDataSource.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        forceResendingToken: forceResendingToken,
      );
      return right(unit);
    } on ServerException catch (e) {
      if (e.type == ServerExceptionType.noInternet) {
        return left(const AuthFailure.networkError());
      }
      return left(AuthFailure.serverError(e.message));
    } on FirebaseAuthException catch (e) {
      return left(_mapFirebasePhoneAuthException(e));
    } catch (e) {
      return left(AuthFailure.serverError(e.toString()));
    }
  }

  /// Verify the OTP code and link phone to the current user.
  Future<Either<AuthFailure, Unit>> verifyOtpAndLinkPhone({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      await remoteDataSource.verifyOtpAndLinkPhone(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return right(unit);
    } on ServerException catch (e) {
      if (e.type == ServerExceptionType.unauthorized) {
        return left(const AuthFailure.userNotFound());
      }
      return left(AuthFailure.serverError(e.message));
    } on FirebaseAuthException catch (e) {
      return left(_mapFirebasePhoneAuthException(e));
    } catch (e) {
      return left(AuthFailure.serverError(e.toString()));
    }
  }

  /// Link a phone credential (for auto-verification on Android).
  Future<Either<AuthFailure, Unit>> linkPhoneCredential(
      PhoneAuthCredential credential) async {
    try {
      await remoteDataSource.linkPhoneCredential(credential);
      return right(unit);
    } on ServerException catch (e) {
      return left(AuthFailure.serverError(e.message));
    } on FirebaseAuthException catch (e) {
      return left(_mapFirebasePhoneAuthException(e));
    } catch (e) {
      return left(AuthFailure.serverError(e.toString()));
    }
  }

  /// Save the user's chosen verification method to Firestore.
  Future<Either<AuthFailure, Unit>> setVerificationMethod({
    required String uid,
    required String method,
  }) async {
    try {
      await remoteDataSource.setVerificationMethod(uid: uid, method: method);
      return right(unit);
    } catch (e) {
      return left(AuthFailure.serverError(e.toString()));
    }
  }

  /// Get the verification method chosen by the user.
  Future<String?> getVerificationMethod(String uid) async {
    return remoteDataSource.getVerificationMethod(uid);
  }

  AuthFailure _mapFirebasePhoneAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return const AuthFailure.invalidPhoneNumber();
      case 'invalid-verification-code':
        return const AuthFailure.invalidVerificationCode();
      case 'quota-exceeded':
        return const AuthFailure.smsQuotaExceeded();
      case 'session-expired':
        return const AuthFailure.sessionExpired();
      case 'too-many-requests':
        return const AuthFailure.tooManyRequests();
      case 'network-request-failed':
        return const AuthFailure.networkError();
      case 'credential-already-in-use':
        return AuthFailure.phoneVerificationFailed(
            'This phone number is already linked to another account');
      default:
        return AuthFailure.phoneVerificationFailed(e.message);
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
