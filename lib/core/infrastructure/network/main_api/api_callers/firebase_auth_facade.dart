import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../../presentation/utils/riverpod_framework.dart';
import '../../../error/app_exception.dart';
import '../extensions/firebase_error_extension.dart';

part 'firebase_auth_facade.g.dart';

//Our main API is Firebase
@Riverpod(keepAlive: true)
FirebaseAuthFacade firebaseAuthFacade(Ref ref) {
  try {
    final firebaseAuthInstance = FirebaseAuth.instance;
    return FirebaseAuthFacade(
      firebaseAuth: firebaseAuthInstance,
    );
  } catch (e, st) {
    debugPrint(
        '❌ [FirebaseAuthFacade] Failed to get FirebaseAuth.instance: $e');
    debugPrint('❌ [FirebaseAuthFacade] Stack: $st');
    // Provide a clearer ServerException so callers don't receive JS interop TypeErrors
    throw const ServerException(
      type: ServerExceptionType.unknown,
      message:
          'Firebase is not initialized. Check firebase_options and dart-define configs.',
    );
  }
}

class FirebaseAuthFacade {
  FirebaseAuthFacade({
    required this.firebaseAuth,
  }) {
    // Disable reCAPTCHA for web debug mode immediately on construction
    // so it takes effect before any phone verification attempt.
    if (kIsWeb && kDebugMode) {
      firebaseAuth.setSettings(appVerificationDisabledForTesting: true);
      debugPrint(
          '🟡 [FirebaseAuthFacade] reCAPTCHA disabled for testing (web debug)');
    }
  }

  final FirebaseAuth firebaseAuth;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _errorHandler(
      () async {
        return firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      },
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Direct call to avoid JS Interop casting issues in _errorHandler for now
    try {
      debugPrint(
          '🟣 [FirebaseAuthFacade] createUserWithEmailAndPassword called');
      debugPrint('🟣 [FirebaseAuthFacade] Email: $email');

      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugPrint('✅ [FirebaseAuthFacade] SUCCESS: User created');
      debugPrint('✅ [FirebaseAuthFacade] UID: ${result.user?.uid}');
      return result;
    } catch (e, stackTrace) {
      debugPrint(
          '❌ [FirebaseAuthFacade] ERROR in createUserWithEmailAndPassword!');
      debugPrint('❌ [FirebaseAuthFacade] Error Type: ${e.runtimeType}');
      debugPrint('❌ [FirebaseAuthFacade] Error: $e');
      debugPrint('❌ [FirebaseAuthFacade] Stack: $stackTrace');
      rethrow;
    }
  }

  Future<User> getCurrentUser() async {
    return _errorHandler(
      () async {
        final currentUser = firebaseAuth.currentUser;
        if (currentUser != null) {
          return currentUser;
        } else {
          throw const ServerException(
            type: ServerExceptionType.unauthorized,
            message: 'User is not signed-in',
          );
        }
      },
    );
  }

  Future<void> signOut() async {
    return _errorHandler(
      () async {
        return firebaseAuth.signOut();
      },
    );
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    return _errorHandler(
      () async {
        return firebaseAuth.sendPasswordResetEmail(email: email);
      },
    );
  }

  Future<void> sendEmailVerification() async {
    try {
      debugPrint('🟣 [FirebaseAuthFacade] sendEmailVerification called');
      final currentUser = firebaseAuth.currentUser;
      debugPrint('🟣 [FirebaseAuthFacade] currentUser: ${currentUser?.uid}');
      debugPrint(
          '🟣 [FirebaseAuthFacade] emailVerified: ${currentUser?.emailVerified}');

      if (currentUser != null && !currentUser.emailVerified) {
        debugPrint('🟣 [FirebaseAuthFacade] Sending verification email...');
        await currentUser.sendEmailVerification();
        debugPrint('✅ [FirebaseAuthFacade] Verification email sent!');
        return;
      } else if (currentUser == null) {
        debugPrint('❌ [FirebaseAuthFacade] No user signed in!');
        throw const ServerException(
          type: ServerExceptionType.unauthorized,
          message: 'No user signed in',
        );
      }
      debugPrint('🟣 [FirebaseAuthFacade] Email already verified, skipping');
      // If already verified, do nothing
    } catch (e, stackTrace) {
      debugPrint('❌ [FirebaseAuthFacade] ERROR in sendEmailVerification!');
      debugPrint('❌ [FirebaseAuthFacade] Error Type: ${e.runtimeType}');
      debugPrint('❌ [FirebaseAuthFacade] Error: $e');
      debugPrint('❌ [FirebaseAuthFacade] Stack: $stackTrace');
      rethrow;
    }
  }

  Future<void> reloadUser() async {
    return _errorHandler(
      () async {
        final currentUser = firebaseAuth.currentUser;
        if (currentUser != null) {
          return currentUser.reload();
        } else {
          throw const ServerException(
            type: ServerExceptionType.unauthorized,
            message: 'No user signed in',
          );
        }
      },
    );
  }

