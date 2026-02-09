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
import '../../providers/phone_verification_provider.dart';

class PhoneVerificationScreen extends StatefulHookConsumerWidget {
  const PhoneVerificationScreen({required this.phone, super.key});

  final String phone;

  @override
  ConsumerState<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState
    extends ConsumerState<PhoneVerificationScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    // Send OTP immediately on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(phoneVerificationProvider(widget.phone).notifier).sendOtp();
    });
  }

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _otpControllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    final verificationState =
        ref.watch(phoneVerificationProvider(widget.phone));
    final notifier =
        ref.watch(phoneVerificationProvider(widget.phone).notifier);

    // Listen for verification success
    ref.listen(phoneVerificationProvider(widget.phone), (previous, next) {
      if (next.isVerified && !(previous?.isVerified ?? false)) {
        Toasts.showTitledToast(
          context,
          title: tr(context).phoneVerifiedSuccessfully,
          description: tr(context).redirectingToHome,
        );
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            const ApplicationStatusGateRoute().go(context);
          }
        });
      }

      // Show error toast
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
              ref.invalidate(phoneVerificationProvider(widget.phone));
            }
          });
          return timer.cancel;
        }
        return null;
      },
      [verificationState.lastResendTime],
    );

    return FullScreenScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Settings bar with logout option
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AuthSettingsBar(),
                  TextButton.icon(
                    onPressed: () async {
                      await notifier.signOutAndGoBack();
                      if (context.mounted) {
                        const SignInRoute().go(context);
                      }
                    },
                    icon: const Icon(Icons.logout, size: 20),
                    label: Text(tr(context).logOut),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Icon
              Icon(
                Icons.phone_android_outlined,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                tr(context).verifyYourPhone,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // OTP sent message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.green.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    if (verificationState.isSendingOtp) ...[
                      const CircularProgressIndicator(strokeWidth: 2),
                      const SizedBox(height: 8),
                      Text(
                        tr(context).sendingOtp,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ] else ...[
                      Text(
                        tr(context).otpSentTo,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.phone,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        tr(context).enterOtpCode,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Auto-verifying indicator
              if (verificationState.autoVerifying) ...[
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 12),
                Text(
                  tr(context).autoVerifying,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.green,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
              ],

              // Error state with retry
              if (verificationState.errorMessage != null &&
                  verificationState.verificationId == null &&
                  !verificationState.isSendingOtp) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: Colors.red.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        verificationState.errorMessage!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.red,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => notifier.sendOtp(),
                        icon: const Icon(Icons.refresh),
                        label: Text(tr(context).resendOtp),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // OTP input fields — always visible when not auto-verifying
              if (!verificationState.autoVerifying &&
                  !verificationState.isSendingOtp) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 45,
                      height: 55,
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          }
                          if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                          // Rebuild so the Verify button enables/disables
                          setState(() {});
                          // Auto-submit when all 6 digits entered
                          if (_otpCode.length == 6 &&
                              verificationState.verificationId != null) {
                            notifier.verifyOtp(_otpCode);
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),

                // Verify button
                CustomElevatedButton(
                  enableGradient: true,
                  onPressed:
                      verificationState.isVerifying || _otpCode.length != 6
                          ? null
                          : () => notifier.verifyOtp(_otpCode),
                  child: verificationState.isVerifying
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
                const SizedBox(height: Sizes.marginV16),
              ],

              // Resend button
              OutlinedButton(
                onPressed: notifier.canResend ? notifier.resendOtp : null,
                child: notifier.secondsRemaining > 0
                    ? Text(
                        '${tr(context).resendIn} ${notifier.secondsRemaining} ${tr(context).seconds}',
                      )
                    : Text(tr(context).resendOtp),
              ),
              const SizedBox(height: Sizes.marginV24),

              // Help text
              Text(
                tr(context).didNotReceiveOtp,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                tr(context).checkPhoneNumber,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
