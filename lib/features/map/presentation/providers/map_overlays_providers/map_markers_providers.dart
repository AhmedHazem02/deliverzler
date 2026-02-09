// ignore_for_file: deprecated_member_use, avoid_manual_providers_as_generated_provider_dependency

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../home/presentation/providers/multi_stop_navigation_provider.dart';
import '../../../../home/presentation/providers/selected_order_provider.dart';
import '../../../../home/presentation/providers/store_provider.dart';
import '../../helpers/customer_marker_helper.dart';
import '../../helpers/store_marker_helper.dart';
import '../my_location_providers/my_location_marker_provider.dart';
import '../target_location_providers/target_location_marker_provider.dart';

part 'map_markers_providers.g.dart';

/// Provides the store markers (custom icons) for the selected order.
///
/// Returns a [Future] because custom marker icons are drawn asynchronously.
/// Handles both single-store and multi-store orders.
@riverpod
Future<Set<Marker>> storeMarkers(Ref ref) async {
  final order = ref.watch(selectedOrderProvider).toNullable();
  if (order == null) return {};

  final markers = <Marker>{};

  if (order.isMultiStore) {
    final sortedStopsAsync = ref.watch(sortedPickupStopsProvider);
    final sortedStops = sortedStopsAsync.valueOrNull;
    if (sortedStops == null || sortedStops.isEmpty) return {};

    final currentStop = ref.watch(currentPickupStopProvider);

    for (var i = 0; i < sortedStops.length; i++) {
      final stopData = sortedStops[i];
      final geoPoint = stopData.storeGeoPoint;
      if (geoPoint == null) continue;

      final isCurrent = currentStop?.stop.storeId == stopData.stop.storeId;

      final icon = await StoreMarkerHelper.createStoreMarkerIcon(
        index: i + 1,
        isPickedUp: stopData.stop.isPickedUp,
        isCurrentStop: isCurrent,
      );

      markers.add(
        Marker(
          markerId: MarkerId('store_${stopData.stop.storeId}'),
          position: LatLng(geoPoint.latitude, geoPoint.longitude),
          icon: icon,
          zIndex: isCurrent ? 90 : 80,
          infoWindow: InfoWindow(
            title: '${stopData.stop.storeName} (#${i + 1})',
            snippet: stopData.formattedDistance.isNotEmpty
                ? stopData.formattedDistance
                : null,
          ),
        ),
      );
    }
  } else {
    final storeId = order.storeId;
    if (storeId == null || storeId.isEmpty) return {};

    final storeAsync = ref.watch(storeProvider(storeId));
    final store = storeAsync.valueOrNull;
    if (store == null || !store.hasLocation) return {};

    final icon = await StoreMarkerHelper.createStoreMarkerIcon();

    markers.add(
      Marker(
        markerId: MarkerId('store_$storeId'),
        position: LatLng(store.latitude!, store.longitude!),
        icon: icon,
        zIndex: 80,
        infoWindow: InfoWindow(
          title: store.name.isNotEmpty ? store.name : 'المتجر',
        ),
      ),
    );
  }

  return markers;
}

/// Provides the customer delivery address marker.
@riverpod
Future<Marker?> customerDeliveryMarker(Ref ref) async {
  final order = ref.watch(selectedOrderProvider).toNullable();
  if (order == null) return null;

  final geoPoint = order.address?.geoPoint;
  if (geoPoint == null) return null;

  final addressParts = <String>[];
  if (order.address!.street.isNotEmpty) addressParts.add(order.address!.street);
  if (order.address!.city.isNotEmpty) addressParts.add(order.address!.city);
  final addressText =
      addressParts.isNotEmpty ? addressParts.join(', ') : 'عنوان التوصيل';

  final icon = await CustomerMarkerHelper.createCustomerMarkerIcon();

  return Marker(
    markerId: const MarkerId('customer_delivery'),
    position: LatLng(geoPoint.latitude, geoPoint.longitude),
    icon: icon,
    zIndex: 85,
    infoWindow: InfoWindow(
      title: order.userName.isNotEmpty ? order.userName : 'العميل',
      snippet: addressText,
    ),
  );
}

/// Combined map markers provider.
///
/// Watches all marker sources (driver, customer delivery, stores) and returns
/// a single `Set<Marker>`. Re-evaluates automatically when any source changes.
@riverpod
Set<Marker> mapMarkers(Ref ref) {
  final markers = <Marker>{};

  // Watch My Location Marker (driver)
  final myMarkerOption = ref.watch(myLocationMarkerProvider);
  myMarkerOption.fold(
    () {},
    markers.add,
  );

  // Watch Target Location Marker
  final targetMarker = ref.watch(targetLocationMarkerProvider);
  markers.add(targetMarker);

  // Watch Customer Delivery Marker (async)
  final customerAsync = ref.watch(customerDeliveryMarkerProvider);
  customerAsync.whenData((marker) {
    if (marker != null) markers.add(marker);
  });

  // Watch Store Markers (async)
  final storeAsync = ref.watch(storeMarkersProvider);
  storeAsync.whenData(markers.addAll);

  return markers;
}
