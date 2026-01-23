// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_location_marker_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myLocationMarkerHash() => r'2c92316b48a68b01e1833dbb6be0443740f842f8';

/// See also [myLocationMarker].
@ProviderFor(myLocationMarker)
final myLocationMarkerProvider = AutoDisposeProvider<Option<Marker>>.internal(
  myLocationMarker,
  name: r'myLocationMarkerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myLocationMarkerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MyLocationMarkerRef = AutoDisposeProviderRef<Option<Marker>>;
String _$myLocationMarkerIconHash() =>
    r'a8790b714c57d5bcf200bc79f79bc201dfed5701';

/// See also [myLocationMarkerIcon].
@ProviderFor(myLocationMarkerIcon)
final myLocationMarkerIconProvider =
    AutoDisposeFutureProvider<BitmapDescriptor>.internal(
  myLocationMarkerIcon,
  name: r'myLocationMarkerIconProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myLocationMarkerIconHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MyLocationMarkerIconRef
    = AutoDisposeFutureProviderRef<BitmapDescriptor>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
