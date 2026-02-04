// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_review_orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pendingReviewOrdersHash() =>
    r'b2719fe429e867617a25bac036a7f485e87bebcf';

/// Provider that filters orders pending admin review from the upcoming orders
/// This helps display an indicator in the home screen showing how many orders
/// are waiting for admin decision on driver's excuse
///
/// Copied from [pendingReviewOrders].
@ProviderFor(pendingReviewOrders)
final pendingReviewOrdersProvider =
    AutoDisposeProvider<List<AppOrder>>.internal(
  pendingReviewOrders,
  name: r'pendingReviewOrdersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingReviewOrdersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PendingReviewOrdersRef = AutoDisposeProviderRef<List<AppOrder>>;
String _$pendingReviewCountHash() =>
    r'767036fefda7d6d320928c05ab45763df2f58119';

/// Provider that returns count of orders pending admin review
///
/// Copied from [pendingReviewCount].
@ProviderFor(pendingReviewCount)
final pendingReviewCountProvider = AutoDisposeProvider<int>.internal(
  pendingReviewCount,
  name: r'pendingReviewCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingReviewCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PendingReviewCountRef = AutoDisposeProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