  Future<bool> isEmailVerified() async {
    return _errorHandler(
      () async {
        final currentUser = firebaseAuth.currentUser;
        if (currentUser != null) {
          // Reload to get fresh data from server
          await currentUser.reload();
          // Get the updated user
          final refreshedUser = firebaseAuth.currentUser;
          return refreshedUser?.emailVerified ?? false;
        } else {
          throw const ServerException(
            type: ServerExceptionType.unauthorized,
            message: 'No user signed in',
          );
        }
      },
    );
  }

  /// Returns true if the current Firebase user has a linked phone number.
  Future<bool> isPhoneVerified() async {
    return _errorHandler(() async {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser != null) {
        await currentUser.reload();
        final refreshedUser = firebaseAuth.currentUser;
        // A non-null phoneNumber means the phone provider is linked
        return refreshedUser?.phoneNumber != null &&
            refreshedUser!.phoneNumber!.isNotEmpty;
      } else {
        throw const ServerException(
          type: ServerExceptionType.unauthorized,
          message: 'No user signed in',
        );
      }
    });
  }

  /// Returns true if the user is verified via either email or phone.
  Future<bool> isUserVerified() async {
    return _errorHandler(() async {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser != null) {
        await currentUser.reload();
        final refreshedUser = firebaseAuth.currentUser;
        if (refreshedUser == null) {
          throw const ServerException(
            type: ServerExceptionType.unauthorized,
            message: 'No user signed in',
          );
        }
        final emailVerified = refreshedUser.emailVerified;
        final phoneLinked = refreshedUser.phoneNumber != null &&
            refreshedUser.phoneNumber!.isNotEmpty;
        return emailVerified || phoneLinked;
      } else {
        throw const ServerException(
          type: ServerExceptionType.unauthorized,
          message: 'No user signed in',
        );
      }
    });
  }

  /// Start phone number verification. This sends an SMS OTP to [phoneNumber].
  ///
  /// On mobile: Firebase auto-retrieves the SMS or asks the user to type the OTP.
  /// On web: reCAPTCHA is shown automatically by Firebase.
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(String verificationId) codeAutoRetrievalTimeout,
    required void Function(PhoneAuthCredential credential)
        verificationCompleted,
    required void Function(FirebaseAuthException error) verificationFailed,
    int? forceResendingToken,
  }) async {
    debugPrint('🟣 [FirebaseAuthFacade] verifyPhoneNumber: $phoneNumber');

    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      forceResendingToken: forceResendingToken,
      timeout: const Duration(seconds: 60),
    );
  }

  /// Link a phone credential to the currently signed-in user.
  /// This is used after the user enters the OTP code.
  Future<void> linkPhoneCredential(PhoneAuthCredential credential) async {
    return _errorHandler(() async {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser != null) {
        await currentUser.linkWithCredential(credential);
        debugPrint('✅ [FirebaseAuthFacade] Phone credential linked');
      } else {
        throw const ServerException(
          type: ServerExceptionType.unauthorized,
          message: 'No user signed in',
        );
      }
    });
  }

  /// Create a [PhoneAuthCredential] from verificationId + smsCode,
  /// then link it to the current user.
  Future<void> verifyOtpAndLinkPhone({
    required String verificationId,
    required String smsCode,
  }) async {
    debugPrint('🟣 [FirebaseAuthFacade] verifyOtpAndLinkPhone');
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await linkPhoneCredential(credential);
  }

  /// Sign in using a phone credential (for forgot password via phone).
  Future<UserCredential> signInWithPhoneCredential(
      PhoneAuthCredential credential) async {
    return _errorHandler(() async {
      debugPrint('🟣 [FirebaseAuthFacade] signInWithPhoneCredential');
      final result = await firebaseAuth.signInWithCredential(credential);
      debugPrint(
          '✅ [FirebaseAuthFacade] Phone sign-in success: ${result.user?.uid}');
      return result;
    });
  }

  /// Update password for the currently signed-in user.
  Future<void> updatePassword(String newPassword) async {
    return _errorHandler(() async {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser != null) {
        await currentUser.updatePassword(newPassword);
        debugPrint('✅ [FirebaseAuthFacade] Password updated successfully');
      } else {
        throw const ServerException(
          type: ServerExceptionType.unauthorized,
          message: 'No user signed in',
        );
      }
    });
  }

  Future<T> _errorHandler<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on ServerException {
      rethrow;
    } catch (e, st) {
      // On web, Firebase may throw different exception types
      // Try to convert to ServerException, but if it fails, wrap the original error
      try {
        final error = e.firebaseErrorToServerException();
        throw Error.throwWithStackTrace(error, st);
      } catch (conversionError) {
        // If conversion fails, throw a generic server exception with the original error message
        if (conversionError is ServerException) {
          rethrow;
        }
        throw Error.throwWithStackTrace(
          ServerException(
            type: ServerExceptionType.unknown,
            message: e.toString(),
          ),
          st,
        );
      }
    }
  }
}
