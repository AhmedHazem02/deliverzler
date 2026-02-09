// ignore_for_file: unnecessary_cast

import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart' as geo;

/// Web-specific location service with background tracking support
/// Implements clean architecture and high-performance patterns
class WebLocationService {
  WebLocationService();

  StreamController<geo.Position>? _locationStreamController;
  Timer? _backgroundLocationTimer;
  StreamSubscription<dynamic>? _positionSubscription;

  static const int _backgroundUpdateInterval = 5; // seconds
  static const int _locationTimeout = 20; // seconds

  /// Check if geolocation is supported
  bool get isSupported => true;

  /// Request location permission
  Future<bool> requestPermission() async {
    if (!isSupported) {
      if (kDebugMode) debugPrint('Geolocation not supported on this browser');
      return false;
    }

    try {
      // Web browsers handle permissions automatically when requesting location
      final position = await _getCurrentPosition();
      return position != null;
    } catch (e) {
      if (kDebugMode) debugPrint('Location permission denied: $e');
      return false;
    }
  }

  /// Get current position
  Future<geo.Position?> getCurrentPosition() async {
    return _getCurrentPosition();
  }

  Future<geo.Position?> _getCurrentPosition() async {
    if (!isSupported) return null;

    try {
      final completer = Completer<geo.Position?>();
      var completed = false;

      // Set timeout
      Timer(const Duration(seconds: _locationTimeout), () {
        if (!completed) {
          completed = true;
          completer.complete(null);
        }
      });

      html.window.navigator.geolocation
          .getCurrentPosition()
          .then((dynamic position) {
        if (!completed) {
          completed = true;
          // Handle LegacyJavaScriptObject by casting to html.Geoposition
          final geoPosition = position as html.Geoposition?;
          if (geoPosition != null) {
            completer.complete(_convertToPosition(geoPosition));
          } else {
            completer.complete(null);
          }
        }
      }).catchError((Object error) {
        if (!completed) {
          completed = true;
          if (kDebugMode) debugPrint('Error getting position: $error');
          completer.complete(null);
        }
        return null; // Return value for catchError
      });

      return await completer.future;
    } catch (e) {
      if (kDebugMode) debugPrint('Error in getCurrentPosition: $e');
      return null;
    }
  }

  /// Start location stream with high accuracy
  Stream<geo.Position> getPositionStream({
    int? intervalSeconds,
    double? distanceFilter,
  }) {
    if (_locationStreamController != null) {
      return _locationStreamController!.stream;
    }

    _locationStreamController = StreamController<geo.Position>.broadcast(
      onListen: () =>
          _startWatchingPosition(intervalSeconds ?? _backgroundUpdateInterval),
      onCancel: _stopWatchingPosition,
    );

    return _locationStreamController!.stream;
  }

  /// Start watching position with Web Geolocation API
  void _startWatchingPosition(int intervalSeconds) {
    if (!isSupported || _positionSubscription != null) return;

    try {
      // Use watchPosition with stream
      _positionSubscription =
          html.window.navigator.geolocation.watchPosition().listen(
        (dynamic position) {
          try {
            // Handle LegacyJavaScriptObject by casting to html.Geoposition
            final geoPosition = position as html.Geoposition?;

            if (geoPosition != null) {
              // Convert the position to Dart Position object
              final pos = _convertToPosition(geoPosition);

              // Only add if conversion was successful and stream is open
              if (pos != null &&
                  !(_locationStreamController?.isClosed ?? true)) {
                _locationStreamController?.add(pos);
              }
            }
          } catch (e) {
            if (kDebugMode) {
              debugPrint(
                '[WebLocationService] Error processing position update: $e',
              );
            }
          }
        },
        onError: (Object error) {
          if (kDebugMode) debugPrint('Watch position error: $error');
        },
      );

      if (kDebugMode) debugPrint('Started watching position');
    } catch (e) {
      if (kDebugMode) debugPrint('Error starting position watch: $e');
    }
  }

  /// Stop watching position
  void _stopWatchingPosition() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    if (kDebugMode) debugPrint('Stopped watching position');
  }

  /// Enable background location tracking using periodic updates
  /// Note: True background tracking requires service workers
  void enableBackgroundTracking({
    required void Function(geo.Position) onLocationUpdate,
    int intervalSeconds = 5,
  }) {
    _backgroundLocationTimer?.cancel();

    _backgroundLocationTimer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (timer) async {
        final position = await getCurrentPosition();
        if (position != null) {
          onLocationUpdate(position);
        }
      },
    );

    if (kDebugMode) {
      debugPrint(
        'Background location tracking enabled (interval: ${intervalSeconds}s)',
      );
    }
  }

  /// Disable background location tracking
  void disableBackgroundTracking() {
    _backgroundLocationTimer?.cancel();
    _backgroundLocationTimer = null;
    if (kDebugMode) debugPrint('Background location tracking disabled');
  }

  /// Convert HTML Geoposition to Flutter Position
  geo.Position? _convertToPosition(html.Geoposition htmlPosition) {
    try {
      final coords = htmlPosition.coords;
      if (coords == null) return null;

      // Explicitly create the Dart object from the geolocator package
      return geo.Position(
        latitude: (coords.latitude as num?)?.toDouble() ?? 0.0,
        longitude: (coords.longitude as num?)?.toDouble() ?? 0.0,
        timestamp: DateTime.now(),
        accuracy: (coords.accuracy as num?)?.toDouble() ?? 0.0,
        altitude: (coords.altitude as num?)?.toDouble() ?? 0.0,
        heading: (coords.heading as num?)?.toDouble() ?? 0.0,
        speed: (coords.speed as num?)?.toDouble() ?? 0.0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('Error converting position: $e');
      return null;
    }
  }

  /// Calculate distance between two positions (in meters)
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return geo.Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Dispose resources
  void dispose() {
    _stopWatchingPosition();
    _backgroundLocationTimer?.cancel();
    _locationStreamController?.close();
    _locationStreamController = null;
  }
}
