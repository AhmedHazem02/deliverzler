import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/order.dart';
import '../../domain/pickup_stop.dart';
import '../../domain/store.dart';
import '../providers/store_provider.dart';
import 'location_stream_provider.dart';
import 'selected_order_provider.dart';

/// Provides the sorted pickup stops for the selected multi-store order.
///
/// Sorts active (non-picked-up, non-rejected) stops by distance from
/// the driver's current location (nearest first). Already picked-up stops
/// are placed at the beginning, rejected at the end.
final sortedPickupStopsProvider =
    FutureProvider.autoDispose<List<PickupStopWithDistance>>((ref) async {
  final order = ref.watch(selectedOrderProvider).toNullable();
  if (order == null || !order.isMultiStore || order.pickupStops.isEmpty) {
    return [];
  }

  final position = ref.watch(locationStreamProvider).valueOrNull;
  final driverLat = position?.latitude;
  final driverLng = position?.longitude;

  // Fetch store locations for all pickup stops
  final storeIds = order.pickupStops.map((s) => s.storeId).toList();
  final stores = await ref.watch(pickupStopsStoresProvider(storeIds).future);

  final result = <PickupStopWithDistance>[];

  for (int i = 0; i < order.pickupStops.length; i++) {
    final stop = order.pickupStops[i];
    final store = stores[stop.storeId];
    double? distance;

    if (driverLat != null && driverLng != null && store?.hasLocation == true) {
      distance = _haversineDistance(
        driverLat,
        driverLng,
        store!.latitude!,
        store.longitude!,
      );
    }

    result.add(PickupStopWithDistance(
      stop: stop,
      originalIndex: i,
      store: store,
      distanceKm: distance,
    ));
  }

  // Sort: picked_up first (completed), then active sorted by distance (nearest first),
  // then rejected last
  result.sort((a, b) {
    if (a.stop.isPickedUp && !b.stop.isPickedUp) return -1;
    if (!a.stop.isPickedUp && b.stop.isPickedUp) return 1;
    if (a.stop.isRejected && !b.stop.isRejected) return 1;
    if (!a.stop.isRejected && b.stop.isRejected) return -1;

    // Both active — sort by distance
    if (a.distanceKm != null && b.distanceKm != null) {
      return a.distanceKm!.compareTo(b.distanceKm!);
    }
    return 0;
  });

  return result;
});

/// The current pickup stop the driver should navigate to (nearest active stop).
final currentPickupStopProvider =
    Provider.autoDispose<PickupStopWithDistance?>((ref) {
  final sorted = ref.watch(sortedPickupStopsProvider).valueOrNull;
  if (sorted == null || sorted.isEmpty) return null;

  try {
    return sorted.firstWhere((s) => s.stop.isActive);
  } catch (_) {
    return null;
  }
});

/// Data class pairing a [PickupStop] with its store data and distance from driver.
class PickupStopWithDistance {
  final PickupStop stop;
  final int originalIndex;
  final AppStore? store;
  final double? distanceKm;

  const PickupStopWithDistance({
    required this.stop,
    required this.originalIndex,
    this.store,
    this.distanceKm,
  });

  /// The GeoPoint for this stop's store location.
  GeoPoint? get storeGeoPoint {
    if (store?.hasLocation == true) {
      return GeoPoint(store!.latitude!, store!.longitude!);
    }
    return null;
  }

  /// Formatted distance string (e.g., "2.3 كم").
  String get formattedDistance {
    if (distanceKm == null) return '';
    if (distanceKm! < 1) return '${(distanceKm! * 1000).round()} م';
    return '${distanceKm!.toStringAsFixed(1)} كم';
  }
}

/// Haversine formula to calculate distance between two lat/lng points in km.
double _haversineDistance(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  const earthRadius = 6371.0; // km
  final dLat = _degToRad(lat2 - lat1);
  final dLon = _degToRad(lon2 - lon1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_degToRad(lat1)) *
          cos(_degToRad(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadius * c;
}

double _degToRad(double deg) => deg * (pi / 180);
