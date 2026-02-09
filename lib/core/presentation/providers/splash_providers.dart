import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../auth/presentation/providers/check_auth_provider.dart';
import '../../core_features/locale/presentation/providers/app_locale_provider.dart';
import '../../core_features/theme/presentation/providers/app_theme_provider.dart';
import '../../infrastructure/network/network_info.dart';
import '../../infrastructure/notification/notification_service.dart';
import '../extensions/future_extensions.dart';
import '../routing/app_router.dart';
import '../utils/riverpod_framework.dart';

part 'splash_providers.g.dart';

@Riverpod(keepAlive: true)
Future<void> splashServicesWarmup(Ref ref) async {
  dev.log('splashServicesWarmup: Starting...');
  final min =
      Future<void>.delayed(const Duration(seconds: 1)); //Min Time of splash
  final s1 = ref.watch(appThemeControllerProvider.future).suppressError();
  final s2 = ref.watch(appLocaleControllerProvider.future).suppressError();
  final s3 = Future<void>(() async {
    try {
      dev.log('splashServicesWarmup: Setting up notifications...');
      await ref.read(setupFlutterNotificationsProvider.future);
      await ref.read(requestNotificationPermissionsProvider.future);
      dev.log('splashServicesWarmup: Notifications setup complete');
    } catch (e) {
      dev.log('splashServicesWarmup: Notifications failed: $e');
      // Notifications may fail on web due to tracking prevention
      // Continue without notifications
    }
  });

  // Auth check with timeout for web platform
  final s4 = Future<void>(() async {
    try {
      dev.log('splashServicesWarmup: Checking auth...');
      // Increased timeout for web to handle Firebase persistence loading
      const timeout = kIsWeb ? Duration(seconds: 20) : Duration(seconds: 15);
      await ref.read(checkAuthProvider.future).timeout(timeout);
      dev.log('splashServicesWarmup: Auth check complete');
    } catch (e, st) {
      dev.log('splashServicesWarmup: Auth check failed/timed out: $e');
      dev.log('splashServicesWarmup: Stacktrace: $st');
      // Auth may fail on web due to tracking prevention or timeout
      // User will be redirected to sign in
    }
  });

  try {
    await [min, s1, s2, s3, s4].wait.throwAllErrors();
    dev.log('splashServicesWarmup: All services warmed up successfully');
  } catch (e) {
    dev.log('splashServicesWarmup: Error during warmup: $e');
    rethrow;
  }
}

@riverpod
Future<String> splashTarget(Ref ref) async {
  final hasConnection =
      await ref.watch(networkInfoProvider).hasInternetConnection;
  if (hasConnection) {
    return const SignInRoute().location;
  } else {
    return const NoInternetRoute().location;
  }
}
