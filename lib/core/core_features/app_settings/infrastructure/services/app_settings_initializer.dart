import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/app_settings_provider.dart';

/// Service to initialize and preload app settings during app startup.
///
/// This ensures settings are available immediately when needed,
/// reducing latency and providing a better user experience.
class AppSettingsInitializer {
  const AppSettingsInitializer._();

  /// Initialize app settings during app startup.
  ///
  /// This method should be called early in the app initialization process
  /// to ensure settings are cached and ready for use.
  ///
  /// [container] - The Riverpod ProviderContainer
  /// [timeout] - Maximum time to wait for settings (default: 5 seconds)
  ///
  /// Returns `true` if settings were loaded successfully, `false` otherwise.
  /// The app can continue even if this fails, as settings will be
  /// fetched on-demand when needed.
  static Future<bool> initialize(
    ProviderContainer container, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      log('AppSettingsInitializer: Starting settings preload...');

      // Preload settings with timeout
      await container.read(appSettingsProvider.future).timeout(timeout);

      log('AppSettingsInitializer: Settings preloaded successfully');
      return true;
    } catch (e, stack) {
      log(
        'AppSettingsInitializer: Failed to preload settings: $e',
        error: e,
        stackTrace: stack,
      );
      // Return false but don't throw - app can continue without preloaded settings
      return false;
    }
  }

  /// Check if the app is in maintenance mode.
  ///
  /// This should be called after [initialize] to determine if the app
  /// should show a maintenance screen.
  ///
  /// Returns `null` if settings couldn't be loaded.
  static Future<bool?> isMaintenanceMode(ProviderContainer container) async {
    try {
      final settings = await container.read(appSettingsProvider.future);
      return settings.general.maintenanceMode;
    } catch (e) {
      log('AppSettingsInitializer: Could not check maintenance mode: $e');
      return null;
    }
  }
}
