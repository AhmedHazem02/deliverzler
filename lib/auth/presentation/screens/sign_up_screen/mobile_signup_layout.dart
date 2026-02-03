import 'package:flutter/material.dart';

import '../../../../core/presentation/helpers/localization_helper.dart';
import '../../components/auth_settings_bar.dart';
import '../../components/driver_signup_form_component.dart';

class MobileSignupLayout extends StatelessWidget {
  const MobileSignupLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Settings bar (Theme & Language)
          const AuthSettingsBar(),
          const SizedBox(height: 16),
          // Header
          Text(
            tr(context).driverApplicationTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            tr(context).driverApplicationSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const DriverSignupFormComponent(),
        ],
      ),
    );
  }
}
