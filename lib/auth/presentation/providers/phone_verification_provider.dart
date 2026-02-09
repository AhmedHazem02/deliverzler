import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuthException, PhoneAuthCredential;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/auth_failure.dart';
import '../../infrastructure/repos/auth_repo.dart';
import 'auth_state_provider.dart';

part 'phone_verification_provider.freezed.dart';
part 'phone_verification_provider.g.dart';

@freezed
class PhoneVerificationState with _$PhoneVerificationState {
  const factory PhoneVerificationState({
    required String phone,
    String? verificationId,
    int? resendToken,
    DateTime? lastResendTime,
    @Default(false) bool isSendingOtp,
    @Default(false) bool isVerifying,
    @Default(false) bool isVerified,
    @Default(false) bool autoVerifying,
    String? errorMessage,
  }) = _PhoneVerificationState;
}

@riverpod
class PhoneVerification extends _$PhoneVerification {
  static const cooldownDuration = Duration(seconds: 60);

  @override
  PhoneVerificationState build(String phone) {
    return PhoneVerificationState(phone: phone);
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
    // Remove spaces and dashes
    var cleaned = phone.replaceAll(RegExp(r'[\s\-]'), '');
    // If starts with 0, replace with +20
    if (cleaned.startsWith('0')) {
      cleaned = '+20${cleaned.substring(1)}';
    }
    // If doesn't start with +, add +20
    if (!cleaned.startsWith('+')) {
      cleaned = '+20$cleaned';
    }
    return cleaned;
  }

  /// Send OTP to the phone number.
  Future<void> sendOtp() async {
    if (state.isSendingOtp) return;

    state = state.copyWith(
      isSendingOtp: true,
      errorMessage: null,
    );

    final formattedPhone = _formatPhoneNumber(state.phone);
    debugPrint('🔵 [PhoneVerification] Sending OTP to $formattedPhone');

    final result = await ref.read(authRepoProvider).sendPhoneVerification(
          phoneNumber: formattedPhone,
          codeSent: (verificationId, resendToken) {
            debugPrint(
                '✅ [PhoneVerification] Code sent! verificationId=$verificationId');
            state = state.copyWith(
              verificationId: verificationId,
              resendToken: resendToken,
              isSendingOtp: false,
              lastResendTime: DateTime.now(),
              errorMessage: null,
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {
            debugPrint(
                '⏱️ [PhoneVerification] Auto-retrieval timeout, verificationId=$verificationId');
            // Update verificationId in case it changed
            state = state.copyWith(
              verificationId: verificationId,
              isSendingOtp: false,
            );
          },
          verificationCompleted: (PhoneAuthCredential credential) async {
            // Auto-verification (Android only) — link phone immediately
            debugPrint('✅ [PhoneVerification] Auto-verification completed!');
            state = state.copyWith(autoVerifying: true);
            final linkResult = await ref
                .read(authRepoProvider)
                .linkPhoneCredential(credential);
            linkResult.fold(
              (failure) {
                state = state.copyWith(
                  autoVerifying: false,
                  errorMessage: _mapFailureToMessage(failure),
                );
              },
              (_) {
                state = state.copyWith(
                  isVerified: true,
                  autoVerifying: false,
                  isVerifying: false,
                  errorMessage: null,
                );
              },
            );
          },
          verificationFailed: (FirebaseAuthException error) {
            debugPrint(
                '❌ [PhoneVerification] Verification failed: ${error.code} - ${error.message}');
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
        // Success is handled by the callbacks above
      },
    );
  }

  /// Verify the OTP code entered by the user.
  Future<void> verifyOtp(String code) async {
    if (state.isVerifying || state.isVerified || state.verificationId == null)
      return;

    state = state.copyWith(
      isVerifying: true,
      errorMessage: null,
    );

    final result = await ref.read(authRepoProvider).verifyOtpAndLinkPhone(
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
        state = state.copyWith(
          isVerified: true,
          isVerifying: false,
          errorMessage: null,
        );
      },
    );
  }

  /// Resend OTP with cooldown.
  Future<void> resendOtp() async {
    if (!canResend) {
      state = state.copyWith(
        errorMessage: 'Please wait before resending',
      );
      return;
    }
    await sendOtp();
  }

  Future<void> signOutAndGoBack() async {
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
      invalidPhoneNumber: () => 'Invalid phone number',
      invalidVerificationCode: () =>
          'Invalid verification code. Please try again.',
      smsQuotaExceeded: () => 'SMS quota exceeded. Please try again later.',
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
