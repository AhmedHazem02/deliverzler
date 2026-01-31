// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_route_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$routeHistoryRemoteDataSourceHash() =>
    r'c81a7bc55a5967c6b46e7f7628aa33baaa0c109d';

/// Provider for RouteHistoryRemoteDataSource
///
/// Copied from [routeHistoryRemoteDataSource].
@ProviderFor(routeHistoryRemoteDataSource)
final routeHistoryRemoteDataSourceProvider =
    Provider<RouteHistoryRemoteDataSource>.internal(
  routeHistoryRemoteDataSource,
  name: r'routeHistoryRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$routeHistoryRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RouteHistoryRemoteDataSourceRef
    = ProviderRef<RouteHistoryRemoteDataSource>;
String _$saveRouteHistoryHash() => r'd9d347b7fd45dd97e3807b9e1da129ff1b199f10';

/// Saves route history points every 10-15 seconds
/// This creates a track history for dispute resolution and performance analysis
///
/// Copied from [SaveRouteHistory].
@ProviderFor(SaveRouteHistory)
final saveRouteHistoryProvider =
    AutoDisposeStreamNotifierProvider<SaveRouteHistory, void>.internal(
  SaveRouteHistory.new,
  name: r'saveRouteHistoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$saveRouteHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SaveRouteHistory = AutoDisposeStreamNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
