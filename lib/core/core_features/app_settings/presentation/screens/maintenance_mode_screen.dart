import 'package:flutter/material.dart';

import '../../../../presentation/utils/riverpod_framework.dart';
import '../app_settings_provider.dart';

/// A screen displayed when the app is in maintenance mode.
///
/// This screen blocks all user interaction and shows a friendly
/// message that the app is undergoing maintenance.
class MaintenanceModeScreen extends ConsumerWidget {
  const MaintenanceModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
              Theme.of(context).colorScheme.primary,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Maintenance icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.build_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),

                // Title
                const Text(
                  'قيد الصيانة',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Subtitle
                Text(
                  'نقوم حالياً بتحسين التطبيق\nسنعود قريباً!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Retry button
                OutlinedButton.icon(
                  onPressed: () {
                    // Invalidate and refresh settings
                    ref.invalidate(appSettingsProvider);
                    ref.invalidate(appSettingsStreamProvider);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'إعادة المحاولة',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A wrapper widget that checks for maintenance mode and shows
/// the appropriate screen.
///
/// Usage:
/// ```dart
/// MaintenanceModeWrapper(
///   child: MyApp(),
/// )
/// ```
class MaintenanceModeWrapper extends ConsumerWidget {
  const MaintenanceModeWrapper({
    required this.child,
    this.loadingWidget,
    super.key,
  });

  /// The main app widget to show when not in maintenance mode.
  final Widget child;

  /// Optional custom loading widget while checking maintenance status.
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsStreamProvider);

    return settingsAsync.when(
      data: (settings) {
        if (settings.general.maintenanceMode) {
          return const MaintenanceModeScreen();
        }
        return child;
      },
      loading: () => loadingWidget ?? child,
      error: (_, __) => child, // On error, show app normally
    );
  }
}
