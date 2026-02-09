// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_verification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$phoneVerificationHash() => r'2c85ef536d596fe719cb19dacceffabae379f479';

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

abstract class _$PhoneVerification
    extends BuildlessAutoDisposeNotifier<PhoneVerificationState> {
  late final String phone;

  PhoneVerificationState build(
    String phone,
  );
}

/// See also [PhoneVerification].
@ProviderFor(PhoneVerification)
const phoneVerificationProvider = PhoneVerificationFamily();

/// See also [PhoneVerification].
class PhoneVerificationFamily extends Family<PhoneVerificationState> {
  /// See also [PhoneVerification].
  const PhoneVerificationFamily();

  /// See also [PhoneVerification].
  PhoneVerificationProvider call(
    String phone,
  ) {
    return PhoneVerificationProvider(
      phone,
    );
  }

  @override
  PhoneVerificationProvider getProviderOverride(
    covariant PhoneVerificationProvider provider,
  ) {
    return call(
      provider.phone,
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
  String? get name => r'phoneVerificationProvider';
}

/// See also [PhoneVerification].
class PhoneVerificationProvider extends AutoDisposeNotifierProviderImpl<
    PhoneVerification, PhoneVerificationState> {
  /// See also [PhoneVerification].
  PhoneVerificationProvider(
    String phone,
  ) : this._internal(
          () => PhoneVerification()..phone = phone,
          from: phoneVerificationProvider,
          name: r'phoneVerificationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$phoneVerificationHash,
          dependencies: PhoneVerificationFamily._dependencies,
          allTransitiveDependencies:
              PhoneVerificationFamily._allTransitiveDependencies,
          phone: phone,
        );

  PhoneVerificationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.phone,
  }) : super.internal();

  final String phone;

  @override
  PhoneVerificationState runNotifierBuild(
    covariant PhoneVerification notifier,
  ) {
    return notifier.build(
      phone,
    );
  }

  @override
  Override overrideWith(PhoneVerification Function() create) {
    return ProviderOverride(
      origin: this,
      override: PhoneVerificationProvider._internal(
        () => create()..phone = phone,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        phone: phone,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<PhoneVerification, PhoneVerificationState>
      createElement() {
    return _PhoneVerificationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PhoneVerificationProvider && other.phone == phone;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, phone.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PhoneVerificationRef
    on AutoDisposeNotifierProviderRef<PhoneVerificationState> {
  /// The parameter `phone` of this provider.
  String get phone;
}

class _PhoneVerificationProviderElement
    extends AutoDisposeNotifierProviderElement<PhoneVerification,
        PhoneVerificationState> with PhoneVerificationRef {
  _PhoneVerificationProviderElement(super.provider);

  @override
  String get phone => (origin as PhoneVerificationProvider).phone;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
