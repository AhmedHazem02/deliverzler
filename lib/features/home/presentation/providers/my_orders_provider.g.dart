// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myOrdersHash() => r'my_orders_provider_hash';

/// Provider for orders assigned to the current delivery user
/// Shows orders that are either on the way or delivered
///
/// See also [myOrders].
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

String _$myOrdersFilterStateHash() => r'my_orders_filter_state_hash';

/// Filter for my orders - all, on the way, or delivered
///
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

String _$filteredMyOrdersHash() => r'filtered_my_orders_hash';

/// Filtered my orders based on the selected filter
///
/// See also [filteredMyOrders].
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
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
