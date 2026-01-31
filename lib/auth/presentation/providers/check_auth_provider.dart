import 'dart:async';

import '../../../auth/domain/email_not_verified_exception.dart';
import '../../../auth/domain/user.dart';
import '../../../auth/infrastructure/repos/auth_repo.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../core/presentation/utils/riverpod_framework.dart';

part 'check_auth_provider.g.dart';

@riverpod
Future<User> checkAuth(Ref ref) async {
  try {
    final sub = ref.listen(authStateProvider.notifier, (prev, next) {});

    final uid = await ref.watch(authRepoProvider).getUserAuthUid();

    // CRITICAL: Check email verification status from server
    final verificationResult =
        await ref.watch(authRepoProvider).checkEmailVerified();

    final isVerified = verificationResult.fold(
      (failure) => false,
      (verified) => verified,
    );

    if (!isVerified) {
      // Get user data to retrieve email
      final user = await ref.watch(authRepoProvider).getUserData(uid);
      // Don't authenticate, throw exception to redirect to verification
      throw EmailNotVerifiedException(email: user.email);
    }

    final user = await ref.watch(authRepoProvider).getUserData(uid);

    // Authenticate user after email verification confirmed
    sub.read().authenticateUser(user);

    return user;
  } catch (e) {
    // On web, Firebase auth might fail due to tracking prevention
    rethrow;
  }
}
