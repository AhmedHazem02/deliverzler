import 'package:flutter/material.dart';

import '../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../core/presentation/routing/app_router.dart';
import '../../../../core/presentation/screens/full_screen_scaffold.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../core/presentation/widgets/toasts.dart';
import '../../../infrastructure/repos/auth_repo.dart';
import '../../components/auth_settings_bar.dart';

class VerificationMethodScreen extends ConsumerWidget {
  const VerificationMethodScreen({
    required this.email,
    required this.phone,
    required this.uid,
    super.key,
  });

  final String email;
  final String phone;
  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FullScreenScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Settings bar
              const AuthSettingsBar(),
              const SizedBox(height: 40),

              // Icon
              Icon(
                Icons.verified_user_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                tr(context).chooseVerificationMethod,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                tr(context).chooseVerificationMethodDesc,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Email verification card
              _VerificationOptionCard(
                icon: Icons.email_outlined,
                iconColor: Colors.blue,
                title: tr(context).verifyByEmail,
                subtitle: tr(context).verifyByEmailDesc,
                detail: email,
                onTap: () async {
                  // Save chosen method
                  await ref.read(authRepoProvider).setVerificationMethod(
                        uid: uid,
                        method: 'email',
                      );
                  // Send email verification
                  await ref.read(authRepoProvider).sendEmailVerification();

                  if (!context.mounted) return;
                  EmailVerificationRoute(email: email).go(context);
                },
              ),
              const SizedBox(height: 16),

              // Phone verification card
              _VerificationOptionCard(
                icon: Icons.phone_android_outlined,
                iconColor: Colors.green,
                title: tr(context).verifyByPhone,
                subtitle: tr(context).verifyByPhoneDesc,
                detail: phone,
                onTap: () async {
                  if (phone.isEmpty) {
                    Toasts.showTitledToast(
                      context,
                      title: tr(context).ops_err,
                      description: tr(context).phoneNumberRequired,
                    );
                    return;
                  }
                  // Save chosen method
                  await ref.read(authRepoProvider).setVerificationMethod(
                        uid: uid,
                        method: 'phone',
                      );

                  if (!context.mounted) return;
                  PhoneVerificationRoute(phone: phone).go(context);
                },
              ),
              const SizedBox(height: 32),

              // Sign out option
              Center(
                child: TextButton.icon(
                  onPressed: () async {
                    await ref.read(authRepoProvider).signOut();
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerificationOptionCard extends StatelessWidget {
  const _VerificationOptionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    if (detail.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        detail,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
