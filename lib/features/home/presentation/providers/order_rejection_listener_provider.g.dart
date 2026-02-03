// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_rejection_listener_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orderRejectionListenerHash() =>
    r'fcd016d5c888ad485c4eac97e005b0fdc960154e';

/// Listens to order rejection status changes for current driver's orders
/// Shows notification when admin approves or rejects driver's excuse
///
/// Copied from [OrderRejectionListener].
@ProviderFor(OrderRejectionListener)
final orderRejectionListenerProvider =
    NotifierProvider<OrderRejectionListener, void>.internal(
  OrderRejectionListener.new,
  name: r'orderRejectionListenerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$orderRejectionListenerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OrderRejectionListener = Notifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
