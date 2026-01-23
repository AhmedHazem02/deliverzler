// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_delivery_geo_point_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$updateDeliveryGeoPointStateHash() =>
    r'77523c18f803b69fb7aa8008b57e3f9ebba900ad';

/// See also [updateDeliveryGeoPointState].
@ProviderFor(updateDeliveryGeoPointState)
final updateDeliveryGeoPointStateProvider =
    AutoDisposeFutureProvider<void>.internal(
  updateDeliveryGeoPointState,
  name: r'updateDeliveryGeoPointStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateDeliveryGeoPointStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UpdateDeliveryGeoPointStateRef = AutoDisposeFutureProviderRef<void>;
String _$updateDeliveryGeoPointHash() =>
    r'12087cbe60b02e74b6cccf666b7bc62a6f88564e';

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

/// See also [updateDeliveryGeoPoint].
@ProviderFor(updateDeliveryGeoPoint)
const updateDeliveryGeoPointProvider = UpdateDeliveryGeoPointFamily();

/// See also [updateDeliveryGeoPoint].
class UpdateDeliveryGeoPointFamily extends Family<AsyncValue<void>> {
  /// See also [updateDeliveryGeoPoint].
  const UpdateDeliveryGeoPointFamily();

  /// See also [updateDeliveryGeoPoint].
  UpdateDeliveryGeoPointProvider call(
    UpdateDeliveryGeoPoint deliveryGeoPoint,
  ) {
    return UpdateDeliveryGeoPointProvider(
      deliveryGeoPoint,
    );
  }

  @override
  UpdateDeliveryGeoPointProvider getProviderOverride(
    covariant UpdateDeliveryGeoPointProvider provider,
  ) {
    return call(
      provider.deliveryGeoPoint,
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
  String? get name => r'updateDeliveryGeoPointProvider';
}

/// See also [updateDeliveryGeoPoint].
class UpdateDeliveryGeoPointProvider extends AutoDisposeFutureProvider<void> {
  /// See also [updateDeliveryGeoPoint].
  UpdateDeliveryGeoPointProvider(
    UpdateDeliveryGeoPoint deliveryGeoPoint,
  ) : this._internal(
          (ref) => updateDeliveryGeoPoint(
            ref as UpdateDeliveryGeoPointRef,
            deliveryGeoPoint,
          ),
          from: updateDeliveryGeoPointProvider,
          name: r'updateDeliveryGeoPointProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateDeliveryGeoPointHash,
          dependencies: UpdateDeliveryGeoPointFamily._dependencies,
          allTransitiveDependencies:
              UpdateDeliveryGeoPointFamily._allTransitiveDependencies,
          deliveryGeoPoint: deliveryGeoPoint,
        );

  UpdateDeliveryGeoPointProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.deliveryGeoPoint,
  }) : super.internal();

  final UpdateDeliveryGeoPoint deliveryGeoPoint;

  @override
  Override overrideWith(
    FutureOr<void> Function(UpdateDeliveryGeoPointRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateDeliveryGeoPointProvider._internal(
        (ref) => create(ref as UpdateDeliveryGeoPointRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        deliveryGeoPoint: deliveryGeoPoint,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UpdateDeliveryGeoPointProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateDeliveryGeoPointProvider &&
        other.deliveryGeoPoint == deliveryGeoPoint;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, deliveryGeoPoint.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UpdateDeliveryGeoPointRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `deliveryGeoPoint` of this provider.
  UpdateDeliveryGeoPoint get deliveryGeoPoint;
}

class _UpdateDeliveryGeoPointProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with UpdateDeliveryGeoPointRef {
  _UpdateDeliveryGeoPointProviderElement(super.provider);

  @override
  UpdateDeliveryGeoPoint get deliveryGeoPoint =>
      (origin as UpdateDeliveryGeoPointProvider).deliveryGeoPoint;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
