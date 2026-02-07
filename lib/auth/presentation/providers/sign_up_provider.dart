import 'package:flutter/foundation.dart';

import '../../../core/presentation/utils/fp_framework.dart';
import '../../../core/presentation/utils/riverpod_framework.dart';
import '../../infrastructure/repos/auth_repo.dart';
import '../../../core/infrastructure/error/app_exception.dart';
import '../../domain/auth_failure.dart';
import '../../domain/user.dart';

part 'sign_up_provider.g.dart';

@riverpod
class SignUpState extends _$SignUpState {
  @override
  FutureOr<Option<User>> build() => const None();

  Future<void> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    state = const AsyncLoading();

    try {
      final authRepo = ref.read(authRepoProvider);
      final user = await authRepo.registerWithEmail(
        email: email,
        password: password,
        name: name,
      );

      final verificationResult = await authRepo.sendEmailVerification();
      verificationResult.fold(
        (failure) {
          throw failure.when(
            userNotFound: () => const ServerException(
              type: ServerExceptionType.authUserNotFound,
              message: 'User not found',
            ),
            invalidEmail: () => const ServerException(
              type: ServerExceptionType.authInvalidEmail,
              message: 'Invalid email',
            ),
            emailAlreadyInUse: () => const ServerException(
              type: ServerExceptionType.authEmailAlreadyInUse,
              message: 'Email already in use',
            ),
            wrongPassword: () => const ServerException(
              type: ServerExceptionType.authWrongPassword,
              message: 'Wrong password',
            ),
            tooManyRequests: () => const ServerException(
              type: ServerExceptionType.authTooManyRequests,
              message: 'Too many requests',
            ),
            userDisabled: () => const ServerException(
              type: ServerExceptionType.authUserDisabled,
              message: 'User disabled',
            ),
            networkError: () => const ServerException(
              type: ServerExceptionType.noInternet,
              message: 'Network error',
            ),
            serverError: (msg) => ServerException(
              type: ServerExceptionType.unknown,
              message: msg ?? 'Unknown error',
            ),
            emailNotVerified: () => const ServerException(
              type: ServerExceptionType.general,
              message: 'Email not verified',
            ),
          );
        },
        (_) {},
      );

      final fullUser = await authRepo.getUserData(user.id);
      state = AsyncData(Some(fullUser));
    } catch (e, st) {
      if (e is AppException) {
        state = AsyncError(e, st);
      } else {
        // Convert error to safe string to avoid JS interop TypeErrors
        final errString = e.toString();
        state = AsyncError(errString, st);
      }
    }
  }
}
