/// App Settings Repository.
///
/// Provides access to app settings with caching support for offline access
/// and performance optimization.
library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../presentation/utils/riverpod_framework.dart';
import '../../domain/app_settings.dart';
import '../data_sources/app_settings_remote_data_source.dart';
import '../dtos/app_settings_dto.dart';

part 'app_settings_repo.g.dart';

/// Cache key for storing settings locally.
const String _settingsCacheKey = 'cached_app_settings';

/// Cache duration - settings are refreshed after this period.
const Duration _cacheDuration = Duration(hours: 1);

@Riverpod(keepAlive: true)
AppSettingsRepo appSettingsRepo(Ref ref) {
  return AppSettingsRepo(ref);
}

/// Repository for managing app settings with caching.
class AppSettingsRepo {
  AppSettingsRepo(this._ref);

  final Ref _ref;

  AppSettingsRemoteDataSource get _remoteDataSource =>
      _ref.read(appSettingsRemoteDataSourceProvider);

  SharedPreferences? _prefs;

  /// Timestamp of last cache update.
  DateTime? _lastCacheUpdate;

  /// In-memory cache for fast access.
  AppSettings? _memoryCache;

  /// Gets app settings with caching strategy:
  /// 1. Return memory cache if valid
  /// 2. Return disk cache if valid and fetch remote in background
  /// 3. Fetch from remote and cache
  /// 4. Return defaults if all fails
  Future<AppSettings> getSettings() async {
    // Check memory cache
    if (_isMemoryCacheValid()) {
      return _memoryCache!;
    }

    // Check disk cache
    final cachedSettings = await _getCachedSettings();
    if (cachedSettings != null) {
      _memoryCache = cachedSettings;

      // Refresh from remote in background (fire and forget)
      _refreshFromRemote();

      return cachedSettings;
    }

    // Fetch from remote
    return _fetchAndCacheSettings();
  }

  /// Streams app settings changes in real-time.
  Stream<AppSettings> watchSettings() {
    return _remoteDataSource.watchSettings().map((dto) {
      if (dto == null) {
        return AppSettings.defaults();
      }
      final settings = dto.toDomain();
      _updateCache(settings);
      return settings;
    });
  }

  /// Forces a refresh of settings from remote.
  Future<AppSettings> refreshSettings() async {
    return _fetchAndCacheSettings();
  }

  /// Clears all cached settings.
  Future<void> clearCache() async {
    _memoryCache = null;
    _lastCacheUpdate = null;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.remove(_settingsCacheKey);
    await _prefs!.remove('${_settingsCacheKey}_timestamp');
  }

  // ============================================
  // Private Helper Methods
  // ============================================

  bool _isMemoryCacheValid() {
    if (_memoryCache == null || _lastCacheUpdate == null) {
      return false;
    }
    return DateTime.now().difference(_lastCacheUpdate!) < _cacheDuration;
  }

  Future<AppSettings?> _getCachedSettings() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();

      // Check cache timestamp
      final timestampStr = _prefs!.getString('${_settingsCacheKey}_timestamp');
      if (timestampStr != null) {
        final timestamp = DateTime.tryParse(timestampStr);
        if (timestamp != null &&
            DateTime.now().difference(timestamp) > _cacheDuration) {
          // Cache expired
          return null;
        }
      }

      final jsonStr = _prefs!.getString(_settingsCacheKey);
      if (jsonStr == null) return null;

      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return AppSettingsDto.fromJson(json).toDomain();
    } catch (_) {
      return null;
    }
  }

  Future<void> _cacheSettings(AppSettingsDto dto) async {
    try {
      _prefs ??= await SharedPreferences.getInstance();

      // Store settings
      final jsonMap = _dtoToJson(dto);
      await _prefs!.setString(_settingsCacheKey, jsonEncode(jsonMap));

      // Store timestamp
      await _prefs!.setString(
        '${_settingsCacheKey}_timestamp',
        DateTime.now().toIso8601String(),
      );
    } catch (_) {
      // Silent fail - caching is not critical
    }
  }

  void _updateCache(AppSettings settings) {
    _memoryCache = settings;
    _lastCacheUpdate = DateTime.now();
  }

  Future<AppSettings> _fetchAndCacheSettings() async {
    try {
      final dto = await _remoteDataSource.getSettings();

      if (dto == null) {
        return AppSettings.defaults();
      }

      final settings = dto.toDomain();
      _updateCache(settings);
      await _cacheSettings(dto);

      return settings;
    } catch (_) {
      // Return cached settings or defaults on error
      return _memoryCache ?? AppSettings.defaults();
    }
  }

  Future<void> _refreshFromRemote() async {
    try {
      final dto = await _remoteDataSource.getSettings();
      if (dto != null) {
        _updateCache(dto.toDomain());
        await _cacheSettings(dto);
      }
    } catch (_) {
      // Silent fail - background refresh
    }
  }

  /// Converts DTO to JSON for caching.
  Map<String, dynamic> _dtoToJson(AppSettingsDto dto) {
    return {
      'general': {
        'appName': dto.general.appName,
        'appNameAr': dto.general.appNameAr,
        'currency': dto.general.currency,
        'currencySymbol': dto.general.currencySymbol,
        'timezone': dto.general.timezone,
        'supportEmail': dto.general.supportEmail,
        'supportPhone': dto.general.supportPhone,
        'maintenanceMode': dto.general.maintenanceMode,
      },
      'delivery': {
        'baseDeliveryFee': dto.delivery.baseDeliveryFee,
        'feePerKilometer': dto.delivery.feePerKilometer,
        'minimumOrderAmount': dto.delivery.minimumOrderAmount,
        'freeDeliveryThreshold': dto.delivery.freeDeliveryThreshold,
        'maxDeliveryRadius': dto.delivery.maxDeliveryRadius,
        'estimatedDeliveryTime': dto.delivery.estimatedDeliveryTime,
        'zones': dto.delivery.zones
            .map((z) => {
                  'id': z.id,
                  'name': z.name,
                  'nameAr': z.nameAr,
                  'fee': z.fee,
                  'isActive': z.isActive,
                })
            .toList(),
      },
      'updatedAt': dto.updatedAt?.toIso8601String(),
    };
  }
}
