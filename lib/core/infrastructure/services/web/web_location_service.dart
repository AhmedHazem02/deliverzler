import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// Web-specific location service with background tracking support
/// Implements clean architecture and high-performance patterns
class WebLocationService {
  WebLocationService();

  StreamController<Position>? _locationStreamController;
  Timer? _backgroundLocationTimer;
  StreamSubscription<html.Geoposition>? _positionSubscription;

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
  Future<Position?> getCurrentPosition() async {
    return _getCurrentPosition();
  }

  Future<Position?> _getCurrentPosition() async {
    if (!isSupported) return null;

    try {
      final completer = Completer<Position?>();
      var completed = false;

      // Set timeout
      Timer(_locationTimeout.seconds, () {
        if (!completed) {
          completed = true;
          completer.complete(null);
        }
      });

      html.window.navigator.geolocation
          .getCurrentPosition()
          .then((html.Geoposition position) {
        if (!completed) {
          completed = true;
          completer.complete(_convertToPosition(position));
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
  Stream<Position> getPositionStream({
    int? intervalSeconds,
    double? distanceFilter,
  }) {
    if (_locationStreamController != null) {
      return _locationStreamController!.stream;
    }

    _locationStreamController = StreamController<Position>.broadcast(
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
        (html.Geoposition position) {
          final pos = _convertToPosition(position);
          if (pos != null && !(_locationStreamController?.isClosed ?? true)) {
            _locationStreamController?.add(pos);
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
    required void Function(Position) onLocationUpdate,
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
  Position? _convertToPosition(html.Geoposition htmlPosition) {
    try {
      final coords = htmlPosition.coords;
      if (coords == null) return null;
      return Position(
        latitude: (coords.latitude ?? 0.0).toDouble(),
        longitude: (coords.longitude ?? 0.0).toDouble(),
        timestamp: DateTime.now(),
        accuracy: (coords.accuracy ?? 0.0).toDouble(),
        altitude: (coords.altitude ?? 0.0).toDouble(),
        heading: (coords.heading ?? 0.0).toDouble(),
        speed: (coords.speed ?? 0.0).toDouble(),
        speedAccuracy: 0,
        // 🔥 ضف هذين السطرين لإسكات الخطأ
        altitudeAccuracy: 0.0, 
        headingAccuracy: 0.0,
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
    return Geolocator.distanceBetween(
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

extension on int {
  Duration get seconds => Duration(seconds: this);
}
