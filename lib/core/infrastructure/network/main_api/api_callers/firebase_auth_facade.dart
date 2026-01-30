import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../../presentation/utils/riverpod_framework.dart';
import '../../../error/app_exception.dart';
import '../extensions/firebase_error_extension.dart';

part 'firebase_auth_facade.g.dart';

//Our main API is Firebase
@Riverpod(keepAlive: true)
FirebaseAuthFacade firebaseAuthFacade(Ref ref) {
  return FirebaseAuthFacade(
    firebaseAuth: FirebaseAuth.instance,
  );
}

class FirebaseAuthFacade {
  FirebaseAuthFacade({
    required this.firebaseAuth,
  });

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
    return _errorHandler(
      () async {
        return firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      },
    );
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

