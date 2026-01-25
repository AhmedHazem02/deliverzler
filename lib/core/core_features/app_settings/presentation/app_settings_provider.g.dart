// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appSettingsHash() => r'9744826e1917cb92da516f4e69700d8d6affd1f3';

/// Provides the current app settings.
///
/// This provider fetches settings on first access and caches them.
/// Use [appSettingsStreamProvider] for real-time updates.
///
/// Copied from [appSettings].
@ProviderFor(appSettings)
final appSettingsProvider = FutureProvider<AppSettings>.internal(
  appSettings,
  name: r'appSettingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppSettingsRef = FutureProviderRef<AppSettings>;
String _$appSettingsStreamHash() => r'cf7967e84134e8b38d6bbbc60062a42405a5dd7f';

/// Streams app settings changes in real-time.
///
/// Useful for components that need to react to settings changes
/// made from Admin Dashboard.
///
/// Copied from [appSettingsStream].
@ProviderFor(appSettingsStream)
final appSettingsStreamProvider = StreamProvider<AppSettings>.internal(
  appSettingsStream,
  name: r'appSettingsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appSettingsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppSettingsStreamRef = StreamProviderRef<AppSettings>;
String _$deliverySettingsHash() => r'7853fe370ad8b17eda92f6757355ee45ba9fe4b4';

/// Provides delivery settings directly for convenience.
///
/// Copied from [deliverySettings].
@ProviderFor(deliverySettings)
final deliverySettingsProvider =
    AutoDisposeFutureProvider<DeliverySettings>.internal(
  deliverySettings,
  name: r'deliverySettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deliverySettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DeliverySettingsRef = AutoDisposeFutureProviderRef<DeliverySettings>;
String _$generalSettingsHash() => r'd322a1388c52adf11111171d93bc83734411890e';

/// Provides general settings directly for convenience.
///
/// Copied from [generalSettings].
@ProviderFor(generalSettings)
final generalSettingsProvider =
    AutoDisposeFutureProvider<GeneralSettings>.internal(
  generalSettings,
  name: r'generalSettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$generalSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GeneralSettingsRef = AutoDisposeFutureProviderRef<GeneralSettings>;
String _$currencySymbolHash() => r'0b19f3804417c0d91ceb84428b0b4a12a8b43408';

/// Provides the currency symbol for formatting.
///
/// Copied from [currencySymbol].
@ProviderFor(currencySymbol)
final currencySymbolProvider = AutoDisposeFutureProvider<String>.internal(
  currencySymbol,
  name: r'currencySymbolProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currencySymbolHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrencySymbolRef = AutoDisposeFutureProviderRef<String>;
String _$baseDeliveryFeeHash() => r'c180312ae5a70fdc0f33e734fd051ea986fa8c3a';

/// Provides the base delivery fee.
///
/// Copied from [baseDeliveryFee].
@ProviderFor(baseDeliveryFee)
final baseDeliveryFeeProvider = AutoDisposeFutureProvider<double>.internal(
  baseDeliveryFee,
  name: r'baseDeliveryFeeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$baseDeliveryFeeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BaseDeliveryFeeRef = AutoDisposeFutureProviderRef<double>;
String _$feePerKilometerHash() => r'61823638bfd94fb4fb78cffdb48fc8d36be3fb80';

/// Provides the fee per kilometer.
///
/// Copied from [feePerKilometer].
@ProviderFor(feePerKilometer)
final feePerKilometerProvider = AutoDisposeFutureProvider<double>.internal(
  feePerKilometer,
  name: r'feePerKilometerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$feePerKilometerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FeePerKilometerRef = AutoDisposeFutureProviderRef<double>;
String _$estimatedDeliveryTimeHash() =>
    r'97be54388e26959c02bf2db94f6af131aad5b1e9';

/// Provides the estimated delivery time.
///
/// Copied from [estimatedDeliveryTime].
@ProviderFor(estimatedDeliveryTime)
final estimatedDeliveryTimeProvider = AutoDisposeFutureProvider<int>.internal(
  estimatedDeliveryTime,
  name: r'estimatedDeliveryTimeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$estimatedDeliveryTimeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EstimatedDeliveryTimeRef = AutoDisposeFutureProviderRef<int>;
String _$isMaintenanceModeHash() => r'21b0a473947dcd4c38bee2cb4e82ac96bd51314a';

/// Checks if app is in maintenance mode.
///
/// Copied from [isMaintenanceMode].
@ProviderFor(isMaintenanceMode)
final isMaintenanceModeProvider = AutoDisposeFutureProvider<bool>.internal(
  isMaintenanceMode,
  name: r'isMaintenanceModeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isMaintenanceModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsMaintenanceModeRef = AutoDisposeFutureProviderRef<bool>;
String _$calculateDeliveryFeeHash() =>
    r'727c2273a0d422414de06fff03d9851e8f3ecb10';

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

/// Calculates delivery fee for a given distance.
///
/// Copied from [calculateDeliveryFee].
@ProviderFor(calculateDeliveryFee)
const calculateDeliveryFeeProvider = CalculateDeliveryFeeFamily();

/// Calculates delivery fee for a given distance.
///
/// Copied from [calculateDeliveryFee].
class CalculateDeliveryFeeFamily extends Family<AsyncValue<double>> {
  /// Calculates delivery fee for a given distance.
  ///
  /// Copied from [calculateDeliveryFee].
  const CalculateDeliveryFeeFamily();

  /// Calculates delivery fee for a given distance.
  ///
  /// Copied from [calculateDeliveryFee].
  CalculateDeliveryFeeProvider call({
    required double distanceKm,
  }) {
    return CalculateDeliveryFeeProvider(
      distanceKm: distanceKm,
    );
  }

  @override
  CalculateDeliveryFeeProvider getProviderOverride(
    covariant CalculateDeliveryFeeProvider provider,
  ) {
    return call(
      distanceKm: provider.distanceKm,
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
  String? get name => r'calculateDeliveryFeeProvider';
}

/// Calculates delivery fee for a given distance.
///
/// Copied from [calculateDeliveryFee].
class CalculateDeliveryFeeProvider extends AutoDisposeFutureProvider<double> {
  /// Calculates delivery fee for a given distance.
  ///
  /// Copied from [calculateDeliveryFee].
  CalculateDeliveryFeeProvider({
    required double distanceKm,
  }) : this._internal(
          (ref) => calculateDeliveryFee(
            ref as CalculateDeliveryFeeRef,
            distanceKm: distanceKm,
          ),
          from: calculateDeliveryFeeProvider,
          name: r'calculateDeliveryFeeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$calculateDeliveryFeeHash,
          dependencies: CalculateDeliveryFeeFamily._dependencies,
          allTransitiveDependencies:
              CalculateDeliveryFeeFamily._allTransitiveDependencies,
          distanceKm: distanceKm,
        );

  CalculateDeliveryFeeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.distanceKm,
  }) : super.internal();

  final double distanceKm;

  @override
  Override overrideWith(
    FutureOr<double> Function(CalculateDeliveryFeeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CalculateDeliveryFeeProvider._internal(
        (ref) => create(ref as CalculateDeliveryFeeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        distanceKm: distanceKm,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _CalculateDeliveryFeeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CalculateDeliveryFeeProvider &&
        other.distanceKm == distanceKm;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, distanceKm.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CalculateDeliveryFeeRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `distanceKm` of this provider.
  double get distanceKm;
}

class _CalculateDeliveryFeeProviderElement
    extends AutoDisposeFutureProviderElement<double>
    with CalculateDeliveryFeeRef {
  _CalculateDeliveryFeeProviderElement(super.provider);

  @override
  double get distanceKm => (origin as CalculateDeliveryFeeProvider).distanceKm;
}

String _$isWithinDeliveryRadiusHash() =>
    r'6c8fab5e6dd89479277eafef68491b6c6c64a22a';

/// Checks if distance is within delivery radius.
///
/// Copied from [isWithinDeliveryRadius].
@ProviderFor(isWithinDeliveryRadius)
const isWithinDeliveryRadiusProvider = IsWithinDeliveryRadiusFamily();

/// Checks if distance is within delivery radius.
///
/// Copied from [isWithinDeliveryRadius].
class IsWithinDeliveryRadiusFamily extends Family<AsyncValue<bool>> {
  /// Checks if distance is within delivery radius.
  ///
  /// Copied from [isWithinDeliveryRadius].
  const IsWithinDeliveryRadiusFamily();

  /// Checks if distance is within delivery radius.
  ///
  /// Copied from [isWithinDeliveryRadius].
  IsWithinDeliveryRadiusProvider call({
    required double distanceKm,
  }) {
    return IsWithinDeliveryRadiusProvider(
      distanceKm: distanceKm,
    );
  }

  @override
  IsWithinDeliveryRadiusProvider getProviderOverride(
    covariant IsWithinDeliveryRadiusProvider provider,
  ) {
    return call(
      distanceKm: provider.distanceKm,
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
  String? get name => r'isWithinDeliveryRadiusProvider';
}

/// Checks if distance is within delivery radius.
///
/// Copied from [isWithinDeliveryRadius].
class IsWithinDeliveryRadiusProvider extends AutoDisposeFutureProvider<bool> {
  /// Checks if distance is within delivery radius.
  ///
  /// Copied from [isWithinDeliveryRadius].
  IsWithinDeliveryRadiusProvider({
    required double distanceKm,
  }) : this._internal(
          (ref) => isWithinDeliveryRadius(
            ref as IsWithinDeliveryRadiusRef,
            distanceKm: distanceKm,
          ),
          from: isWithinDeliveryRadiusProvider,
          name: r'isWithinDeliveryRadiusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isWithinDeliveryRadiusHash,
          dependencies: IsWithinDeliveryRadiusFamily._dependencies,
          allTransitiveDependencies:
              IsWithinDeliveryRadiusFamily._allTransitiveDependencies,
          distanceKm: distanceKm,
        );

  IsWithinDeliveryRadiusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.distanceKm,
  }) : super.internal();

  final double distanceKm;

  @override
  Override overrideWith(
    FutureOr<bool> Function(IsWithinDeliveryRadiusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsWithinDeliveryRadiusProvider._internal(
        (ref) => create(ref as IsWithinDeliveryRadiusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        distanceKm: distanceKm,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _IsWithinDeliveryRadiusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsWithinDeliveryRadiusProvider &&
        other.distanceKm == distanceKm;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, distanceKm.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IsWithinDeliveryRadiusRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `distanceKm` of this provider.
  double get distanceKm;
}

class _IsWithinDeliveryRadiusProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with IsWithinDeliveryRadiusRef {
  _IsWithinDeliveryRadiusProviderElement(super.provider);

  @override
  double get distanceKm =>
      (origin as IsWithinDeliveryRadiusProvider).distanceKm;
}

String _$refreshAppSettingsHash() =>
    r'779050255d77df187454eed029613b50dbb046d5';

/// Provider for refreshing settings manually.
///
/// Copied from [refreshAppSettings].
@ProviderFor(refreshAppSettings)
final refreshAppSettingsProvider =
    AutoDisposeFutureProvider<AppSettings>.internal(
  refreshAppSettings,
  name: r'refreshAppSettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$refreshAppSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RefreshAppSettingsRef = AutoDisposeFutureProviderRef<AppSettings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
