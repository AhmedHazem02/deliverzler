// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_stream_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$locationStreamHash() => r'5cdc9227b3293d6486e99fb784c4099011bf5ac5';

/// See also [locationStream].
@ProviderFor(locationStream)
final locationStreamProvider = AutoDisposeStreamProvider<Position>.internal(
  locationStream,
  name: r'locationStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$locationStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocationStreamRef = AutoDisposeStreamProviderRef<Position>;
String _$enableLocationHash() => r'8d07036a35d4814014e2d3e2f33b7b248a286b96';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [enableLocation].
@ProviderFor(enableLocation)
const enableLocationProvider = EnableLocationFamily();

/// See also [enableLocation].
class EnableLocationFamily extends Family<AsyncValue<void>> {
  /// See also [enableLocation].
  const EnableLocationFamily();

  /// See also [enableLocation].
  EnableLocationProvider call(
    LocationService locationService,
  ) {
    return EnableLocationProvider(
      locationService,
    );
  }

  @override
  EnableLocationProvider getProviderOverride(
    covariant EnableLocationProvider provider,
  ) {
    return call(
      provider.locationService,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'enableLocationProvider';
}

/// See also [enableLocation].
class EnableLocationProvider extends AutoDisposeFutureProvider<void> {
  /// See also [enableLocation].
  EnableLocationProvider(
    LocationService locationService,
  ) : this._internal(
          (ref) => enableLocation(
            ref as EnableLocationRef,
            locationService,
          ),
          from: enableLocationProvider,
          name: r'enableLocationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$enableLocationHash,
          dependencies: EnableLocationFamily._dependencies,
          allTransitiveDependencies:
              EnableLocationFamily._allTransitiveDependencies,
          locationService: locationService,
        );

  EnableLocationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.locationService,
  }) : super.internal();

  final LocationService locationService;

  @override
  Override overrideWith(
    FutureOr<void> Function(EnableLocationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EnableLocationProvider._internal(
        (ref) => create(ref as EnableLocationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        locationService: locationService,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _EnableLocationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EnableLocationProvider &&
        other.locationService == locationService;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, locationService.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin EnableLocationRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `locationService` of this provider.
  LocationService get locationService;
}

class _EnableLocationProviderElement
    extends AutoDisposeFutureProviderElement<void> with EnableLocationRef {
  _EnableLocationProviderElement(super.provider);

  @override
  LocationService get locationService =>
      (origin as EnableLocationProvider).locationService;
}

String _$requestLocationPermissionHash() =>
    r'890cb6046e8414c7fad299b2268b1c327ee852d3';

/// See also [requestLocationPermission].
@ProviderFor(requestLocationPermission)
const requestLocationPermissionProvider = RequestLocationPermissionFamily();

/// See also [requestLocationPermission].
class RequestLocationPermissionFamily extends Family<AsyncValue<void>> {
  /// See also [requestLocationPermission].
  const RequestLocationPermissionFamily();

  /// See also [requestLocationPermission].
  RequestLocationPermissionProvider call(
    LocationService locationService,
  ) {
    return RequestLocationPermissionProvider(
      locationService,
    );
  }

  @override
  RequestLocationPermissionProvider getProviderOverride(
    covariant RequestLocationPermissionProvider provider,
  ) {
    return call(
      provider.locationService,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'requestLocationPermissionProvider';
}

/// See also [requestLocationPermission].
class RequestLocationPermissionProvider
    extends AutoDisposeFutureProvider<void> {
  /// See also [requestLocationPermission].
  RequestLocationPermissionProvider(
    LocationService locationService,
  ) : this._internal(
          (ref) => requestLocationPermission(
            ref as RequestLocationPermissionRef,
            locationService,
          ),
          from: requestLocationPermissionProvider,
          name: r'requestLocationPermissionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$requestLocationPermissionHash,
          dependencies: RequestLocationPermissionFamily._dependencies,
          allTransitiveDependencies:
              RequestLocationPermissionFamily._allTransitiveDependencies,
          locationService: locationService,
        );

  RequestLocationPermissionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.locationService,
  }) : super.internal();

  final LocationService locationService;

  @override
  Override overrideWith(
    FutureOr<void> Function(RequestLocationPermissionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RequestLocationPermissionProvider._internal(
        (ref) => create(ref as RequestLocationPermissionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        locationService: locationService,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _RequestLocationPermissionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RequestLocationPermissionProvider &&
        other.locationService == locationService;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, locationService.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RequestLocationPermissionRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `locationService` of this provider.
  LocationService get locationService;
}

class _RequestLocationPermissionProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with RequestLocationPermissionRef {
  _RequestLocationPermissionProviderElement(super.provider);

  @override
  LocationService get locationService =>
      (origin as RequestLocationPermissionProvider).locationService;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
