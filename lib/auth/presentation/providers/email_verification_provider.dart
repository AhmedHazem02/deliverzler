import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/presentation/utils/fp_framework.dart';
import '../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/auth_failure.dart';
import '../../infrastructure/repos/auth_repo.dart';
import 'auth_state_provider.dart';

part 'email_verification_provider.freezed.dart';
part 'email_verification_provider.g.dart';

@freezed
class EmailVerificationState with _$EmailVerificationState {
  const factory EmailVerificationState({
    required String email,
    DateTime? lastResendTime,
    @Default(false) bool isChecking,
    @Default(false) bool isVerified,
    String? errorMessage,
  }) = _EmailVerificationState;
}

@riverpod
class EmailVerification extends _$EmailVerification {
  static const cooldownDuration = Duration(seconds: 60);
  Timer? _periodicCheckTimer;

  @override
  EmailVerificationState build(String email) {
    // Setup periodic check every 5 seconds
    _startPeriodicCheck();

    // Cleanup on dispose
    ref.onDispose(() {
      _periodicCheckTimer?.cancel();
    });

    return EmailVerificationState(email: email);
  }

  int get secondsRemaining {
    if (state.lastResendTime == null) return 0;
    final elapsed = DateTime.now().difference(state.lastResendTime!);
    final remaining = cooldownDuration.inSeconds - elapsed.inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  bool get canResend => secondsRemaining <= 0;

  void _startPeriodicCheck() {
    _periodicCheckTimer?.cancel();
    _periodicCheckTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => checkVerificationStatus(silent: true),
    );
  }

  Future<void> checkVerificationStatus({bool silent = false}) async {
    if (state.isChecking && !silent)
      return; // Prevent multiple simultaneous checks

    if (!silent) {
      state = state.copyWith(isChecking: true, errorMessage: null);
    }

    final result = await ref.read(authRepoProvider).checkEmailVerified();

    result.fold(
      (failure) {
        if (!silent) {
          state = state.copyWith(
            isChecking: false,
            errorMessage: _mapFailureToMessage(failure),
          );
        }
      },
      (isVerified) {
        if (isVerified) {
          state = state.copyWith(
            isChecking: false,
            isVerified: true,
            errorMessage: null,
          );
          _periodicCheckTimer?.cancel();
          // Note: Navigation will be handled by the UI layer
        } else if (!silent) {
          state = state.copyWith(
            isChecking: false,
            errorMessage: null,
          );
        }
      },
    );
  }

  Future<void> resendVerificationEmail() async {
    if (!canResend) {
      state = state.copyWith(
        errorMessage: 'Please wait before resending',
      );
      return;
    }

    state = state.copyWith(errorMessage: null);

    final result = await ref.read(authRepoProvider).sendEmailVerification();

    result.fold(
      (failure) {
        state = state.copyWith(
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (_) {
        state = state.copyWith(
          lastResendTime: DateTime.now(),
          errorMessage: null,
        );
      },
    );
  }

  Future<void> signOutAndGoBack() async {
    _periodicCheckTimer?.cancel();
    await ref.read(authRepoProvider).signOut();
    ref.read(authStateProvider.notifier).unAuthenticateUser();
  }

  String _mapFailureToMessage(AuthFailure failure) {
    return failure.when(
      userNotFound: () => 'User not found',
      invalidEmail: () => 'Invalid email',
      emailAlreadyInUse: () => 'Email already in use',
      wrongPassword: () => 'Wrong password',
      tooManyRequests: () => 'Too many requests. Please wait.',
      networkError: () => 'No internet connection',
      serverError: (message) => message ?? 'Server error',
      emailNotVerified: () => 'Email not verified',
      userDisabled: () => 'User account disabled',
    );
  }
}
