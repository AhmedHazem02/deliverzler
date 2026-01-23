// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedOrderHash() => r'6f32a890077e74514e108bb80b92d8dfe589a6da';

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
String _$selectedOrderIdHash() => r'6edca62f55cbf992a7f1318ab89650ea4e57d284';

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
