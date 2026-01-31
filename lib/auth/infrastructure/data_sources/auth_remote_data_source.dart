import 'package:flutter/foundation.dart';

import '../../../core/infrastructure/error/app_exception.dart';
import '../../../core/infrastructure/network/main_api/api_callers/firebase_auth_facade.dart';
import '../../../core/infrastructure/network/main_api/api_callers/firebase_firestore_facade.dart';
import '../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/sign_in_with_email.dart';
import '../dtos/user_dto.dart';

part 'auth_remote_data_source.g.dart';

@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSource(
    ref,
    firebaseAuth: ref.watch(firebaseAuthFacadeProvider),
    firebaseFirestore: ref.watch(firebaseFirestoreFacadeProvider),
  );
}

class AuthRemoteDataSource {
  AuthRemoteDataSource(
    this.ref, {
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  final Ref ref;
  final FirebaseAuthFacade firebaseAuth;
  final FirebaseFirestoreFacade firebaseFirestore;

  static const String usersCollectionPath = 'users';

  static String userDocPath(String uid) => '$usersCollectionPath/$uid';

  Future<UserDto> signInWithEmail(SignInWithEmail params) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
    final userDto = UserDto.fromUserCredential(userCredential.user!);
    return userDto;
  }

  Future<UserDto> registerWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userDto = UserDto.fromUserCredential(userCredential.user!);

    // If a name was provided, set it on the Firestore user doc as well
    final updated = userDto.copyWith(name: name ?? userDto.name);
    await setUserData(updated);
    return updated;
  }

  Future<String> getUserAuthUid() async {
   // debugPrint('🔐 [AuthRemote] getUserAuthUid started');
    // 1. Check if user is already loaded synchronously
    if (firebaseAuth.firebaseAuth.currentUser != null) {
  //    debugPrint(
   //       '🔐 [AuthRemote] User found synchronously: ${firebaseAuth.firebaseAuth.currentUser!.uid}');
      return firebaseAuth.firebaseAuth.currentUser!.uid;
    }

    //debugPrint(
      //  '🔐 [AuthRemote] User not found synchronously, waiting for stream...');

    // 2. If not, wait for the stream to emit a user with retry mechanism
    // This helps on web refreshes where persistence takes a moment to load
    const maxRetries = 3;
    const timeoutPerAttempt = Duration(seconds: 6);

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
       // debugPrint('🔐 [AuthRemote] Attempt $attempt/$maxRetries');
        final user = await firebaseAuth.authStateChanges.firstWhere((user) {
          //debugPrint('🔐 [AuthRemote] Stream emitted: ${user?.uid}');
          return user != null;
        }).timeout(timeoutPerAttempt);
        debugPrint('🔐 [AuthRemote] User found in stream: ${user!.uid}');
        return user.uid;
      } catch (e) {
        //debugPrint('🔐 [AuthRemote] Attempt $attempt failed: $e');
        if (attempt == maxRetries) {
       //   debugPrint( '🔐 [AuthRemote] All attempts exhausted, user is truly not signed in');
          // All attempts failed => User is truly null
          throw const ServerException(
            type: ServerExceptionType.unauthorized,
            message: 'User is not signed-in',
          );
        }
        // Wait a bit before retrying
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    // Should never reach here, but just in case
    throw const ServerException(
      type: ServerExceptionType.unauthorized,
      message: 'User is not signed-in',
    );
  }

  Future<UserDto> getUserData(String uid) async {
    final response = await firebaseFirestore.getData(path: userDocPath(uid));
    if (response.data() case final data?) {
      return UserDto.fromJson(data as Map<String, dynamic>);
    } else {
      throw const ServerException(
        type: ServerExceptionType.notFound,
        message: 'User data not found.',
      );
    }
  }

  Future<void> setUserData(UserDto userDto) async {
    return firebaseFirestore.setData(
      path: userDocPath(userDto.id),
      data: userDto.toJson(),
    );
  }

  Future<void> signOut() async {
    return firebaseAuth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    return firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendEmailVerification() async {
    return firebaseAuth.sendEmailVerification();
  }

  Future<bool> checkEmailVerified() async {
    return firebaseAuth.isEmailVerified();
  }
}
