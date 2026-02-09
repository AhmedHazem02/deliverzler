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
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(phoneVerificationProvider(widget.phone).notifier).sendOtp();
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verificationState =
        ref.watch(phoneVerificationProvider(widget.phone));
    final notifier =
        ref.watch(phoneVerificationProvider(widget.phone).notifier);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withValues(alpha: 0.15),
                      primaryColor.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  Icons.phone_android_outlined,
                  size: 50,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                tr(context).verifyYourPhone,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Subtitle with phone number
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        height: 1.5,
                      ),
                  children: [
                    TextSpan(text: '${tr(context).otpSentTo}\n'),
                    TextSpan(
                      text: widget.phone,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Loading state
              if (verificationState.isSendingOtp) ...[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        tr(context).sendingOtp,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],

              // Auto-verifying indicator
              if (verificationState.autoVerifying) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        tr(context).autoVerifying,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
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
                    color: Colors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 36),
                      const SizedBox(height: 8),
                      Text(
                        verificationState.errorMessage!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.red[700],
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => notifier.sendOtp(),
                        icon: const Icon(Icons.refresh, size: 18),
                        label: Text(tr(context).resendOtp),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // OTP input — single invisible field + visual digit boxes
              if (!verificationState.autoVerifying &&
                  !verificationState.isSendingOtp) ...[
                Text(
                  tr(context).enterOtpCode,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _otpController,
                  focusNode: _otpFocusNode,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  autofocus: true,
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
                    if (value.length == 6 &&
                        verificationState.verificationId != null) {
                      notifier.verifyOtp(value);
                    }
                  },
                ),
                const SizedBox(height: 32),

                // Verify button
                CustomElevatedButton(
                  enableGradient: true,
                  onPressed: verificationState.isVerifying ||
                          _otpController.text.length != 6
                      ? null
                      : () => notifier.verifyOtp(_otpController.text),
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

              // Resend section
              const SizedBox(height: 8),
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
                    onTap: notifier.canResend ? notifier.resendOtp : null,
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
              const SizedBox(height: Sizes.marginV24),
            ],
          ),
        ),
      ),
    );
  }
}
