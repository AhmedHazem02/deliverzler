/// App Settings Feature.
///
/// Provides centralized app configuration that syncs with Admin Dashboard.
/// Settings are stored in Firebase `settings/app_config` and cached locally.
///
/// ## Usage
///
/// ```dart
/// // Get settings (cached)
/// final settings = await ref.read(appSettingsProvider.future);
///
/// // Watch real-time changes
/// final stream = ref.watch(appSettingsStreamProvider);
///
/// // Get specific settings
/// final deliveryFee = await ref.read(baseDeliveryFeeProvider.future);
/// final currency = await ref.read(currencySymbolProvider.future);
///
/// // Calculate delivery fee
/// final fee = await ref.read(
///   calculateDeliveryFeeProvider(distanceKm: 5.0).future,
/// );
/// ```
///
/// ## Using Widgets
///
/// ```dart
/// // Display delivery fee
/// DeliveryFeeDisplay(distanceKm: 5.0)
///
/// // Show delivery availability badge
/// DeliveryAvailabilityBadge(distanceKm: 10.0)
///
/// // Complete delivery fee card with breakdown
/// DeliveryFeeCard(distanceKm: 7.5)
/// ```
///
/// ## Maintenance Mode
///
/// Wrap your app with MaintenanceModeWrapper to automatically show
/// maintenance screen when enabled in Admin Dashboard:
///
/// ```dart
/// MaintenanceModeWrapper(
///   child: MyApp(),
/// )
/// ```
library;

// Domain
export 'domain/app_settings.dart';

// Infrastructure
export 'infrastructure/data_sources/app_settings_remote_data_source.dart';
export 'infrastructure/dtos/app_settings_dto.dart';
export 'infrastructure/repos/app_settings_repo.dart';
export 'infrastructure/services/app_settings_initializer.dart';

// Presentation - Providers
export 'presentation/app_settings_provider.dart';

// Presentation - Screens
export 'presentation/screens/maintenance_mode_screen.dart';

// Presentation - Widgets
export 'presentation/widgets/delivery_fee_widgets.dart';
