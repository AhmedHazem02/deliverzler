// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_controller_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentMapControllerHash() =>
    r'472214da48eacf7ea5ae7495762f2dee57a79ca5';

/// See also [CurrentMapController].
@ProviderFor(CurrentMapController)
final currentMapControllerProvider = AutoDisposeNotifierProvider<
    CurrentMapController, GoogleMapController?>.internal(
  CurrentMapController.new,
  name: r'currentMapControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentMapControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentMapController = AutoDisposeNotifier<GoogleMapController?>;
String _$mapControllerHash() => r'0172c537173e0e6f3f00f68c7981c99a984cec27';

/// See also [MapController].
@ProviderFor(MapController)
final mapControllerProvider =
    AutoDisposeNotifierProvider<MapController, GoogleMapController?>.internal(
  MapController.new,
  name: r'mapControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mapControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MapController = AutoDisposeNotifier<GoogleMapController?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
