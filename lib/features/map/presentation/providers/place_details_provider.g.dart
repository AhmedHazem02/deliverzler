// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentPlaceDetailsHash() =>
    r'793764e32cb825a700dda621da1ffc99c2049cb1';

/// See also [currentPlaceDetails].
@ProviderFor(currentPlaceDetails)
final currentPlaceDetailsProvider =
    AutoDisposeProvider<Option<PlaceDetails>>.internal(
  currentPlaceDetails,
  name: r'currentPlaceDetailsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentPlaceDetailsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentPlaceDetailsRef = AutoDisposeProviderRef<Option<PlaceDetails>>;
String _$getPlaceDetailsHash() => r'c560d0240161417ba1c580dc55b37439c9c7dbd9';

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

/// See also [getPlaceDetails].
@ProviderFor(getPlaceDetails)
const getPlaceDetailsProvider = GetPlaceDetailsFamily();

/// See also [getPlaceDetails].
class GetPlaceDetailsFamily extends Family<AsyncValue<PlaceDetails>> {
  /// See also [getPlaceDetails].
  const GetPlaceDetailsFamily();

  /// See also [getPlaceDetails].
  GetPlaceDetailsProvider call(
    String placeId,
  ) {
    return GetPlaceDetailsProvider(
      placeId,
    );
  }

  @override
  GetPlaceDetailsProvider getProviderOverride(
    covariant GetPlaceDetailsProvider provider,
  ) {
    return call(
      provider.placeId,
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
  String? get name => r'getPlaceDetailsProvider';
}

/// See also [getPlaceDetails].
class GetPlaceDetailsProvider extends AutoDisposeFutureProvider<PlaceDetails> {
  /// See also [getPlaceDetails].
  GetPlaceDetailsProvider(
    String placeId,
  ) : this._internal(
          (ref) => getPlaceDetails(
            ref as GetPlaceDetailsRef,
            placeId,
          ),
          from: getPlaceDetailsProvider,
          name: r'getPlaceDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getPlaceDetailsHash,
          dependencies: GetPlaceDetailsFamily._dependencies,
          allTransitiveDependencies:
              GetPlaceDetailsFamily._allTransitiveDependencies,
          placeId: placeId,
        );

  GetPlaceDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.placeId,
  }) : super.internal();

  final String placeId;

  @override
  Override overrideWith(
    FutureOr<PlaceDetails> Function(GetPlaceDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetPlaceDetailsProvider._internal(
        (ref) => create(ref as GetPlaceDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        placeId: placeId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PlaceDetails> createElement() {
    return _GetPlaceDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetPlaceDetailsProvider && other.placeId == placeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, placeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetPlaceDetailsRef on AutoDisposeFutureProviderRef<PlaceDetails> {
  /// The parameter `placeId` of this provider.
  String get placeId;
}

class _GetPlaceDetailsProviderElement
    extends AutoDisposeFutureProviderElement<PlaceDetails>
    with GetPlaceDetailsRef {
  _GetPlaceDetailsProviderElement(super.provider);

  @override
  String get placeId => (origin as GetPlaceDetailsProvider).placeId;
}

String _$selectedPlaceAutocompleteHash() =>
    r'b751978f4fdaac95fee1d8daefdbc317f35b9055';

/// See also [SelectedPlaceAutocomplete].
@ProviderFor(SelectedPlaceAutocomplete)
final selectedPlaceAutocompleteProvider = AutoDisposeNotifierProvider<
    SelectedPlaceAutocomplete, Option<PlaceAutocomplete>>.internal(
  SelectedPlaceAutocomplete.new,
  name: r'selectedPlaceAutocompleteProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedPlaceAutocompleteHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedPlaceAutocomplete
    = AutoDisposeNotifier<Option<PlaceAutocomplete>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
