import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/presentation/utils/fp_framework.dart';
import '../../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../home/domain/store.dart';
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
  if (order == null) {
    print('🏪 StoreMarkers: No selected order');
    return {};
  }

  print(
      '🏪 StoreMarkers: Order ${order.id}, isMultiStore=${order.isMultiStore}, storeId=${order.storeId}');

  final Set<Marker> markers = {};

  if (order.isMultiStore) {
    // ── Multi-store: show a numbered marker per pickup stop ──
    final sortedStopsAsync = ref.watch(sortedPickupStopsProvider);
    print(
        '🏪 StoreMarkers: sortedStopsAsync isLoading=${sortedStopsAsync.isLoading}, hasValue=${sortedStopsAsync.hasValue}, hasError=${sortedStopsAsync.hasError}');

    final sortedStops = sortedStopsAsync.valueOrNull;
    if (sortedStops == null || sortedStops.isEmpty) {
      print('🏪 StoreMarkers: Multi-store but no sorted stops yet');
      return {};
    }

    final currentStop = ref.watch(currentPickupStopProvider);

    for (int i = 0; i < sortedStops.length; i++) {
      final stopData = sortedStops[i];
      final geoPoint = stopData.storeGeoPoint;
      print(
          '🏪 StoreMarkers: Stop[$i] "${stopData.stop.storeName}" storeId=${stopData.stop.storeId}, hasGeo=${geoPoint != null}, hasStore=${stopData.store != null}, storeHasLoc=${stopData.store?.hasLocation}');
      if (geoPoint == null) continue;

      final isCurrent = currentStop?.stop.storeId == stopData.stop.storeId;

      final icon = await StoreMarkerHelper.createStoreMarkerIcon(
        index: i + 1,
        isPickedUp: stopData.stop.isPickedUp,
        isCurrentStop: isCurrent,
      );

      markers.add(Marker(
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
      ));
      print(
          '🏪 StoreMarkers: ✅ Added multi-store marker "${stopData.stop.storeName}" (#${i + 1}) at ${geoPoint.latitude},${geoPoint.longitude}');
    }
  } else {
    // ── Single-store: show one store marker ──
    final storeId = order.storeId;
    print('🏪 StoreMarkers: Single-store, storeId=$storeId');

    if (storeId == null || storeId.isEmpty) {
      print('🏪 StoreMarkers: ❌ No storeId on order');
      return {};
    }

    final storeAsync = ref.watch(storeProvider(storeId));
    print(
        '🏪 StoreMarkers: storeAsync isLoading=${storeAsync.isLoading}, hasValue=${storeAsync.hasValue}, hasError=${storeAsync.hasError}');

    final store = storeAsync.valueOrNull;
    if (store == null) {
      print('🏪 StoreMarkers: ❌ Store is null (not loaded yet or not found)');
      return {};
    }
    if (!store.hasLocation) {
      print(
          '🏪 StoreMarkers: ❌ Store "${store.name}" has no location (lat=${store.latitude}, lng=${store.longitude})');
      return {};
    }

    final icon = await StoreMarkerHelper.createStoreMarkerIcon();

    markers.add(Marker(
      markerId: MarkerId('store_$storeId'),
      position: LatLng(store.latitude!, store.longitude!),
      icon: icon,
      zIndex: 80,
      infoWindow: InfoWindow(
        title: store.name.isNotEmpty ? store.name : 'المتجر',
      ),
    ));
    print(
        '🏪 StoreMarkers: ✅ Added single-store marker "${store.name}" at ${store.latitude},${store.longitude}');
  }

  return markers;
}

/// Provides the customer delivery address marker.
///
/// Always shows the delivery location from the order (delivery_latitude/longitude),
/// independent of the navigation target.
@riverpod
Future<Marker?> customerDeliveryMarker(Ref ref) async {
  final order = ref.watch(selectedOrderProvider).toNullable();
  if (order == null) {
    print('📍 CustomerMarker: No selected order');
    return null;
  }

  final geoPoint = order.address?.geoPoint;
  if (geoPoint == null) {
    print(
        '📍 CustomerMarker: ❌ No delivery geoPoint (address=${order.address != null})');
    return null;
  }

  print(
      '📍 CustomerMarker: ✅ Delivery at ${geoPoint.latitude},${geoPoint.longitude}');

  // Build address string for info window
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
  print('🗺️ MapMarkers building...');
  final Set<Marker> markers = {};

  // Watch My Location Marker (driver)
  final myMarkerOption = ref.watch(myLocationMarkerProvider);
  myMarkerOption.fold(
    () => print('🗺️ MapMarkers: My location marker is NONE'),
    (marker) {
      print('🗺️ MapMarkers: Adding driver marker');
      markers.add(marker);
    },
  );

  // Watch Target Location Marker (navigation target — store or route search)
  final targetMarker = ref.watch(targetLocationMarkerProvider);
  print('🗺️ MapMarkers: Adding target marker');
  markers.add(targetMarker);

  // Watch Customer Delivery Marker (async — always shows delivery address)
  final customerAsync = ref.watch(customerDeliveryMarkerProvider);
  customerAsync.whenData((marker) {
    if (marker != null) {
      markers.add(marker);
      print(
          '🗺️ MapMarkers: Added customer delivery marker at ${marker.position.latitude},${marker.position.longitude}');
    }
  });

  // Watch Store Markers (async — include when resolved)
  final storeAsync = ref.watch(storeMarkersProvider);
  storeAsync.whenData((storeSet) {
    markers.addAll(storeSet);
    print('🗺️ MapMarkers: Added ${storeSet.length} store marker(s)');
  });

  print('🗺️ MapMarkers: Total markers = ${markers.length}');
  return markers;
}
