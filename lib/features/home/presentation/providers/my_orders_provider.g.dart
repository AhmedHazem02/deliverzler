// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myOrdersHash() => r'80eead87e50a51e98629114465930cca5f5838fe';

/// Provider for orders assigned to the current delivery user
/// Shows orders that are either on the way or delivered
///
/// Copied from [myOrders].
@ProviderFor(myOrders)
final myOrdersProvider = AutoDisposeStreamProvider<List<AppOrder>>.internal(
  myOrders,
  name: r'myOrdersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myOrdersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MyOrdersRef = AutoDisposeStreamProviderRef<List<AppOrder>>;
String _$filteredMyOrdersHash() => r'3e5657dda80f9d9845a1810ee96e749007596bd1';

/// Filtered my orders based on the selected filter with persistence
///
/// Copied from [filteredMyOrders].
@ProviderFor(filteredMyOrders)
final filteredMyOrdersProvider = AutoDisposeProvider<List<AppOrder>>.internal(
  filteredMyOrders,
  name: r'filteredMyOrdersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredMyOrdersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilteredMyOrdersRef = AutoDisposeProviderRef<List<AppOrder>>;
String _$myOrdersFilterStateHash() =>
    r'8e0ce949219b27cc59d8b4a189032bdf64cb3663';

/// See also [MyOrdersFilterState].
@ProviderFor(MyOrdersFilterState)
final myOrdersFilterStateProvider =
    AutoDisposeNotifierProvider<MyOrdersFilterState, MyOrdersFilter>.internal(
  MyOrdersFilterState.new,
  name: r'myOrdersFilterStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myOrdersFilterStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MyOrdersFilterState = AutoDisposeNotifier<MyOrdersFilter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
