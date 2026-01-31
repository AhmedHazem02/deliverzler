import 'package:flutter/material.dart';

import '../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../core/presentation/screens/full_screen_scaffold.dart';
import '../../components/auth_settings_bar.dart';
import '../../components/forgot_password_form_component.dart';
import '../../components/login_logo_component.dart';

class ForgotPasswordScreenMedium extends StatelessWidget {
  const ForgotPasswordScreenMedium({super.key});

  @override
  Widget build(BuildContext context) {
    return FullScreenScaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(48),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Settings bar (Theme & Language)
                  const AuthSettingsBar(),
                  const SizedBox(height: 32),

                  // Logo
                  const LoginLogoComponent(),
                  const SizedBox(height: 40),

                  // Title
                  Text(
                    tr(context).resetPassword,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    tr(context).enterEmailToReset,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Form
                  const ForgotPasswordFormComponent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
