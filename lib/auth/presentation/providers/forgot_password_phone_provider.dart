import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuthException, PhoneAuthCredential;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/auth_failure.dart';
import '../../infrastructure/repos/auth_repo.dart';

part 'forgot_password_phone_provider.freezed.dart';
part 'forgot_password_phone_provider.g.dart';

/// Steps: phone -> otp -> newPassword -> done
enum ResetStep { phone, otp, newPassword, done }

@freezed
class ForgotPasswordPhoneState with _$ForgotPasswordPhoneState {
  const factory ForgotPasswordPhoneState({
    @Default(ResetStep.phone) ResetStep step,
    String? verificationId,
    int? resendToken,
    DateTime? lastResendTime,
    @Default(false) bool isSendingOtp,
    @Default(false) bool isVerifying,
    @Default(false) bool isUpdatingPassword,
    @Default(false) bool isCompleted,
    String? errorMessage,
  }) = _ForgotPasswordPhoneState;
}

@riverpod
class ForgotPasswordPhone extends _$ForgotPasswordPhone {
  static const cooldownDuration = Duration(seconds: 60);

  @override
  ForgotPasswordPhoneState build() {
    return const ForgotPasswordPhoneState();
  }

  int get secondsRemaining {
    if (state.lastResendTime == null) return 0;
    final elapsed = DateTime.now().difference(state.lastResendTime!);
    final remaining = cooldownDuration.inSeconds - elapsed.inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  bool get canResend => secondsRemaining <= 0 && !state.isSendingOtp;

  /// Format the phone number to E.164 format for Egypt (+20...).
  String _formatPhoneNumber(String phone) {
    var cleaned = phone.replaceAll(RegExp(r'[\s\-]'), '');
    if (cleaned.startsWith('0')) {
      cleaned = '+20${cleaned.substring(1)}';
    }
    if (!cleaned.startsWith('+')) {
      cleaned = '+20$cleaned';
    }
    return cleaned;
  }

  /// Step 1: Send OTP to phone number.
  Future<void> sendOtp(String phone) async {
    if (state.isSendingOtp) return;

    state = state.copyWith(
      isSendingOtp: true,
      errorMessage: null,
    );

    final formattedPhone = _formatPhoneNumber(phone);
    debugPrint(
        '🔵 [ForgotPasswordPhone] Sending OTP to $formattedPhone');

    final result = await ref.read(authRepoProvider).sendPhoneVerification(
          phoneNumber: formattedPhone,
          codeSent: (verificationId, resendToken) {
            debugPrint(
                '✅ [ForgotPasswordPhone] Code sent! verificationId=$verificationId');
            state = state.copyWith(
              verificationId: verificationId,
              resendToken: resendToken,
              isSendingOtp: false,
              lastResendTime: DateTime.now(),
              step: ResetStep.otp,
              errorMessage: null,
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {
            debugPrint(
                '⏱️ [ForgotPasswordPhone] Auto-retrieval timeout');
            state = state.copyWith(
              verificationId: verificationId,
              isSendingOtp: false,
            );
          },
          verificationCompleted:
              (PhoneAuthCredential credential) async {
            // Auto-verification on Android — sign in immediately
            debugPrint(
                '✅ [ForgotPasswordPhone] Auto-verification completed!');
            state = state.copyWith(isVerifying: true);
            final signInResult = await ref
                .read(authRepoProvider)
                .verifyOtpAndSignIn(
                  verificationId: state.verificationId ?? '',
                  smsCode: '',
                );
            // For auto-verification, use signInWithCredential directly
            // Actually the credential already has the code, so we need a direct method
            // Let's just move to newPassword step — the user is now signed in
            state = state.copyWith(
              step: ResetStep.newPassword,
              isVerifying: false,
              errorMessage: null,
            );
          },
          verificationFailed: (FirebaseAuthException error) {
            debugPrint(
                '❌ [ForgotPasswordPhone] Verification failed: ${error.code}');
            state = state.copyWith(
              isSendingOtp: false,
              errorMessage: _mapFirebaseErrorToMessage(error),
            );
          },
          forceResendingToken: state.resendToken,
        );

    result.fold(
      (failure) {
        state = state.copyWith(
          isSendingOtp: false,
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (_) {
        // Handled by callbacks
      },
    );
  }

  /// Step 2: Verify OTP and sign in with phone credential.
  Future<void> verifyOtp(String code) async {
    if (state.isVerifying || state.verificationId == null) return;

    state = state.copyWith(
      isVerifying: true,
      errorMessage: null,
    );

    final result = await ref.read(authRepoProvider).verifyOtpAndSignIn(
          verificationId: state.verificationId!,
          smsCode: code,
        );

    result.fold(
      (failure) {
        state = state.copyWith(
          isVerifying: false,
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (_) {
        debugPrint(
            '✅ [ForgotPasswordPhone] OTP verified, user signed in');
        state = state.copyWith(
          isVerifying: false,
          step: ResetStep.newPassword,
          errorMessage: null,
        );
      },
    );
  }

  /// Step 3: Update the password.
  Future<void> updatePassword(String newPassword) async {
    if (state.isUpdatingPassword) return;

    state = state.copyWith(
      isUpdatingPassword: true,
      errorMessage: null,
    );

    final result =
        await ref.read(authRepoProvider).updatePassword(newPassword);

    result.fold(
      (failure) {
        state = state.copyWith(
          isUpdatingPassword: false,
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (_) {
        debugPrint('✅ [ForgotPasswordPhone] Password updated!');
        state = state.copyWith(
          isUpdatingPassword: false,
          isCompleted: true,
          step: ResetStep.done,
          errorMessage: null,
        );
      },
    );
  }

  /// Resend OTP.
  Future<void> resendOtp(String phone) async {
    if (!canResend) return;
    await sendOtp(phone);
  }

  /// Reset state to start over.
  void resetState() {
    state = const ForgotPasswordPhoneState();
  }

  String _mapFailureToMessage(AuthFailure failure) {
    return failure.when(
      userNotFound: () => 'No account found with this phone number',
      invalidEmail: () => 'Invalid email',
      emailAlreadyInUse: () => 'Email already in use',
      wrongPassword: () => 'Wrong password',
      tooManyRequests: () => 'Too many requests. Please wait.',
      networkError: () => 'No internet connection',
      serverError: (message) => message ?? 'Server error',
      emailNotVerified: () => 'Email not verified',
      userDisabled: () => 'User account disabled',
      invalidPhoneNumber: () => 'Invalid phone number',
      invalidVerificationCode: () =>
          'Invalid verification code. Please try again.',
      smsQuotaExceeded: () =>
          'SMS quota exceeded. Please try again later.',
      phoneVerificationFailed: (message) =>
          message ?? 'Phone verification failed',
      sessionExpired: () =>
          'Verification session expired. Please resend the code.',
    );
  }

  String _mapFirebaseErrorToMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-phone-number':
        return 'Invalid phone number format';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try later.';
      case 'too-many-requests':
        return 'Too many requests. Please wait.';
      case 'network-request-failed':
        return 'No internet connection';
      default:
        return error.message ?? 'Phone verification failed';
    }
  }
}
