// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_application_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$driverApplicationStreamHash() =>
    r'f07d45e1c9bb1f7d051015f0240f44f5b150f973';

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

/// Provider to watch the current user's application status
///
/// Copied from [driverApplicationStream].
@ProviderFor(driverApplicationStream)
const driverApplicationStreamProvider = DriverApplicationStreamFamily();

/// Provider to watch the current user's application status
///
/// Copied from [driverApplicationStream].
class DriverApplicationStreamFamily
    extends Family<AsyncValue<DriverApplication?>> {
  /// Provider to watch the current user's application status
  ///
  /// Copied from [driverApplicationStream].
  const DriverApplicationStreamFamily();

  /// Provider to watch the current user's application status
  ///
  /// Copied from [driverApplicationStream].
  DriverApplicationStreamProvider call(
    String userId,
  ) {
    return DriverApplicationStreamProvider(
      userId,
    );
  }

  @override
  DriverApplicationStreamProvider getProviderOverride(
    covariant DriverApplicationStreamProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'driverApplicationStreamProvider';
}

/// Provider to watch the current user's application status
///
/// Copied from [driverApplicationStream].
class DriverApplicationStreamProvider
    extends AutoDisposeStreamProvider<DriverApplication?> {
  /// Provider to watch the current user's application status
  ///
  /// Copied from [driverApplicationStream].
  DriverApplicationStreamProvider(
    String userId,
  ) : this._internal(
          (ref) => driverApplicationStream(
            ref as DriverApplicationStreamRef,
            userId,
          ),
          from: driverApplicationStreamProvider,
          name: r'driverApplicationStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$driverApplicationStreamHash,
          dependencies: DriverApplicationStreamFamily._dependencies,
          allTransitiveDependencies:
              DriverApplicationStreamFamily._allTransitiveDependencies,
          userId: userId,
        );

  DriverApplicationStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<DriverApplication?> Function(DriverApplicationStreamRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DriverApplicationStreamProvider._internal(
        (ref) => create(ref as DriverApplicationStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<DriverApplication?> createElement() {
    return _DriverApplicationStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DriverApplicationStreamProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DriverApplicationStreamRef
    on AutoDisposeStreamProviderRef<DriverApplication?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _DriverApplicationStreamProviderElement
    extends AutoDisposeStreamProviderElement<DriverApplication?>
    with DriverApplicationStreamRef {
  _DriverApplicationStreamProviderElement(super.provider);

  @override
  String get userId => (origin as DriverApplicationStreamProvider).userId;
}

String _$driverApplicationHash() => r'400d14a870f7564808b617f740ce441356111dc4';

/// Provider to get the current user's application
///
/// Copied from [driverApplication].
@ProviderFor(driverApplication)
const driverApplicationProvider = DriverApplicationFamily();

/// Provider to get the current user's application
///
/// Copied from [driverApplication].
class DriverApplicationFamily extends Family<AsyncValue<DriverApplication?>> {
  /// Provider to get the current user's application
  ///
  /// Copied from [driverApplication].
  const DriverApplicationFamily();

  /// Provider to get the current user's application
  ///
  /// Copied from [driverApplication].
  DriverApplicationProvider call(
    String userId,
  ) {
    return DriverApplicationProvider(
      userId,
    );
  }

  @override
  DriverApplicationProvider getProviderOverride(
    covariant DriverApplicationProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'driverApplicationProvider';
}

/// Provider to get the current user's application
///
/// Copied from [driverApplication].
class DriverApplicationProvider
    extends AutoDisposeFutureProvider<DriverApplication?> {
  /// Provider to get the current user's application
  ///
  /// Copied from [driverApplication].
  DriverApplicationProvider(
    String userId,
  ) : this._internal(
          (ref) => driverApplication(
            ref as DriverApplicationRef,
            userId,
          ),
          from: driverApplicationProvider,
          name: r'driverApplicationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$driverApplicationHash,
          dependencies: DriverApplicationFamily._dependencies,
          allTransitiveDependencies:
              DriverApplicationFamily._allTransitiveDependencies,
          userId: userId,
        );

  DriverApplicationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<DriverApplication?> Function(DriverApplicationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DriverApplicationProvider._internal(
        (ref) => create(ref as DriverApplicationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DriverApplication?> createElement() {
    return _DriverApplicationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DriverApplicationProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DriverApplicationRef on AutoDisposeFutureProviderRef<DriverApplication?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _DriverApplicationProviderElement
    extends AutoDisposeFutureProviderElement<DriverApplication?>
    with DriverApplicationRef {
  _DriverApplicationProviderElement(super.provider);

  @override
  String get userId => (origin as DriverApplicationProvider).userId;
}

String _$hasExistingApplicationHash() =>
    r'a0f5668d7713b095fb24b99176d9986a82d822d1';

/// Provider to check if user has an existing application
///
/// Copied from [hasExistingApplication].
@ProviderFor(hasExistingApplication)
const hasExistingApplicationProvider = HasExistingApplicationFamily();

/// Provider to check if user has an existing application
///
/// Copied from [hasExistingApplication].
class HasExistingApplicationFamily extends Family<AsyncValue<bool>> {
  /// Provider to check if user has an existing application
  ///
  /// Copied from [hasExistingApplication].
  const HasExistingApplicationFamily();

  /// Provider to check if user has an existing application
  ///
  /// Copied from [hasExistingApplication].
  HasExistingApplicationProvider call(
    String userId,
  ) {
    return HasExistingApplicationProvider(
      userId,
    );
  }

  @override
  HasExistingApplicationProvider getProviderOverride(
    covariant HasExistingApplicationProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'hasExistingApplicationProvider';
}

/// Provider to check if user has an existing application
///
/// Copied from [hasExistingApplication].
class HasExistingApplicationProvider extends AutoDisposeFutureProvider<bool> {
  /// Provider to check if user has an existing application
  ///
  /// Copied from [hasExistingApplication].
  HasExistingApplicationProvider(
    String userId,
  ) : this._internal(
          (ref) => hasExistingApplication(
            ref as HasExistingApplicationRef,
            userId,
          ),
          from: hasExistingApplicationProvider,
          name: r'hasExistingApplicationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hasExistingApplicationHash,
          dependencies: HasExistingApplicationFamily._dependencies,
          allTransitiveDependencies:
              HasExistingApplicationFamily._allTransitiveDependencies,
          userId: userId,
        );

  HasExistingApplicationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<bool> Function(HasExistingApplicationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HasExistingApplicationProvider._internal(
        (ref) => create(ref as HasExistingApplicationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _HasExistingApplicationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HasExistingApplicationProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin HasExistingApplicationRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _HasExistingApplicationProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with HasExistingApplicationRef {
  _HasExistingApplicationProviderElement(super.provider);

  @override
  String get userId => (origin as HasExistingApplicationProvider).userId;
}

String _$applicationStatusHash() => r'fc8c324eb68c2273224629e0231792379dc94c13';

/// Provider to get application status
///
/// Copied from [applicationStatus].
@ProviderFor(applicationStatus)
const applicationStatusProvider = ApplicationStatusFamily();

/// Provider to get application status
///
/// Copied from [applicationStatus].
class ApplicationStatusFamily extends Family<AsyncValue<ApplicationStatus?>> {
  /// Provider to get application status
  ///
  /// Copied from [applicationStatus].
  const ApplicationStatusFamily();

  /// Provider to get application status
  ///
  /// Copied from [applicationStatus].
  ApplicationStatusProvider call(
    String userId,
  ) {
    return ApplicationStatusProvider(
      userId,
    );
  }

  @override
  ApplicationStatusProvider getProviderOverride(
    covariant ApplicationStatusProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'applicationStatusProvider';
}

/// Provider to get application status
///
/// Copied from [applicationStatus].
class ApplicationStatusProvider
    extends AutoDisposeFutureProvider<ApplicationStatus?> {
  /// Provider to get application status
  ///
  /// Copied from [applicationStatus].
  ApplicationStatusProvider(
    String userId,
  ) : this._internal(
          (ref) => applicationStatus(
            ref as ApplicationStatusRef,
            userId,
          ),
          from: applicationStatusProvider,
          name: r'applicationStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$applicationStatusHash,
          dependencies: ApplicationStatusFamily._dependencies,
          allTransitiveDependencies:
              ApplicationStatusFamily._allTransitiveDependencies,
          userId: userId,
        );

  ApplicationStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<ApplicationStatus?> Function(ApplicationStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ApplicationStatusProvider._internal(
        (ref) => create(ref as ApplicationStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ApplicationStatus?> createElement() {
    return _ApplicationStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ApplicationStatusProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ApplicationStatusRef on AutoDisposeFutureProviderRef<ApplicationStatus?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _ApplicationStatusProviderElement
    extends AutoDisposeFutureProviderElement<ApplicationStatus?>
    with ApplicationStatusRef {
  _ApplicationStatusProviderElement(super.provider);

  @override
  String get userId => (origin as ApplicationStatusProvider).userId;
}

String _$driverApplicationFormHash() =>
    r'c34f5489d74e0c0751205f86842ed85997471290';

/// Notifier for the application form
///
/// Copied from [DriverApplicationForm].
@ProviderFor(DriverApplicationForm)
final driverApplicationFormProvider = AutoDisposeNotifierProvider<
    DriverApplicationForm, DriverApplicationFormState>.internal(
  DriverApplicationForm.new,
  name: r'driverApplicationFormProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$driverApplicationFormHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DriverApplicationForm
    = AutoDisposeNotifier<DriverApplicationFormState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
