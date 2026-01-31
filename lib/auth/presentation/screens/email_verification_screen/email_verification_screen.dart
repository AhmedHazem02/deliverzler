import 'package:flutter/material.dart';

import '../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../core/presentation/routing/app_router.dart';
import '../../../../core/presentation/screens/full_screen_scaffold.dart';
import '../../../../core/presentation/styles/styles.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../core/presentation/widgets/custom_elevated_button.dart';
import '../../../../core/presentation/widgets/toasts.dart';
import '../../components/auth_settings_bar.dart';
import '../../providers/email_verification_provider.dart';

class EmailVerificationScreen extends StatefulHookConsumerWidget {
  const EmailVerificationScreen({super.key, required this.email});

  final String email;

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When user returns to app (from email app), check verification status
    if (state == AppLifecycleState.resumed) {
      ref
          .read(emailVerificationProvider(widget.email).notifier)
          .checkVerificationStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final verificationState =
        ref.watch(emailVerificationProvider(widget.email));
    final notifier =
        ref.watch(emailVerificationProvider(widget.email).notifier);

    // Listen for verification success
    ref.listen(emailVerificationProvider(widget.email), (previous, next) {
      if (next.isVerified && !previous!.isVerified) {
        Toasts.showTitledToast(
          context,
          title: tr(context).emailVerifiedSuccessfully,
          description: tr(context).redirectingToHome,
        );
        // Navigate to application status gate
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

    // Auto-update for cooldown timer
    useEffect(() {
      if (notifier.secondsRemaining > 0) {
        final timer = Stream.periodic(const Duration(seconds: 1)).listen((_) {
          if (notifier.secondsRemaining <= 0) {
            ref.invalidate(emailVerificationProvider(widget.email));
          }
        });
        return timer.cancel;
      }
      return null;
    }, [verificationState.lastResendTime]);

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
                Icons.mark_email_unread_outlined,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                tr(context).verifyYourEmail,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Email sent message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      tr(context).checkYourInbox,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.email,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tr(context).clickLinkInEmail,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Wrong email banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr(context).wrongEmailQuestion,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tr(context).logOut,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Check verification button
              CustomElevatedButton(
                enableGradient: true,
                onPressed: verificationState.isChecking
                    ? null
                    : () => notifier.checkVerificationStatus(),
                child: verificationState.isChecking
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

              // Resend button
              OutlinedButton(
                onPressed: notifier.canResend
                    ? () => notifier.resendVerificationEmail()
                    : null,
                child: notifier.secondsRemaining > 0
                    ? Text(
                        '${tr(context).resendIn} ${notifier.secondsRemaining} ${tr(context).seconds}',
                      )
                    : Text(tr(context).resendVerificationEmail),
              ),
              const SizedBox(height: Sizes.marginV24),

              // Help text
              Text(
                tr(context).didNotReceiveEmail,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                tr(context).checkSpamFolder,
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
