// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pick_profile_image_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pickProfileImageHash() => r'e1f9774c7a850a9e7322a811cd3d9a209cd82983';

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

/// See also [pickProfileImage].
@ProviderFor(pickProfileImage)
const pickProfileImageProvider = PickProfileImageFamily();

/// See also [pickProfileImage].
class PickProfileImageFamily extends Family<AsyncValue<File>> {
  /// See also [pickProfileImage].
  const PickProfileImageFamily();

  /// See also [pickProfileImage].
  PickProfileImageProvider call(
    PickSource pickSource,
  ) {
    return PickProfileImageProvider(
      pickSource,
    );
  }

  @override
  PickProfileImageProvider getProviderOverride(
    covariant PickProfileImageProvider provider,
  ) {
    return call(
      provider.pickSource,
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
  String? get name => r'pickProfileImageProvider';
}

/// See also [pickProfileImage].
class PickProfileImageProvider extends AutoDisposeFutureProvider<File> {
  /// See also [pickProfileImage].
  PickProfileImageProvider(
    PickSource pickSource,
  ) : this._internal(
          (ref) => pickProfileImage(
            ref as PickProfileImageRef,
            pickSource,
          ),
          from: pickProfileImageProvider,
          name: r'pickProfileImageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pickProfileImageHash,
          dependencies: PickProfileImageFamily._dependencies,
          allTransitiveDependencies:
              PickProfileImageFamily._allTransitiveDependencies,
          pickSource: pickSource,
        );

  PickProfileImageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pickSource,
  }) : super.internal();

  final PickSource pickSource;

  @override
  Override overrideWith(
    FutureOr<File> Function(PickProfileImageRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PickProfileImageProvider._internal(
        (ref) => create(ref as PickProfileImageRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pickSource: pickSource,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<File> createElement() {
    return _PickProfileImageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PickProfileImageProvider && other.pickSource == pickSource;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pickSource.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PickProfileImageRef on AutoDisposeFutureProviderRef<File> {
  /// The parameter `pickSource` of this provider.
  PickSource get pickSource;
}

class _PickProfileImageProviderElement
    extends AutoDisposeFutureProviderElement<File> with PickProfileImageRef {
  _PickProfileImageProviderElement(super.provider);

  @override
  PickSource get pickSource => (origin as PickProfileImageProvider).pickSource;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
