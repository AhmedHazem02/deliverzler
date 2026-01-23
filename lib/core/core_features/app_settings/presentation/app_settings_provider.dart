/// App Settings Providers.
///
/// Provides reactive access to app settings throughout the application
/// with automatic caching and real-time updates.
library;

import '../../../presentation/utils/riverpod_framework.dart';
import '../domain/app_settings.dart';
import '../infrastructure/repos/app_settings_repo.dart';

part 'app_settings_provider.g.dart';

/// Provides the current app settings.
///
/// This provider fetches settings on first access and caches them.
/// Use [appSettingsStreamProvider] for real-time updates.
@Riverpod(keepAlive: true)
Future<AppSettings> appSettings(Ref ref) async {
  final repo = ref.watch(appSettingsRepoProvider);
  return repo.getSettings();
}

/// Streams app settings changes in real-time.
///
/// Useful for components that need to react to settings changes
/// made from Admin Dashboard.
@Riverpod(keepAlive: true)
Stream<AppSettings> appSettingsStream(Ref ref) {
  final repo = ref.watch(appSettingsRepoProvider);
  return repo.watchSettings();
}

/// Provides delivery settings directly for convenience.
@riverpod
Future<DeliverySettings> deliverySettings(Ref ref) async {
  final settings = await ref.watch(appSettingsProvider.future);
  return settings.delivery;
}

/// Provides general settings directly for convenience.
@riverpod
Future<GeneralSettings> generalSettings(Ref ref) async {
  final settings = await ref.watch(appSettingsProvider.future);
  return settings.general;
}

/// Provides the currency symbol for formatting.
@riverpod
Future<String> currencySymbol(Ref ref) async {
  final settings = await ref.watch(generalSettingsProvider.future);
  return settings.currencySymbol;
}

/// Provides the base delivery fee.
@riverpod
Future<double> baseDeliveryFee(Ref ref) async {
  final settings = await ref.watch(deliverySettingsProvider.future);
  return settings.baseDeliveryFee;
}

/// Provides the fee per kilometer.
@riverpod
Future<double> feePerKilometer(Ref ref) async {
  final settings = await ref.watch(deliverySettingsProvider.future);
  return settings.feePerKilometer;
}

/// Provides the estimated delivery time.
@riverpod
Future<int> estimatedDeliveryTime(Ref ref) async {
  final settings = await ref.watch(deliverySettingsProvider.future);
  return settings.estimatedDeliveryTime;
}

/// Checks if app is in maintenance mode.
@riverpod
Future<bool> isMaintenanceMode(Ref ref) async {
  final settings = await ref.watch(generalSettingsProvider.future);
  return settings.maintenanceMode;
}

/// Calculates delivery fee for a given distance.
@riverpod
Future<double> calculateDeliveryFee(
  Ref ref, {
  required double distanceKm,
}) async {
  final settings = await ref.watch(deliverySettingsProvider.future);
  return settings.calculateDeliveryFee(distanceKm);
}

/// Checks if distance is within delivery radius.
@riverpod
Future<bool> isWithinDeliveryRadius(
  Ref ref, {
  required double distanceKm,
}) async {
  final settings = await ref.watch(deliverySettingsProvider.future);
  return settings.isWithinDeliveryRadius(distanceKm);
}

/// Provider for refreshing settings manually.
@riverpod
Future<AppSettings> refreshAppSettings(Ref ref) async {
  final repo = ref.read(appSettingsRepoProvider);
  final settings = await repo.refreshSettings();

  // Invalidate cached providers to trigger rebuild
  ref.invalidate(appSettingsProvider);

  return settings;
}
