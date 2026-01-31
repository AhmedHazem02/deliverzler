import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/presentation/utils/fp_framework.dart';
import '../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/auth_failure.dart';
import '../../infrastructure/repos/auth_repo.dart';

part 'forgot_password_provider.freezed.dart';
part 'forgot_password_provider.g.dart';

@freezed
class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    DateTime? lastSentTime,
    @Default(false) bool emailSent,
  }) = _ForgotPasswordState;
}

@riverpod
class ForgotPassword extends _$ForgotPassword {
  static const cooldownDuration = Duration(seconds: 60);

  @override
  ForgotPasswordState build() {
    return const ForgotPasswordState();
  }

  int get secondsRemaining {
    if (state.lastSentTime == null) return 0;
    final elapsed = DateTime.now().difference(state.lastSentTime!);
    final remaining = cooldownDuration.inSeconds - elapsed.inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  bool get canSend => secondsRemaining <= 0;

  Future<Either<AuthFailure, Unit>> sendPasswordResetEmail(String email) async {
    if (!canSend) {
      return left(const AuthFailure.tooManyRequests());
    }

    final result =
        await ref.read(authRepoProvider).sendPasswordResetEmail(email);

    return result.fold(
      (failure) => left(failure),
      (_) {
        state = ForgotPasswordState(
          lastSentTime: DateTime.now(),
          emailSent: true,
        );
        return right(unit);
      },
    );
  }

  void resetState() {
    state = const ForgotPasswordState();
  }
}
