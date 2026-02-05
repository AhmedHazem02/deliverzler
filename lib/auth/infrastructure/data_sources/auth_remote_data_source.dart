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

  static const String usersCollectionPath = 'drivers';

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
    try {
      debugPrint(
          '🔵 [AuthRemote] Step 1: Starting registration for email: $email');

      debugPrint(
          '🔵 [AuthRemote] Step 1.1: Calling firebaseAuth.createUserWithEmailAndPassword...');
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugPrint(
          '🔵 [AuthRemote] Step 2: Firebase Auth account created successfully');
      debugPrint('🔵 [AuthRemote] User UID: ${userCredential.user?.uid}');
      debugPrint('🔵 [AuthRemote] User Email: ${userCredential.user?.email}');

      debugPrint('🔵 [AuthRemote] Step 3: Creating UserDto from credential...');
      final userDto = UserDto.fromUserCredential(userCredential.user!);
      debugPrint('🔵 [AuthRemote] Step 3 SUCCESS: UserDto created');

      // Set name and status for driver registration
      debugPrint(
          '🔵 [AuthRemote] Step 4: Updating UserDto with name and status...');
      final updated = userDto.copyWith(
        name: name ?? userDto.name,
        status: 'pending', // Driver starts with pending status
      );

      debugPrint('🔵 [AuthRemote] Step 4 SUCCESS: UserDto updated');
      debugPrint('🔵 [AuthRemote] UserDto JSON: ${updated.toJson()}');

      debugPrint('🔵 [AuthRemote] Step 5: Saving to Firestore...');
      await setUserData(updated);
      debugPrint('✅ [AuthRemote] Step 5 SUCCESS: User saved to Firestore');

      debugPrint('✅ [AuthRemote] Registration completed successfully!');
      return updated;
    } catch (e, stackTrace) {
      debugPrint('❌ [AuthRemote] ERROR in registerWithEmail!');
      debugPrint('❌ [AuthRemote] Error Type: ${e.runtimeType}');
      debugPrint('❌ [AuthRemote] Error: $e');
      debugPrint('❌ [AuthRemote] Stack: $stackTrace');
      rethrow;
    }
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
      // Use fromFirestoreData to handle both UserDto and DriverApplication formats
      return UserDto.fromFirestoreData(data as Map<String, dynamic>);
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
