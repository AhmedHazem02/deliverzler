import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/infrastructure/services/location_service.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../utils/location_error.dart';
import 'heartbeat_provider.dart';

part 'location_stream_provider.g.dart';

@riverpod
Stream<Position> locationStream(Ref ref) async* {
  final locationService = ref.watch(locationServiceProvider);

  // 1. Setup Permissions (Fail-fast strategy)
  try {
    await Future.wait([
      ref
          .watch(enableLocationProvider(locationService).future)
          .timeout(const Duration(seconds: 5)),
      ref
          .watch(requestLocationPermissionProvider(locationService).future)
          .timeout(const Duration(seconds: 5)),
    ]);
  } catch (e) {
    debugPrint('⚠️ Location permission/service warning: $e');
    // CRITICAL FIX: Stop execution if permissions fail
    if (e is TimeoutException) {
      yield* Stream.error(LocationError.getLocationTimeout);
    } else {
      yield* Stream.error(e);
    }
    return;
  }

  // 2. Define the source stream with Outlier Filter
  Stream<Position> validatedSource() async* {
    final rawStream = locationService
        .getLocationStream(
          intervalSeconds: 1, // Keep it snappy (1s)
          distanceFilter: 5, // Catch small movements (5m)
        )
        // Throttle slightly less than interval to ensure we don't drop valid packets
        // or keep 800ms if you want to enforce UI update cap.
        .throttleTime(const Duration(milliseconds: 800));

    Position? lastValidPosition;

    await for (var currentPosition in rawStream) {
      if (lastValidPosition != null) {
        final distance = Geolocator.distanceBetween(
          lastValidPosition.latitude,
          lastValidPosition.longitude,
          currentPosition.latitude,
          currentPosition.longitude,
        );

        // Outlier Check: > 100m jump in < 1 second is impossible for a car
        if (distance > 100) {
          debugPrint(
              '⚠️ Ignored Outlier Jump: ${distance.toStringAsFixed(1)}m');
          continue;
        }

        // Fix Rotation: Calculate heading if missing (0.0) and moved significantly
        // IMPROVED: Increased threshold from 1m to 3m to prevent jitter from micro-movements
        // (3m is approximately the length of a motorcycle, movements below this are likely GPS noise)
        if (currentPosition.heading == 0.0 && distance > 3.0) {
          final bearing = Geolocator.bearingBetween(
            lastValidPosition.latitude,
            lastValidPosition.longitude,
            currentPosition.latitude,
            currentPosition.longitude,
          );
        
          // Create new Position with calculated heading
          currentPosition = Position(
            latitude: currentPosition.latitude,
            longitude: currentPosition.longitude,
            timestamp: currentPosition.timestamp,
            accuracy: currentPosition.accuracy,
            altitude: currentPosition.altitude,
            altitudeAccuracy: currentPosition.altitudeAccuracy,
            heading: (bearing + 360) % 360, // Normalize to 0-360
            headingAccuracy: currentPosition.headingAccuracy,
            speed: currentPosition.speed,
            speedAccuracy: currentPosition.speedAccuracy,
            floor: currentPosition.floor,
            isMocked: currentPosition.isMocked,
          );
        }
      }
      lastValidPosition = currentPosition;
      yield currentPosition;
    }
  }

  // 3. Apply Dead Reckoning & Smoothing using switchMap
  // switchMap is perfect here: when a new real point comes, it CANCELS the ghost loop.
  Position? currentUiPosition;

  yield* validatedSource().switchMap((realPos) async* {
    // A. Smooth Reconnection (The "Slide" Effect)
    // If we have a previous position, and the new one is a bit far, slide to it.
    if (currentUiPosition != null) {
      final dist = Geolocator.distanceBetween(
        currentUiPosition!.latitude,
        currentUiPosition!.longitude,
        realPos.latitude,
        realPos.longitude,
      );

      // Slide if distance is noticeable (> 5m) but valid (< 100m)
      if (dist > 5) {
        // OPTIMIZATION: Dynamic steps based on distance
        // 5m -> 1 step, 20m -> 3 steps. max 5 steps.
        final int steps = (dist / 5).ceil().clamp(1, 5);

        for (int i = 1; i <= steps; i++) {
          final t = i / steps;

          if (t >= 1.0) break;

          final lerpPos = _lerpPosition(currentUiPosition!, realPos, t);
          yield lerpPos;

          // Wait for the animation frame (300ms / steps)
          await Future.delayed(Duration(milliseconds: (300 / steps).round()));
        }
      }
    }

    // B. Emit the Real Position (The Truth)
    yield realPos;
    currentUiPosition = realPos;

    // Send heartbeat on location update (updates lastActiveAt)
    try {
      ref.read(heartbeatProvider.notifier).sendHeartbeat();
    } catch (e) {
      // Silently fail - don't disrupt location stream
      debugPrint('⚠️ Heartbeat failed: $e');
    }

    // C. Dead Reckoning Trigger (Tunnel Mode)
    // Only project if moving significantly (> 1.5 m/s to avoid drift when stopped)
    if (realPos.speed < 1.5) return;

    // Wait 2 seconds before assuming signal loss
    await Future.delayed(const Duration(seconds: 2));

    var executedPos = realPos;
    var currentSpeed = realPos.speed;
    int ghostCount = 0;

    // Start generating Ghost Points (Max 10 seconds)
    // CRITICAL: Reduced from 30s to 10s - in 30 seconds, motorcycle can travel 300m,
    // turn, and stop. 10s is safer limit to avoid wildly inaccurate projections.
    const maxDeadReckoningSeconds = 10;
    while (ghostCount < maxDeadReckoningSeconds) {
      ghostCount++;
      // CRITICAL FIX: Apply Friction (Deceleration)
      // Reduce speed by 5% every second to prevent infinite drifting
      currentSpeed *= 0.95;

      // If speed drops below ~1.8 km/h, stop projecting (assume stopped)
      if (currentSpeed < 0.5) break;

      // Update the speed in the executed position object for accurate calculation
      executedPos = Position(
        latitude: executedPos.latitude,
        longitude: executedPos.longitude,
        timestamp: DateTime.now(),
        // Decay accuracy to indicate uncertainty (increase by 10m each step)
        accuracy: executedPos.accuracy + (ghostCount * 10),
        altitude: executedPos.altitude,
        altitudeAccuracy: executedPos.altitudeAccuracy,
        heading: executedPos.heading,
        headingAccuracy: executedPos.headingAccuracy,
        speed: currentSpeed, // USE DECAYED SPEED
        speedAccuracy: executedPos.speedAccuracy,
        floor: executedPos.floor,
        isMocked: true,
      );

      // Calculate next point assuming constant heading but DECAYING speed
      executedPos =
          _calculateProjectedPosition(executedPos, 1.0); // 1 second projection

    
      yield executedPos;
      currentUiPosition =
          executedPos; // Update UI pos so we can slide FROM this ghost later

      await Future.delayed(const Duration(seconds: 1));
    }
  });
}

