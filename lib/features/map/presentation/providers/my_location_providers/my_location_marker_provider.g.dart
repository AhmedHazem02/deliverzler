// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_location_marker_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myLocationMarkerIconHash() =>
    r'eaa9dfec2bad05ca8cac0a57d9890e458d6f7292';

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
String _$myLocationMarkerHash() => r'68ab115b4bde453d9161654f9d2e7c54f04307e8';

/// See also [MyLocationMarker].
@ProviderFor(MyLocationMarker)
final myLocationMarkerProvider =
    AutoDisposeNotifierProvider<MyLocationMarker, Option<Marker>>.internal(
  MyLocationMarker.new,
  name: r'myLocationMarkerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myLocationMarkerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MyLocationMarker = AutoDisposeNotifier<Option<Marker>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
