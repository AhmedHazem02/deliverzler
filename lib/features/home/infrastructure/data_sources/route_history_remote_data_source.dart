import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/infrastructure/network/main_api/api_callers/firebase_firestore_facade.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/route_point.dart';

part 'route_history_remote_data_source.g.dart';

@Riverpod(keepAlive: true)
RouteHistoryRemoteDataSource routeHistoryRemoteDataSource(Ref ref) {
  return RouteHistoryRemoteDataSource(
    firebaseFirestoreFacade: ref.watch(firebaseFirestoreFacadeProvider),
  );
}

class RouteHistoryRemoteDataSource {
  RouteHistoryRemoteDataSource({
    required this.firebaseFirestoreFacade,
  });

  final FirebaseFirestoreFacade firebaseFirestoreFacade;

  /// Adds a route point to the order's route history sub-collection
  /// Called every 10-15 seconds during active delivery
  Future<void> addRoutePoint({
    required String orderId,
    required RoutePoint routePoint,
  }) async {
    try {
      // Use Firebase directly to add to sub-collection
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .collection('route_history')
          .add(routePoint.toJson());
    } catch (e) {
      // Log error but don't throw - route history is not critical for delivery
      print('⚠️ Failed to add route point: $e');
    }
  }

  /// Retrieves route history for an order
  /// Useful for admin dashboard to view delivery path
  Future<List<RoutePoint>> getRouteHistory({
    required String orderId,
  }) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .collection('route_history')
          .orderBy('timestamp', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => RoutePoint.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('⚠️ Failed to get route history: $e');
      return [];
    }
  }

  /// Clears route history for an order
  /// Can be called after delivery completion to reduce storage
  Future<void> clearRouteHistory({
    required String orderId,
  }) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .collection('route_history')
          .get();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print('⚠️ Failed to clear route history: $e');
    }
  }
}
