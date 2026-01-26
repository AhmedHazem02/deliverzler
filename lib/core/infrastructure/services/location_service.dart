// ignore_for_file: depend_on_referenced_packages, implementation_imports, unnecessary_import

import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_android/src/types/foreground_settings.dart';
import 'package:location/location.dart' as loc;
import 'package:logging/logging.dart';

import '../../presentation/utils/riverpod_framework.dart';
import 'web/web_location_service.dart';

part 'location_service.g.dart';

abstract class AppLocationSettings {
  static const int getLocationTimeLimit = 20; //in seconds
  static const int locationChangeInterval = 5; //in seconds
  static const int locationChangeDistance = 50; //in meters
}

@Riverpod(keepAlive: true)
LocationService locationService(Ref ref) {
  return LocationService(
    webLocationService: kIsWeb ? WebLocationService() : null,
  );
}

class LocationService {
  LocationService({this.webLocationService});

  final WebLocationService? webLocationService;
  Future<bool> isLocationServiceEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<bool> isWhileInUsePermissionGranted() async {
    final permission = await Geolocator.checkPermission();
    return [LocationPermission.whileInUse, LocationPermission.always]
        .any((p) => p == permission);
  }

  Future<bool> isAlwaysPermissionGranted() async {
    return await Geolocator.checkPermission() == LocationPermission.always;
  }

  Future<bool> enableLocationService() async {
    final serviceEnabled = await isLocationServiceEnabled();
    if (serviceEnabled) {
      return true;
    } else {
      // Web location is handled through browser permissions
      if (kIsWeb) {
        return webLocationService?.isSupported ?? false;
      }
      return loc.Location().requestService();
    }
  }

  Future<bool> requestWhileInUsePermission() async {
    if (await isWhileInUsePermissionGranted()) {
      return true;
    } else {
      // Web permission is requested automatically when accessing location
      if (kIsWeb) {
        return await webLocationService?.requestPermission() ?? false;
      }
      final permissionGranted = await Geolocator.requestPermission();
      return permissionGranted == LocationPermission.whileInUse;
    }
  }

  Future<bool> requestAlwaysPermission() async {
    if (await isAlwaysPermissionGranted()) {
      return true;
    } else {
      await Geolocator.requestPermission();
      return isAlwaysPermissionGranted();
    }
  }

  LocationSettings getLocationSettings({
    LocationAccuracy? accuracy,
    int? interval,
    int? distanceFilter,
  }) {
    // Web uses default LocationSettings
    if (kIsWeb) {
      return LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter:
            distanceFilter ?? AppLocationSettings.locationChangeDistance,
      );
    }
    
    // Try to detect platform for native apps
    try {
      final platform = defaultTargetPlatform;
      
      if (platform == TargetPlatform.android) {
        return AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter:
              distanceFilter ?? AppLocationSettings.locationChangeDistance,
          intervalDuration: Duration(
            seconds: interval ?? AppLocationSettings.locationChangeInterval,
          ),
          //Set foreground notification config to keep app alive in background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationTitle: 'Deliverzler Delivery Service',
            notificationText:
                'Deliverzler will receive your location in background.',
            notificationIcon: AndroidResource(name: 'notification_icon'),
            enableWakeLock: true,
          ),
        );
      } else if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
        return AppleSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter:
              distanceFilter ?? AppLocationSettings.locationChangeDistance,
          activityType: ActivityType.automotiveNavigation,
          pauseLocationUpdatesAutomatically: true,
          //Set to true to keep app alive in background
          showBackgroundLocationIndicator: true,
        );
      }
    } catch (e) {
      // Platform detection failed, use generic settings
    }
    
    // Fallback for unsupported platforms
    return LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter:
          distanceFilter ?? AppLocationSettings.locationChangeDistance,
    );
  }

  Future<Position?> getLocation() async {
    try {
      // Use web location service for web platform
      if (kIsWeb) {
        return await webLocationService?.getCurrentPosition();
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit:
            const Duration(seconds: AppLocationSettings.getLocationTimeLimit),
      );
    } catch (e) {
      Logger.root.severe(e, StackTrace.current);
      return null;
    }
  }

  /// Get location stream - works on all platforms including web
  Stream<Position> getLocationStream({
    int? intervalSeconds,
    double? distanceFilter,
  }) {
    if (kIsWeb) {
      return webLocationService!.getPositionStream(
        intervalSeconds:
            intervalSeconds ?? AppLocationSettings.locationChangeInterval,
        distanceFilter: distanceFilter,
      );
    }

    return Geolocator.getPositionStream(
      locationSettings: getLocationSettings(
        interval: intervalSeconds,
        distanceFilter: distanceFilter?.toInt(),
      ),
    );
  }

  /// Enable background location tracking (web-specific)
  void enableBackgroundTracking({
    required void Function(Position) onLocationUpdate,
    int intervalSeconds = 5,
  }) {
    if (kIsWeb) {
      webLocationService?.enableBackgroundTracking(
        onLocationUpdate: onLocationUpdate,
        intervalSeconds: intervalSeconds,
      );
    }
  }

  /// Disable background location tracking (web-specific)
  void disableBackgroundTracking() {
    if (kIsWeb) {
      webLocationService?.disableBackgroundTracking();
    }
  }

  /// Dispose resources
  void dispose() {
    if (kIsWeb) {
      webLocationService?.dispose();
    }
  }
}

