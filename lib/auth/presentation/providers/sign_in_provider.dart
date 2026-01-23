import 'package:flutter/foundation.dart';

import '../../../core/infrastructure/notification/notification_service.dart';
import '../../../core/presentation/utils/fp_framework.dart';
import '../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/sign_in_with_email.dart';
import '../../domain/user.dart';
import '../../infrastructure/repos/auth_repo.dart';
import 'auth_state_provider.dart';

part 'sign_in_provider.g.dart';

//Using [Option] to indicate idle(none)/success(some) states.
//This is a shorthand. You can use custom states using [freezed] instead.
@riverpod
class SignInState extends _$SignInState {
  @override
  FutureOr<Option<User>> build() => const None();

  Future<void> signIn(SignInWithEmail params) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      debugPrint('🔐 [SignIn] Starting sign in...');

      final authRepo = ref.read(authRepoProvider);

      debugPrint('🔐 [SignIn] Step 1: Signing in with email...');
      final userFromCredential = await authRepo.signInWithEmail(params);
      debugPrint(
          '🔐 [SignIn] Step 1 SUCCESS: User ID = ${userFromCredential.id}');

      debugPrint('🔐 [SignIn] Step 2: Getting user data...');
      final user = await authRepo.getUserData(userFromCredential.id);
      debugPrint('🔐 [SignIn] Step 2 SUCCESS: User name = ${user.name}');

      debugPrint('🔐 [SignIn] Step 3: Subscribing to notifications...');
      await ref.read(notificationServiceProvider).subscribeToTopic('general');
      debugPrint('🔐 [SignIn] Step 3 SUCCESS');

      debugPrint('🔐 [SignIn] Step 4: Authenticating user...');
      ref.read(authStateProvider.notifier).authenticateUser(user);
      debugPrint('🔐 [SignIn] Step 4 SUCCESS - Login complete!');

      return Some(user);
    });

    // Log any errors
    state.whenOrNull(
      error: (error, stackTrace) {
        debugPrint('❌ [SignIn] ERROR: $error');
        debugPrint('❌ [SignIn] Stack trace: $stackTrace');
      },
    );
  }

  Future<void> logOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepoProvider);
      await authRepo.signOut();
      await ref
          .read(notificationServiceProvider)
          .unsubscribeFromTopic('general');

      ref.read(authStateProvider.notifier).unAuthenticateUser();

      return const None();
    });
  }
}
