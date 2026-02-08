// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedOrderHash() => r'1be5af04f916d765d0f3272cc4522bdee2fea6e2';

/// See also [selectedOrder].
@ProviderFor(selectedOrder)
final selectedOrderProvider = AutoDisposeProvider<Option<AppOrder>>.internal(
  selectedOrder,
  name: r'selectedOrderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedOrderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SelectedOrderRef = AutoDisposeProviderRef<Option<AppOrder>>;
String _$selectedOrderIdHash() => r'7eef49bbc7bf7d02e02e1ea5c8729e9c7d4e3e1d';

/// See also [SelectedOrderId].
@ProviderFor(SelectedOrderId)
final selectedOrderIdProvider =
    AutoDisposeNotifierProvider<SelectedOrderId, Option<String>>.internal(
  SelectedOrderId.new,
  name: r'selectedOrderIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedOrderIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedOrderId = AutoDisposeNotifier<Option<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
