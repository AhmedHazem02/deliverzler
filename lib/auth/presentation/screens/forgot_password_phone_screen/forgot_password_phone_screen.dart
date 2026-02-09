import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../core/presentation/routing/app_router.dart';
import '../../../../core/presentation/screens/full_screen_scaffold.dart';
import '../../../../core/presentation/styles/styles.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../core/presentation/widgets/custom_elevated_button.dart';
import '../../../../core/presentation/widgets/toasts.dart';
import '../../components/auth_settings_bar.dart';
import '../../providers/forgot_password_phone_provider.dart';

class ForgotPasswordPhoneScreen extends StatefulHookConsumerWidget {
  const ForgotPasswordPhoneScreen({super.key});

  @override
  ConsumerState<ForgotPasswordPhoneScreen> createState() =>
      _ForgotPasswordPhoneScreenState();
}

class _ForgotPasswordPhoneScreenState
    extends ConsumerState<ForgotPasswordPhoneScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordPhoneProvider);
    final notifier = ref.watch(forgotPasswordPhoneProvider.notifier);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Listen for completion
    ref.listen(forgotPasswordPhoneProvider, (previous, next) {
      if (next.isCompleted && !(previous?.isCompleted ?? false)) {
        Toasts.showTitledToast(
          context,
          title: tr(context).passwordUpdatedSuccessfully,
          description: tr(context).youCanNowSignIn,
        );
      }
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        Toasts.showTitledToast(
          context,
          title: tr(context).ops_err,
          description: next.errorMessage!,
        );
      }
    });

    // Timer for resend cooldown
    useEffect(
      () {
        if (notifier.secondsRemaining > 0) {
          final timer =
              Stream<int>.periodic(const Duration(seconds: 1), (i) => i)
                  .listen((_) {
            if (notifier.secondsRemaining <= 0) {
              ref.invalidate(forgotPasswordPhoneProvider);
            }
          });
          return timer.cancel;
        }
        return null;
      },
      [state.lastResendTime],
    );

    return FullScreenScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Settings bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AuthSettingsBar(),
                  if (state.step != ResetStep.done)
                    TextButton(
                      onPressed: () {
                        notifier.resetState();
                        const SignInRoute().go(context);
                      },
                      child: Text(tr(context).backToSignIn),
                    ),
                ],
              ),
              const SizedBox(height: 40),

              // Icon
              Icon(
                _getStepIcon(state.step),
                size: 80,
                color: state.step == ResetStep.done
                    ? Colors.green
                    : primaryColor,
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                _getStepTitle(context, state.step),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                _getStepSubtitle(context, state.step),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Step: Phone input
              if (state.step == ResetStep.phone) ...[
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    hintText: tr(context).phone,
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomElevatedButton(
                  enableGradient: true,
                  onPressed: state.isSendingOtp
                      ? null
                      : () {
                          if (_phoneController.text.trim().isEmpty) {
                            Toasts.showTitledToast(
                              context,
                              title: tr(context).ops_err,
                              description: tr(context).phoneNumberRequired,
                            );
                            return;
                          }
                          notifier.sendOtp(_phoneController.text.trim());
                        },
                  child: state.isSendingOtp
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          tr(context).sendOtpCode.toUpperCase(),
                          style: TextStyles.coloredElevatedButton(context),
                        ),
                ),
              ],

              // Step: OTP input
              if (state.step == ResetStep.otp) ...[
                // Show phone number
                Text(
                  _phoneController.text,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 12,
                      ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '000000',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                      letterSpacing: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    setState(() {});
                    if (value.length == 6 && state.verificationId != null) {
                      notifier.verifyOtp(value);
                    }
                  },
                ),
                const SizedBox(height: 24),
                CustomElevatedButton(
                  enableGradient: true,
                  onPressed: state.isVerifying || _otpController.text.length != 6
                      ? null
                      : () => notifier.verifyOtp(_otpController.text),
                  child: state.isVerifying
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          tr(context).verifyAndContinue.toUpperCase(),
                          style: TextStyles.coloredElevatedButton(context),
                        ),
                ),
                const SizedBox(height: 16),

                // Resend
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tr(context).didNotReceiveOtp,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark ? Colors.grey[500] : Colors.grey[600],
                          ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: notifier.canResend
                          ? () =>
                              notifier.resendOtp(_phoneController.text.trim())
                          : null,
                      child: Text(
                        notifier.secondsRemaining > 0
                            ? '${tr(context).resendIn} ${notifier.secondsRemaining}s'
                            : tr(context).resendOtp,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: notifier.canResend
                                  ? primaryColor
                                  : isDark
                                      ? Colors.grey[600]
                                      : Colors.grey[400],
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ],

              // Step: New password
              if (state.step == ResetStep.newPassword) ...[
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: tr(context).newPassword,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return tr(context).thisFieldIsEmpty;
                          }
                          if (value.length < 6) {
                            return tr(context)
                                .passwordMustBeAtLeast6Characters;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          hintText: tr(context).confirmPassword,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return tr(context).passwordsDoNotMatch;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      CustomElevatedButton(
                        enableGradient: true,
                        onPressed: state.isUpdatingPassword
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  notifier.updatePassword(
                                      _passwordController.text);
                                }
                              },
                        child: state.isUpdatingPassword
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                tr(context).updatePassword.toUpperCase(),
                                style:
                                    TextStyles.coloredElevatedButton(context),
                              ),
                      ),
                    ],
                  ),
                ),
              ],

              // Step: Done
              if (state.step == ResetStep.done) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        tr(context).passwordUpdatedSuccessfully,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                CustomElevatedButton(
                  enableGradient: true,
                  onPressed: () {
                    notifier.resetState();
                    const SignInRoute().go(context);
                  },
                  child: Text(
                    tr(context).backToSignIn.toUpperCase(),
                    style: TextStyles.coloredElevatedButton(context),
                  ),
                ),
              ],

              // Error state with retry (when OTP send fails at phone step)
              if (state.errorMessage != null &&
                  state.step == ResetStep.phone &&
                  !state.isSendingOtp) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    state.errorMessage!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.red[700],
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],

              const SizedBox(height: Sizes.marginV24),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStepIcon(ResetStep step) {
    return switch (step) {
      ResetStep.phone => Icons.phone_android_outlined,
      ResetStep.otp => Icons.sms_outlined,
      ResetStep.newPassword => Icons.lock_reset_outlined,
      ResetStep.done => Icons.check_circle_outline,
    };
  }

  String _getStepTitle(BuildContext context, ResetStep step) {
    return switch (step) {
      ResetStep.phone => tr(context).resetByPhone,
      ResetStep.otp => tr(context).verifyYourPhone,
      ResetStep.newPassword => tr(context).setNewPassword,
      ResetStep.done => tr(context).passwordUpdatedSuccessfully,
    };
  }

  String _getStepSubtitle(BuildContext context, ResetStep step) {
    return switch (step) {
      ResetStep.phone => tr(context).enterPhoneToReset,
      ResetStep.otp => tr(context).enterOtpCode,
      ResetStep.newPassword => tr(context).enterNewPasswordDesc,
      ResetStep.done => tr(context).youCanNowSignIn,
    };
  }
}
