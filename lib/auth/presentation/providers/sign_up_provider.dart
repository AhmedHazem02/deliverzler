import '../../../core/infrastructure/notification/notification_service.dart';
import '../../../core/presentation/utils/fp_framework.dart';
import '../../../core/presentation/utils/riverpod_framework.dart';
import '../../infrastructure/repos/auth_repo.dart';
import '../../domain/user.dart';
import 'auth_state_provider.dart';

part 'sign_up_provider.g.dart';

@riverpod
class SignUpState extends _$SignUpState {
  @override
  FutureOr<Option<User>> build() => const None();

  Future<void> signUp(
      {required String email, required String password, String? name,}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepoProvider);
      final user = await authRepo.registerWithEmail(
          email: email, password: password, name: name,);
      final fullUser = await authRepo.getUserData(user.id);
      await ref.read(notificationServiceProvider).subscribeToTopic('general');

      ref.read(authStateProvider.notifier).authenticateUser(fullUser);

      return Some(fullUser);
    });
  }
}
