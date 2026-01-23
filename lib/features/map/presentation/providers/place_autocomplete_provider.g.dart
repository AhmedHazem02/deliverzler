// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_autocomplete_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$placeAutocompleteStateHash() =>
    r'ac76936a204fdbe0f5df04774c92bd09080abdd2';

/// See also [placeAutocompleteState].
@ProviderFor(placeAutocompleteState)
final placeAutocompleteStateProvider =
    AutoDisposeFutureProvider<List<PlaceAutocomplete>>.internal(
  placeAutocompleteState,
  name: r'placeAutocompleteStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$placeAutocompleteStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PlaceAutocompleteStateRef
    = AutoDisposeFutureProviderRef<List<PlaceAutocomplete>>;
String _$getPlaceAutocompleteHash() =>
    r'2933d03c98d9290eae941b4569a4baa07da90e87';

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

/// See also [getPlaceAutocomplete].
@ProviderFor(getPlaceAutocomplete)
const getPlaceAutocompleteProvider = GetPlaceAutocompleteFamily();

/// See also [getPlaceAutocomplete].
class GetPlaceAutocompleteFamily
    extends Family<AsyncValue<List<PlaceAutocomplete>>> {
  /// See also [getPlaceAutocomplete].
  const GetPlaceAutocompleteFamily();

  /// See also [getPlaceAutocomplete].
  GetPlaceAutocompleteProvider call(
    String autocompleteQuery,
  ) {
    return GetPlaceAutocompleteProvider(
      autocompleteQuery,
    );
  }

  @override
  GetPlaceAutocompleteProvider getProviderOverride(
    covariant GetPlaceAutocompleteProvider provider,
  ) {
    return call(
      provider.autocompleteQuery,
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
  String? get name => r'getPlaceAutocompleteProvider';
}

/// See also [getPlaceAutocomplete].
class GetPlaceAutocompleteProvider
    extends AutoDisposeFutureProvider<List<PlaceAutocomplete>> {
  /// See also [getPlaceAutocomplete].
  GetPlaceAutocompleteProvider(
    String autocompleteQuery,
  ) : this._internal(
          (ref) => getPlaceAutocomplete(
            ref as GetPlaceAutocompleteRef,
            autocompleteQuery,
          ),
          from: getPlaceAutocompleteProvider,
          name: r'getPlaceAutocompleteProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getPlaceAutocompleteHash,
          dependencies: GetPlaceAutocompleteFamily._dependencies,
          allTransitiveDependencies:
              GetPlaceAutocompleteFamily._allTransitiveDependencies,
          autocompleteQuery: autocompleteQuery,
        );

  GetPlaceAutocompleteProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.autocompleteQuery,
  }) : super.internal();

  final String autocompleteQuery;

  @override
  Override overrideWith(
    FutureOr<List<PlaceAutocomplete>> Function(GetPlaceAutocompleteRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetPlaceAutocompleteProvider._internal(
        (ref) => create(ref as GetPlaceAutocompleteRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        autocompleteQuery: autocompleteQuery,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PlaceAutocomplete>> createElement() {
    return _GetPlaceAutocompleteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetPlaceAutocompleteProvider &&
        other.autocompleteQuery == autocompleteQuery;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, autocompleteQuery.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetPlaceAutocompleteRef
    on AutoDisposeFutureProviderRef<List<PlaceAutocomplete>> {
  /// The parameter `autocompleteQuery` of this provider.
  String get autocompleteQuery;
}

class _GetPlaceAutocompleteProviderElement
    extends AutoDisposeFutureProviderElement<List<PlaceAutocomplete>>
    with GetPlaceAutocompleteRef {
  _GetPlaceAutocompleteProviderElement(super.provider);

  @override
  String get autocompleteQuery =>
      (origin as GetPlaceAutocompleteProvider).autocompleteQuery;
}

String _$placeAutocompleteQueryHash() =>
    r'4f5c2cffbd46169ac9e4e7c3de9923991b834b89';

/// See also [PlaceAutocompleteQuery].
@ProviderFor(PlaceAutocompleteQuery)
final placeAutocompleteQueryProvider = AutoDisposeNotifierProvider<
    PlaceAutocompleteQuery, Option<String>>.internal(
  PlaceAutocompleteQuery.new,
  name: r'placeAutocompleteQueryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$placeAutocompleteQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PlaceAutocompleteQuery = AutoDisposeNotifier<Option<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
