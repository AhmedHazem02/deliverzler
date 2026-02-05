import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../error/app_exception.dart';

extension FirebaseErrorExtension on Object {
  ServerException firebaseErrorToServerException() {
    final exception = this;

    // Handle FirebaseAuthException (used by Firebase Native SDKs)
    if (exception is FirebaseAuthException) {
      return exception.firebaseAuthToServerException();
    }
    // Handle FirebaseException (used by Firebase Web SDK)
    if (exception is FirebaseException) {
      return exception.firebaseExceptionToServerException();
    }
    if (exception is TimeoutException) {
      return ServerException(
        type: ServerExceptionType.timeOut,
        message: exception.message ??
            'Connecting timed out [${exception.duration}ms]',
        code: 408,
      );
    }
    
    // Try to extract error code from the exception string (for web JS interop errors)
    final errorString = exception.toString().toLowerCase();
    if (errorString.contains('invalid-email')) {
      return const ServerException(
        type: ServerExceptionType.authInvalidEmail,
        message: 'Please enter a valid email address',
      );
    }
    if (errorString.contains('wrong-password') || errorString.contains('invalid-credential')) {
      return const ServerException(
        type: ServerExceptionType.authWrongPassword,
        message: 'Invalid email or password',
      );
    }
    if (errorString.contains('user-not-found')) {
      return const ServerException(
        type: ServerExceptionType.authUserNotFound,
        message: 'User not found',
      );
    }
    if (errorString.contains('user-disabled')) {
      return const ServerException(
        type: ServerExceptionType.authUserDisabled,
        message: 'User account disabled',
      );
    }
    if (errorString.contains('email-already-in-use')) {
      return const ServerException(
        type: ServerExceptionType.unknown,
        message: 'This email is already registered. Please log in instead.',
      );
    }
    if (errorString.contains('too-many-requests')) {
      return const ServerException(
        type: ServerExceptionType.authTooManyRequests,
        message: 'Too many attempts. Please try again later.',
      );
    }
    if (errorString.contains('network-request-failed') || errorString.contains('network')) {
      return const ServerException(
        type: ServerExceptionType.general,
        message: 'Network error. Please check your connection.',
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
    final cleanCode = code.replaceFirst('auth/', '');
    
    return switch (cleanCode) {
      'invalid-email' => ServerException(
          type: ServerExceptionType.authInvalidEmail,
          message: message ?? 'Please enter a valid email address',
        ),
      'wrong-password' || 'invalid-credential' => ServerException(
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
      'email-already-in-use' => const ServerException(
          type: ServerExceptionType.authEmailAlreadyInUse,
          message: 'This email is already registered. Please log in instead.',
        ),
      'weak-password' => const ServerException(
          type: ServerExceptionType.authWeakPassword,
          message: 'Password is too weak. Please use a stronger password.',
        ),
      'operation-not-allowed' => const ServerException(
          type: ServerExceptionType.unknown,
          message: 'Sign up is currently disabled. Please try again later.',
        ),
      _ => _fallbackMessageCheck(
          message?.isNotEmpty ?? false
              ? message!
              : code.isNotEmpty
                  ? 'Error: $code'
                  : 'An error occurred during sign up. Please try again.',
          exception: this,
        ),
    };
  }
}

extension _FirebaseExceptionExtension on FirebaseException {
  /// Handle Firebase Web SDK exceptions (FirebaseException instead of FirebaseAuthException)
  ServerException firebaseExceptionToServerException() {
    // Firebase Web uses 'code' property similar to FirebaseAuthException
    // Some versions might return 'auth/code', others just 'code'
    final cleanCode = code.replaceFirst('auth/', '');
    
    return switch (cleanCode) {
      'invalid-email' => ServerException(
          type: ServerExceptionType.authInvalidEmail,
          message: message ?? 'Please enter a valid email address',
        ),
      'wrong-password' || 'invalid-credential' => ServerException(
          type: ServerExceptionType.authWrongPassword,
          message: message ?? 'Invalid email or password',
        ),
      'user-not-found' => ServerException(
          type: ServerExceptionType.authUserNotFound,
          message: message ?? 'User not found',
        ),
      'user-disabled' => ServerException(
          type: ServerExceptionType.authUserDisabled,
          message: message ?? 'User account disabled',
        ),
      'email-already-in-use' => const ServerException(
          type: ServerExceptionType.authEmailAlreadyInUse,
          message: 'This email is already registered. Please log in instead.',
        ),
      'weak-password' => const ServerException(
          type: ServerExceptionType.authWeakPassword,
          message: 'Password is too weak. Please use a stronger password.',
        ),
      'operation-not-allowed' => const ServerException(
          type: ServerExceptionType.unknown,
          message: 'Sign up is currently disabled. Please try again later.',
        ),
      'too-many-requests' => const ServerException(
          type: ServerExceptionType.authTooManyRequests,
          message: 'Too many attempts. Please try again later.',
        ),
      'network-request-failed' => const ServerException(
          type: ServerExceptionType.general,
          message: 'Network error. Please check your connection.',
        ),
      _ => _fallbackMessageCheck(message ?? 'An error occurred. Please try again.', exception: this),
    };
  }
}

ServerException _fallbackMessageCheck(String message, {Object? exception}) {
  final lowerMessage = message.toLowerCase();
  
  if (lowerMessage.contains('incorrect, malformed or has expired') || 
      lowerMessage.contains('supplied auth credential') ||
      lowerMessage.contains('invalid login credentials')) {
    return const ServerException(
      type: ServerExceptionType.authWrongPassword,
      message: 'Invalid email or password',
    );
  }
  
  if (lowerMessage.contains('network') || lowerMessage.contains('connection')) {
    return const ServerException(
      type: ServerExceptionType.general,
      message: 'Network error. Please check your connection.',
    );
  }

  return ServerException(
    type: ServerExceptionType.unknown,
    message: message,
  );
}
