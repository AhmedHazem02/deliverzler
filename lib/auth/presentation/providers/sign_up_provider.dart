import '../../../core/presentation/utils/fp_framework.dart';
import '../../../core/presentation/utils/riverpod_framework.dart';
import '../../infrastructure/repos/auth_repo.dart';
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
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepoProvider);

      // Create user account
      final user = await authRepo.registerWithEmail(
        email: email,
        password: password,
        name: name,
      );

      // Send email verification immediately
      await authRepo.sendEmailVerification();

      final fullUser = await authRepo.getUserData(user.id);

      // Note: We don't authenticate the user here because:
      // 1. Email needs to be verified first
      // 2. Account needs admin approval
      // User will be redirected to email verification screen

      return Some(fullUser);
    });
  }
}
