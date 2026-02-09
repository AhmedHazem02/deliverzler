// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_items_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orderItemsHash() => r'0236322165c07721e4d5cc2024d53c29b867a21f';

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

/// Provider to fetch order items for a specific order
///
/// Copied from [orderItems].
@ProviderFor(orderItems)
const orderItemsProvider = OrderItemsFamily();

/// Provider to fetch order items for a specific order
///
/// Copied from [orderItems].
class OrderItemsFamily extends Family<AsyncValue<List<OrderItem>>> {
  /// Provider to fetch order items for a specific order
  ///
  /// Copied from [orderItems].
  const OrderItemsFamily();

  /// Provider to fetch order items for a specific order
  ///
  /// Copied from [orderItems].
  OrderItemsProvider call(
    String orderId,
  ) {
    return OrderItemsProvider(
      orderId,
    );
  }

  @override
  OrderItemsProvider getProviderOverride(
    covariant OrderItemsProvider provider,
  ) {
    return call(
      provider.orderId,
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
  String? get name => r'orderItemsProvider';
}

/// Provider to fetch order items for a specific order
///
/// Copied from [orderItems].
class OrderItemsProvider extends AutoDisposeFutureProvider<List<OrderItem>> {
  /// Provider to fetch order items for a specific order
  ///
  /// Copied from [orderItems].
  OrderItemsProvider(
    String orderId,
  ) : this._internal(
          (ref) => orderItems(
            ref as OrderItemsRef,
            orderId,
          ),
          from: orderItemsProvider,
          name: r'orderItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$orderItemsHash,
          dependencies: OrderItemsFamily._dependencies,
          allTransitiveDependencies:
              OrderItemsFamily._allTransitiveDependencies,
          orderId: orderId,
        );

  OrderItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderId,
  }) : super.internal();

  final String orderId;

  @override
  Override overrideWith(
    FutureOr<List<OrderItem>> Function(OrderItemsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OrderItemsProvider._internal(
        (ref) => create(ref as OrderItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderId: orderId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<OrderItem>> createElement() {
    return _OrderItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderItemsProvider && other.orderId == orderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin OrderItemsRef on AutoDisposeFutureProviderRef<List<OrderItem>> {
  /// The parameter `orderId` of this provider.
  String get orderId;
}

class _OrderItemsProviderElement
    extends AutoDisposeFutureProviderElement<List<OrderItem>>
    with OrderItemsRef {
  _OrderItemsProviderElement(super.provider);

  @override
  String get orderId => (origin as OrderItemsProvider).orderId;
}

String _$orderItemsStreamHash() => r'e6727ef91cf6dc823b00d105cdf2d07c18a15fb5';

/// Stream provider for real-time order items updates
///
/// Copied from [orderItemsStream].
@ProviderFor(orderItemsStream)
const orderItemsStreamProvider = OrderItemsStreamFamily();

/// Stream provider for real-time order items updates
///
/// Copied from [orderItemsStream].
class OrderItemsStreamFamily extends Family<AsyncValue<List<OrderItem>>> {
  /// Stream provider for real-time order items updates
  ///
  /// Copied from [orderItemsStream].
  const OrderItemsStreamFamily();

  /// Stream provider for real-time order items updates
  ///
  /// Copied from [orderItemsStream].
  OrderItemsStreamProvider call(
    String orderId,
  ) {
    return OrderItemsStreamProvider(
      orderId,
    );
  }

  @override
  OrderItemsStreamProvider getProviderOverride(
    covariant OrderItemsStreamProvider provider,
  ) {
    return call(
      provider.orderId,
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
  String? get name => r'orderItemsStreamProvider';
}

/// Stream provider for real-time order items updates
///
/// Copied from [orderItemsStream].
class OrderItemsStreamProvider
    extends AutoDisposeStreamProvider<List<OrderItem>> {
  /// Stream provider for real-time order items updates
  ///
  /// Copied from [orderItemsStream].
  OrderItemsStreamProvider(
    String orderId,
  ) : this._internal(
          (ref) => orderItemsStream(
            ref as OrderItemsStreamRef,
            orderId,
          ),
          from: orderItemsStreamProvider,
          name: r'orderItemsStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$orderItemsStreamHash,
          dependencies: OrderItemsStreamFamily._dependencies,
          allTransitiveDependencies:
              OrderItemsStreamFamily._allTransitiveDependencies,
          orderId: orderId,
        );

  OrderItemsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderId,
  }) : super.internal();

  final String orderId;

  @override
  Override overrideWith(
    Stream<List<OrderItem>> Function(OrderItemsStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OrderItemsStreamProvider._internal(
        (ref) => create(ref as OrderItemsStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderId: orderId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<OrderItem>> createElement() {
    return _OrderItemsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderItemsStreamProvider && other.orderId == orderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin OrderItemsStreamRef on AutoDisposeStreamProviderRef<List<OrderItem>> {
  /// The parameter `orderId` of this provider.
  String get orderId;
}

class _OrderItemsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<OrderItem>>
    with OrderItemsStreamRef {
  _OrderItemsStreamProviderElement(super.provider);

  @override
  String get orderId => (origin as OrderItemsStreamProvider).orderId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
