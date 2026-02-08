// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_markers_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$storeMarkersHash() => r'fd7f400f1ab3c50e041f3a42e54456959037a919';

/// Provides the store markers (custom icons) for the selected order.
///
/// Returns a [Future] because custom marker icons are drawn asynchronously.
/// Handles both single-store and multi-store orders.
///
/// Copied from [storeMarkers].
@ProviderFor(storeMarkers)
final storeMarkersProvider = AutoDisposeFutureProvider<Set<Marker>>.internal(
  storeMarkers,
  name: r'storeMarkersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$storeMarkersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef StoreMarkersRef = AutoDisposeFutureProviderRef<Set<Marker>>;
String _$customerDeliveryMarkerHash() =>
    r'3dbcae5239e5655c415da8275b883eec9e9344bb';

/// Provides the customer delivery address marker.
///
/// Always shows the delivery location from the order (delivery_latitude/longitude),
/// independent of the navigation target.
///
/// Copied from [customerDeliveryMarker].
@ProviderFor(customerDeliveryMarker)
final customerDeliveryMarkerProvider =
    AutoDisposeFutureProvider<Marker?>.internal(
  customerDeliveryMarker,
  name: r'customerDeliveryMarkerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$customerDeliveryMarkerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CustomerDeliveryMarkerRef = AutoDisposeFutureProviderRef<Marker?>;
String _$mapMarkersHash() => r'a36052370120c21206cb1ad50144da426e24a113';

/// Combined map markers provider.
///
/// Watches all marker sources (driver, customer delivery, stores) and returns
/// a single `Set<Marker>`. Re-evaluates automatically when any source changes.
///
/// Copied from [mapMarkers].
@ProviderFor(mapMarkers)
final mapMarkersProvider = AutoDisposeProvider<Set<Marker>>.internal(
  mapMarkers,
  name: r'mapMarkersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$mapMarkersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MapMarkersRef = AutoDisposeProviderRef<Set<Marker>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
