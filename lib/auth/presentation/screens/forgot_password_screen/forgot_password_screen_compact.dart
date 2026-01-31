import 'package:flutter/material.dart';

import '../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../core/presentation/screens/full_screen_scaffold.dart';
import '../../components/auth_settings_bar.dart';
import '../../components/forgot_password_form_component.dart';
import '../../components/login_logo_component.dart';

class ForgotPasswordScreenCompact extends StatelessWidget {
  const ForgotPasswordScreenCompact({super.key});

  @override
  Widget build(BuildContext context) {
    return FullScreenScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Settings bar (Theme & Language)
              const AuthSettingsBar(),
              const SizedBox(height: 24),

              // Logo
              const LoginLogoComponent(),
              const SizedBox(height: 32),

              // Title
              Text(
                tr(context).resetPassword,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                tr(context).enterEmailToReset,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Form
              const ForgotPasswordFormComponent(),
            ],
          ),
        ),
      ),
    );
  }
}
