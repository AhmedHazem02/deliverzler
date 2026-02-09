// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_route_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$routeHistoryRemoteDataSourceHash() =>
    r'8eed1a3f8cab891c0dfb994e5dd95dac82db5975';

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
String _$saveRouteHistoryHash() => r'f4de442689c40b3bb1623020c428f25d071db5c7';

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
