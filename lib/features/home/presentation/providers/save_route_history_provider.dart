import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/infrastructure/network/main_api/api_callers/firebase_firestore_facade.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/route_point.dart';
import '../../infrastructure/data_sources/route_history_remote_data_source.dart';
import 'location_stream_provider.dart';
import 'my_delivering_orders_provider.dart';

part 'save_route_history_provider.g.dart';

/// Provider for RouteHistoryRemoteDataSource
@Riverpod(keepAlive: true)
RouteHistoryRemoteDataSource routeHistoryRemoteDataSource(Ref ref) {
  final firebaseFirestoreFacade = ref.watch(firebaseFirestoreFacadeProvider);
  return RouteHistoryRemoteDataSource(
    firebaseFirestoreFacade: firebaseFirestoreFacade,
  );
}

/// Saves route history points every 10-15 seconds
/// This creates a track history for dispute resolution and performance analysis
@riverpod
class SaveRouteHistory extends _$SaveRouteHistory {
  DateTime? _lastSaveTime;
  Position? _lastSavedPosition;

  // Save every 15 seconds OR every 100 meters, whichever comes first
  static const saveDurationThreshold = Duration(seconds: 15);
  static const saveDistanceThreshold = 100.0; // meters

  @override
  Stream<void> build() async* {
    final locationStream = ref.watch(locationStreamProvider.stream);

    await for (final position in locationStream) {
      final myDeliveryOrders = ref.read(myDeliveringOrdersProvider);

      // Only save if there are active deliveries
      if (myDeliveryOrders.isEmpty) continue;

      // Check if we should save based on time or distance
      if (_shouldSavePoint(position)) {
        await _savePointForAllOrders(myDeliveryOrders, position);
        _lastSaveTime = DateTime.now();
        _lastSavedPosition = position;
      }

      yield null;
    }
  }

  bool _shouldSavePoint(Position position) {
    // First point - always save
    if (_lastSaveTime == null || _lastSavedPosition == null) {
      return true;
    }

    // Time-based: Save every 15 seconds
    final timeSinceLastSave = DateTime.now().difference(_lastSaveTime!);
    if (timeSinceLastSave >= saveDurationThreshold) {
      return true;
    }

    // Distance-based: Save every 100 meters
    final distance = Geolocator.distanceBetween(
      _lastSavedPosition!.latitude,
      _lastSavedPosition!.longitude,
      position.latitude,
      position.longitude,
    );
    if (distance >= saveDistanceThreshold) {
      return true;
    }

    return false;
  }

  Future<void> _savePointForAllOrders(
    List myDeliveryOrders,
    Position position,
  ) async {
    final routePoint = RoutePoint(
      geoPoint: GeoPoint(position.latitude, position.longitude),
      heading: position.heading,
      speed: position.speed,
      accuracy: position.accuracy,
      timestamp: position.timestamp.millisecondsSinceEpoch,
      isMocked: position.isMocked,
    );

    final dataSource = ref.read(routeHistoryRemoteDataSourceProvider);
    final futures = <Future<void>>[];

    for (final order in myDeliveryOrders) {
      futures.add(
        dataSource.addRoutePoint(
          orderId: order.id,
          routePoint: routePoint,
        ),
      );
    }

    // Save all in parallel, but catch errors to prevent blocking location updates
    await Future.wait(
      futures,
      eagerError: false,
    ).catchError((error) {
      // Log error but don't throw - route history is not critical for delivery
      print('⚠️ Failed to save route history: $error');
    });
  }
}