/// Helper: Linear Interpolation with Spherical Heading
Position _lerpPosition(Position start, Position end, double t) {
  final lat = start.latitude + (end.latitude - start.latitude) * t;
  final lng = start.longitude + (end.longitude - start.longitude) * t;

  // Smart Rotation: Shortest Path
  final delta = (end.heading - start.heading + 540) % 360 - 180;
  // Normalize result to 0-360 range
  final heading = (start.heading + delta * t) % 360;

  return Position(
    latitude: lat,
    longitude: lng,
    timestamp: DateTime.now(),
    accuracy: end.accuracy,
    altitude: end.altitude,
    altitudeAccuracy: end.altitudeAccuracy,
    heading: heading < 0 ? heading + 360 : heading, // Handle negative wrap
    headingAccuracy: end.headingAccuracy,
    speed: end.speed,
    speedAccuracy: end.speedAccuracy,
    floor: end.floor,
    isMocked: true, // Mark as interpolated
  );
}

/// Helper: Dead Reckoning Math
Position _calculateProjectedPosition(Position start, double timeSeconds) {
  final distMeters = start.speed * timeSeconds;
  const R = 6371000.0;

  final lat1 = start.latitude * math.pi / 180;
  final lon1 = start.longitude * math.pi / 180;
  final brng = start.heading * math.pi / 180;

  final lat2 = math.asin(math.sin(lat1) * math.cos(distMeters / R) +
      math.cos(lat1) * math.sin(distMeters / R) * math.cos(brng));

  final lon2 = lon1 +
      math.atan2(math.sin(brng) * math.sin(distMeters / R) * math.cos(lat1),
          math.cos(distMeters / R) - math.sin(lat1) * math.sin(lat2));

  return Position(
    latitude: lat2 * 180 / math.pi,
    longitude: lon2 * 180 / math.pi,
    timestamp: DateTime.now(),
    accuracy: start.accuracy,
    altitude: start.altitude,
    altitudeAccuracy: start.altitudeAccuracy,
    heading: start.heading,
    headingAccuracy: start.headingAccuracy,
    speed: start.speed,
    speedAccuracy: start.speedAccuracy,
    floor: start.floor,
    isMocked: true, // Mark as ghost
  );
}

@riverpod
Future<void> enableLocation(
  Ref ref,
  LocationService locationService,
) async {
  final enabled = await locationService.enableLocationService();
  if (!enabled) {
    Error.throwWithStackTrace(
      LocationError.notEnabledLocation,
      StackTrace.current,
    );
  }
}

@riverpod
Future<void> requestLocationPermission(
  Ref ref,
  LocationService locationService,
) async {
  final whileInUseGranted = await locationService.requestWhileInUsePermission();
  if (!whileInUseGranted) {
    Error.throwWithStackTrace(
      LocationError.notGrantedLocationPermission,
      StackTrace.current,
    );
  }

  // Request always permission on mobile (not Web)
  if (!kIsWeb) {
    final alwaysGranted = await locationService.requestAlwaysPermission();
    if (!alwaysGranted) {
      Error.throwWithStackTrace(
        LocationError.notGrantedLocationPermission,
        StackTrace.current,
      );
    }
  }
}
