import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/presentation/utils/fp_framework.dart';
import '../../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../home/domain/order.dart';
import '../../../../home/presentation/providers/multi_stop_navigation_provider.dart';
import '../../../../home/presentation/providers/selected_order_provider.dart';
import '../place_details_provider.dart';

part 'target_location_geo_point_provider.g.dart';

@riverpod
class TargetLocationGeoPoint extends _$TargetLocationGeoPoint {
  @override
  Option<GeoPoint> build() {
    final currentPlaceDetails = ref.watch(currentPlaceDetailsProvider);

    return currentPlaceDetails.match(
      () {
        // Watch the full order once to determine type
        final order = ref.watch(selectedOrderProvider).toNullable();
        if (order == null) return const None();

        // For multi-store orders: target is current pickup stop's store location,
        // or customer address if all stores are picked up.
        if (order.isMultiStore) {
          return _getMultiStoreTarget(order);
        }

        // Single-store: use customer delivery address
        return Option<GeoPoint>.fromNullable(order.address?.geoPoint);
      },
      (placeDetails) => Some(placeDetails.geoPoint),
    );
  }

  /// For multi-store orders: navigate to the nearest active store,
  /// or customer address if all stores are picked up.
  ///
  /// Returns [None] while store data is still loading to avoid
  /// premature direction fetching to the wrong target.
  Option<GeoPoint> _getMultiStoreTarget(AppOrder order) {
    final sortedStopsAsync = ref.watch(sortedPickupStopsProvider);

    // If store data is still loading, return None to avoid flashing
    // directions to customer then switching to store.
    if (sortedStopsAsync.isLoading && !sortedStopsAsync.hasValue) {
      return const None();
    }

    // Navigate to the nearest active store
    final currentStop = ref.watch(currentPickupStopProvider);
    if (currentStop != null && currentStop.storeGeoPoint != null) {
      return Some(currentStop.storeGeoPoint!);
    }

    // All stores picked up → navigate to customer
    if (order.allStoresPickedUp) {
      return Option<GeoPoint>.fromNullable(order.address?.geoPoint);
    }

    // No store has a location → fallback to customer
    return Option<GeoPoint>.fromNullable(order.address?.geoPoint);
  }

  void update(Option<GeoPoint> Function(Option<GeoPoint> state) fn) =>
      state = fn(state);
}
