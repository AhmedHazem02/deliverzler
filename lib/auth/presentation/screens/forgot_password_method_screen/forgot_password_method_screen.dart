import 'package:flutter/material.dart';

import '../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../core/presentation/routing/app_router.dart';
import '../../../../core/presentation/screens/full_screen_scaffold.dart';
import '../../components/auth_settings_bar.dart';

class ForgotPasswordMethodScreen extends StatelessWidget {
  const ForgotPasswordMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                Icons.lock_reset_outlined,
                size: 80,
                color: primaryColor,
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                tr(context).resetPassword,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                tr(context).chooseResetMethod,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Email reset card
              _ResetOptionCard(
                icon: Icons.email_outlined,
                iconColor: Colors.blue,
                title: tr(context).resetByEmail,
                subtitle: tr(context).resetByEmailDesc,
                onTap: () => const ForgotPasswordRoute().go(context),
              ),
              const SizedBox(height: 16),

              // Phone reset card
              _ResetOptionCard(
                icon: Icons.phone_android_outlined,
                iconColor: Colors.green,
                title: tr(context).resetByPhone,
                subtitle: tr(context).resetByPhoneDesc,
                onTap: () => const ForgotPasswordPhoneRoute().go(context),
              ),
              const SizedBox(height: 32),

              // Back to Sign In
              TextButton(
                onPressed: () => const SignInRoute().go(context),
                child: Text(tr(context).backToSignIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResetOptionCard extends StatelessWidget {
  const _ResetOptionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
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
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDark ? Colors.grey[500] : Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
