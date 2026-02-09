/// App Settings entities for Deliverzler.
///
/// These entities match the settings stored in Firebase by Admin Dashboard
/// to ensure both apps share the same configuration.
library;

import 'package:flutter/foundation.dart';

/// Main app settings entity containing all configuration sections.
@immutable
class AppSettings {
  const AppSettings({
    required this.general,
    required this.delivery,
    this.updatedAt,
  });

  /// Creates default settings for offline fallback.
  factory AppSettings.defaults() => AppSettings(
        general: GeneralSettings.defaults(),
        delivery: DeliverySettings.defaults(),
        updatedAt: DateTime.now(),
      );

  /// General app settings.
  final GeneralSettings general;

  /// Delivery-related settings.
  final DeliverySettings delivery;

  /// Last update timestamp.
  final DateTime? updatedAt;

  AppSettings copyWith({
    GeneralSettings? general,
    DeliverySettings? delivery,
    DateTime? updatedAt,
  }) {
    return AppSettings(
      general: general ?? this.general,
      delivery: delivery ?? this.delivery,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          general == other.general &&
          delivery == other.delivery &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(general, delivery, updatedAt);
}

/// General application settings.
@immutable
class GeneralSettings {
  const GeneralSettings({
    required this.appName,
    required this.appNameAr,
    required this.currency,
    required this.currencySymbol,
    required this.timezone,
    this.supportEmail,
    this.supportPhone,
    this.maintenanceMode = false,
  });

  /// Creates default general settings.
  factory GeneralSettings.defaults() => const GeneralSettings(
        appName: 'Deliverzler',
        appNameAr: 'ديليفرزلر',
        currency: 'EGP',
        currencySymbol: 'ج.م',
        timezone: 'Africa/Cairo',
      );

  /// App name in English.
  final String appName;

  /// App name in Arabic.
  final String appNameAr;

  /// Currency code (e.g., 'EGP', 'USD').
  final String currency;

  /// Currency symbol (e.g., 'ج.م', '$').
  final String currencySymbol;

  /// Timezone identifier.
  final String timezone;

  /// Support email address.
  final String? supportEmail;

  /// Support phone number.
  final String? supportPhone;

  /// Whether the app is in maintenance mode.
  final bool maintenanceMode;

  GeneralSettings copyWith({
    String? appName,
    String? appNameAr,
    String? currency,
    String? currencySymbol,
    String? timezone,
    String? supportEmail,
    String? supportPhone,
    bool? maintenanceMode,
  }) {
    return GeneralSettings(
      appName: appName ?? this.appName,
      appNameAr: appNameAr ?? this.appNameAr,
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      timezone: timezone ?? this.timezone,
      supportEmail: supportEmail ?? this.supportEmail,
      supportPhone: supportPhone ?? this.supportPhone,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneralSettings &&
          runtimeType == other.runtimeType &&
          appName == other.appName &&
          appNameAr == other.appNameAr &&
          currency == other.currency &&
          currencySymbol == other.currencySymbol &&
          timezone == other.timezone &&
          supportEmail == other.supportEmail &&
          supportPhone == other.supportPhone &&
          maintenanceMode == other.maintenanceMode;

  @override
  int get hashCode => Object.hash(
        appName,
        appNameAr,
        currency,
        currencySymbol,
        timezone,
        supportEmail,
        supportPhone,
        maintenanceMode,
      );
}

/// Delivery-related settings.
@immutable
class DeliverySettings {
  const DeliverySettings({
    required this.baseDeliveryFee,
    required this.feePerKilometer,
    required this.minimumOrderAmount,
    required this.maxDeliveryRadius,
    required this.estimatedDeliveryTime,
    this.freeDeliveryThreshold,
    this.zones = const [],
  });

  /// Creates default delivery settings.
  factory DeliverySettings.defaults() => const DeliverySettings(
        baseDeliveryFee: 15,
        feePerKilometer: 3,
        minimumOrderAmount: 30,
        freeDeliveryThreshold: 150,
        maxDeliveryRadius: 25,
        estimatedDeliveryTime: 45,
      );

  /// Base delivery fee in currency units.
  final double baseDeliveryFee;

  /// Additional fee per kilometer.
  final double feePerKilometer;

  /// Minimum order amount required.
  final double minimumOrderAmount;

  /// Order amount threshold for free delivery (null = no free delivery).
  final double? freeDeliveryThreshold;

  /// Maximum delivery radius in kilometers.
  final int maxDeliveryRadius;

  /// Estimated delivery time in minutes.
  final int estimatedDeliveryTime;

  /// Delivery zones configuration.
  final List<DeliveryZone> zones;

  /// Calculates delivery fee for a given distance.
  double calculateDeliveryFee(double distanceKm) {
    final fee = baseDeliveryFee + (feePerKilometer * distanceKm);
    return fee;
  }

  /// Checks if a distance is within delivery radius.
  bool isWithinDeliveryRadius(double distanceKm) {
    return distanceKm <= maxDeliveryRadius;
  }

  DeliverySettings copyWith({
    double? baseDeliveryFee,
    double? feePerKilometer,
    double? minimumOrderAmount,
    double? freeDeliveryThreshold,
    int? maxDeliveryRadius,
    int? estimatedDeliveryTime,
    List<DeliveryZone>? zones,
  }) {
    return DeliverySettings(
      baseDeliveryFee: baseDeliveryFee ?? this.baseDeliveryFee,
      feePerKilometer: feePerKilometer ?? this.feePerKilometer,
      minimumOrderAmount: minimumOrderAmount ?? this.minimumOrderAmount,
      freeDeliveryThreshold:
          freeDeliveryThreshold ?? this.freeDeliveryThreshold,
      maxDeliveryRadius: maxDeliveryRadius ?? this.maxDeliveryRadius,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      zones: zones ?? this.zones,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliverySettings &&
          runtimeType == other.runtimeType &&
          baseDeliveryFee == other.baseDeliveryFee &&
          feePerKilometer == other.feePerKilometer &&
          minimumOrderAmount == other.minimumOrderAmount &&
          freeDeliveryThreshold == other.freeDeliveryThreshold &&
          maxDeliveryRadius == other.maxDeliveryRadius &&
          estimatedDeliveryTime == other.estimatedDeliveryTime &&
          listEquals(zones, other.zones);

  @override
  int get hashCode => Object.hash(
        baseDeliveryFee,
        feePerKilometer,
        minimumOrderAmount,
        freeDeliveryThreshold,
        maxDeliveryRadius,
        estimatedDeliveryTime,
        Object.hashAll(zones),
      );
}

/// Delivery zone configuration.
@immutable
class DeliveryZone {
  const DeliveryZone({
    required this.id,
    required this.name,
    required this.fee,
    this.nameAr,
    this.isActive = true,
  });

  /// Unique zone identifier.
  final String id;

  /// Zone name in English.
  final String name;

  /// Zone name in Arabic.
  final String? nameAr;

  /// Delivery fee for this zone.
  final double fee;

  /// Whether this zone is active.
  final bool isActive;

  DeliveryZone copyWith({
    String? id,
    String? name,
    String? nameAr,
    double? fee,
    bool? isActive,
  }) {
    return DeliveryZone(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      fee: fee ?? this.fee,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryZone &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          nameAr == other.nameAr &&
          fee == other.fee &&
          isActive == other.isActive;

  @override
  int get hashCode => Object.hash(id, name, nameAr, fee, isActive);
}
