import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../core/presentation/styles/styles.dart';
import '../../../../core/presentation/widgets/custom_elevated_button.dart';
import '../../components/auth_settings_bar.dart';
import '../../components/driver_signup_form_component.dart';

class DesktopSignupLayout extends StatelessWidget {
  const DesktopSignupLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Color / Pattern
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),

          // Top Navigation Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  TextButton.icon(
                    onPressed: () => context.go('/'),
                    icon: const Icon(Icons.arrow_back),
                    label: Text(tr(context).back),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                  // Settings Bar
                  const AuthSettingsBar(),
                ],
              ),
            ),
          ),

          // Centered Form
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 80.0),
              child: Container(
                width: 600, // Fixed width constraint
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: FocusTraversalGroup(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo or Title
                      Text(
                        tr(context).driverApplicationTitle,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
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
                      const SizedBox(height: 40),

                      // The Actual Form
                      const DriverSignupFormComponent(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
