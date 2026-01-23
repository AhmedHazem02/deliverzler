/// DTOs for App Settings - handles Firebase serialization.
///
/// These DTOs convert between Firebase JSON format and domain entities,
/// matching the structure used by Admin Dashboard.
library;

import '../../domain/app_settings.dart';

/// DTO for [AppSettings] Firebase serialization.
class AppSettingsDto {
  const AppSettingsDto({
    required this.general,
    required this.delivery,
    this.updatedAt,
  });

  final GeneralSettingsDto general;
  final DeliverySettingsDto delivery;
  final DateTime? updatedAt;

  /// Creates DTO from Firebase JSON.
  factory AppSettingsDto.fromJson(Map<String, dynamic> json) {
    return AppSettingsDto(
      general: GeneralSettingsDto.fromJson(
        json['general'] as Map<String, dynamic>? ?? {},
      ),
      delivery: DeliverySettingsDto.fromJson(
        json['delivery'] as Map<String, dynamic>? ?? {},
      ),
      updatedAt: _parseTimestamp(json['updatedAt']),
    );
  }

  /// Converts to domain entity.
  AppSettings toDomain() => AppSettings(
        general: general.toDomain(),
        delivery: delivery.toDomain(),
        updatedAt: updatedAt,
      );

  /// Parses Firebase timestamp or ISO string.
  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    // Handle Firebase Timestamp
    if (value is Map && value['_seconds'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(
        (value['_seconds'] as int) * 1000,
      );
    }
    return null;
  }
}

/// DTO for [GeneralSettings] Firebase serialization.
class GeneralSettingsDto {
  const GeneralSettingsDto({
    required this.appName,
    required this.appNameAr,
    required this.currency,
    required this.currencySymbol,
    required this.timezone,
    this.supportEmail,
    this.supportPhone,
    this.maintenanceMode = false,
  });

  final String appName;
  final String appNameAr;
  final String currency;
  final String currencySymbol;
  final String timezone;
  final String? supportEmail;
  final String? supportPhone;
  final bool maintenanceMode;

  /// Creates DTO from Firebase JSON with defaults.
  factory GeneralSettingsDto.fromJson(Map<String, dynamic> json) {
    return GeneralSettingsDto(
      appName: json['appName'] as String? ?? 'Deliverzler',
      appNameAr: json['appNameAr'] as String? ?? 'ديليفرزلر',
      currency: json['currency'] as String? ?? 'EGP',
      currencySymbol: json['currencySymbol'] as String? ?? 'ج.م',
      timezone: json['timezone'] as String? ?? 'Africa/Cairo',
      supportEmail: json['supportEmail'] as String?,
      supportPhone: json['supportPhone'] as String?,
      maintenanceMode: json['maintenanceMode'] as bool? ?? false,
    );
  }

  /// Converts to domain entity.
  GeneralSettings toDomain() => GeneralSettings(
        appName: appName,
        appNameAr: appNameAr,
        currency: currency,
        currencySymbol: currencySymbol,
        timezone: timezone,
        supportEmail: supportEmail,
        supportPhone: supportPhone,
        maintenanceMode: maintenanceMode,
      );
}

/// DTO for [DeliverySettings] Firebase serialization.
class DeliverySettingsDto {
  const DeliverySettingsDto({
    required this.baseDeliveryFee,
    required this.feePerKilometer,
    required this.minimumOrderAmount,
    this.freeDeliveryThreshold,
    required this.maxDeliveryRadius,
    required this.estimatedDeliveryTime,
    this.zones = const [],
  });

  final double baseDeliveryFee;
  final double feePerKilometer;
  final double minimumOrderAmount;
  final double? freeDeliveryThreshold;
  final int maxDeliveryRadius;
  final int estimatedDeliveryTime;
  final List<DeliveryZoneDto> zones;

  /// Creates DTO from Firebase JSON with defaults.
  factory DeliverySettingsDto.fromJson(Map<String, dynamic> json) {
    return DeliverySettingsDto(
      baseDeliveryFee: (json['baseDeliveryFee'] as num?)?.toDouble() ?? 15.0,
      feePerKilometer: (json['feePerKilometer'] as num?)?.toDouble() ?? 3.0,
      minimumOrderAmount:
          (json['minimumOrderAmount'] as num?)?.toDouble() ?? 30.0,
      freeDeliveryThreshold:
          (json['freeDeliveryThreshold'] as num?)?.toDouble(),
      maxDeliveryRadius: json['maxDeliveryRadius'] as int? ?? 25,
      estimatedDeliveryTime: json['estimatedDeliveryTime'] as int? ?? 45,
      zones: (json['zones'] as List<dynamic>?)
              ?.map((z) => DeliveryZoneDto.fromJson(z as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Converts to domain entity.
  DeliverySettings toDomain() => DeliverySettings(
        baseDeliveryFee: baseDeliveryFee,
        feePerKilometer: feePerKilometer,
        minimumOrderAmount: minimumOrderAmount,
        freeDeliveryThreshold: freeDeliveryThreshold,
        maxDeliveryRadius: maxDeliveryRadius,
        estimatedDeliveryTime: estimatedDeliveryTime,
        zones: zones.map((z) => z.toDomain()).toList(),
      );
}

/// DTO for [DeliveryZone] Firebase serialization.
class DeliveryZoneDto {
  const DeliveryZoneDto({
    required this.id,
    required this.name,
    this.nameAr,
    required this.fee,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String? nameAr;
  final double fee;
  final bool isActive;

  /// Creates DTO from Firebase JSON.
  factory DeliveryZoneDto.fromJson(Map<String, dynamic> json) {
    return DeliveryZoneDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameAr: json['nameAr'] as String?,
      fee: (json['fee'] as num?)?.toDouble() ?? 0.0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Converts to domain entity.
  DeliveryZone toDomain() => DeliveryZone(
        id: id,
        name: name,
        nameAr: nameAr,
        fee: fee,
        isActive: isActive,
      );
}
