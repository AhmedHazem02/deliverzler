import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../error/app_exception.dart';

extension FirebaseErrorExtension on Object {
  ServerException firebaseErrorToServerException() {
    final exception = this;

    if (exception is FirebaseAuthException) {
      return exception.firebaseAuthToServerException();
    }
    if (exception is TimeoutException) {
      return ServerException(
        type: ServerExceptionType.timeOut,
        message: exception.message ??
            'Connecting timed out [${exception.duration}ms]',
        code: 408,
      );
    }
    return ServerException(
      type: ServerExceptionType.unknown,
      message: exception.toString(),
    );
  }
}

extension _FirebaseAuthErrorExtension on FirebaseAuthException {
  // TODO(Ahmed): Handle all auth exception cases and add unit tests
  ServerException firebaseAuthToServerException() {
    return switch (code) {
      'invalid-email' => ServerException(
          type: ServerExceptionType.authInvalidEmail,
          message: message ?? 'Please enter a valid email address',
        ),
      'wrong-password' => ServerException(
          type: ServerExceptionType.authWrongPassword,
          message: message ?? 'Wrong password',
        ),
      'user-not-found' => ServerException(
          type: ServerExceptionType.authUserNotFound,
          message: message ?? 'User not found',
        ),
      'user-disabled' => ServerException(
          type: ServerExceptionType.authUserDisabled,
          message: message ?? 'User account disabled',
        ),
      'email-already-in-use' => ServerException(
          type: ServerExceptionType.unknown,
          message: 'This email is already registered. Please log in instead.',
        ),
      'weak-password' => ServerException(
          type: ServerExceptionType.unknown,
          message: 'Password is too weak. Please use a stronger password.',
        ),
      'operation-not-allowed' => ServerException(
          type: ServerExceptionType.unknown,
          message: 'Sign up is currently disabled. Please try again later.',
        ),
      _ => ServerException(
          type: ServerExceptionType.unknown,
          message: message?.isNotEmpty == true
              ? message!
              : (code?.isNotEmpty == true)
                  ? 'Error: $code'
                  : 'An error occurred during sign up. Please try again.',
        ),
    };
  }
}
