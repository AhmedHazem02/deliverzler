import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/infrastructure/error/app_exception.dart';
import '../../../../core/infrastructure/network/main_api/api_callers/firebase_firestore_facade.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';

part 'driver_orders_counter_repo.g.dart';

@Riverpod(keepAlive: true)
DriverOrdersCounterRepo driverOrdersCounterRepo(Ref ref) {
  return DriverOrdersCounterRepo(
    ref,
    firebaseFirestore: ref.watch(firebaseFirestoreFacadeProvider),
  );
}

/// Repository for managing driver's current orders count with high precision.
///
/// Critical operations that update currentOrdersCount:
/// 1. Order assigned to driver: +1
/// 2. Order delivered/cancelled: -1
/// 3. Admin approves excuse (removes driver): -1
///
/// Uses Firestore Transactions to prevent race conditions.
class DriverOrdersCounterRepo {
  DriverOrdersCounterRepo(
    this.ref, {
    required this.firebaseFirestore,
  });

  final Ref ref;
  final FirebaseFirestoreFacade firebaseFirestore;

  /// Increment driver's current orders count (when order is assigned).
  Future<void> incrementOrdersCount(String driverId) async {
    try {
      final db = FirebaseFirestore.instance;
      final driverRef = db.collection('users').doc(driverId);

      await db.runTransaction((transaction) async {
        final driverDoc = await transaction.get(driverRef);

        if (!driverDoc.exists) {
          throw const ServerException(
            type: ServerExceptionType.notFound,
            message: 'Driver not found',
          );
        }

        final currentCount =
            (driverDoc.data()?['currentOrdersCount'] as int?) ?? 0;

        transaction.update(driverRef, {
          'currentOrdersCount': currentCount + 1,
        });
      });
    } catch (e) {
      throw ServerException(
        type: ServerExceptionType.general,
        message: 'Failed to increment orders count: $e',
      );
    }
  }

  /// Decrement driver's current orders count (when order is completed/cancelled).
  Future<void> decrementOrdersCount(String driverId) async {
    try {
      final db = FirebaseFirestore.instance;
      final driverRef = db.collection('users').doc(driverId);

      await db.runTransaction((transaction) async {
        final driverDoc = await transaction.get(driverRef);

        if (!driverDoc.exists) {
          throw const ServerException(
            type: ServerExceptionType.notFound,
            message: 'Driver not found',
          );
        }

        final currentCount =
            (driverDoc.data()?['currentOrdersCount'] as int?) ?? 0;

        // Prevent negative values
        final newCount = currentCount > 0 ? currentCount - 1 : 0;

        transaction.update(driverRef, {
          'currentOrdersCount': newCount,
        });
      });
    } catch (e) {
      throw ServerException(
        type: ServerExceptionType.general,
        message: 'Failed to decrement orders count: $e',
      );
    }
  }

  /// Get current orders count for a driver.
  Future<int> getCurrentOrdersCount(String driverId) async {
    try {
      final response = await firebaseFirestore.getData(
        path: 'users/$driverId',
      );

      if (response.data() != null) {
        final data = response.data() as Map<String, dynamic>?;
        return (data?['currentOrdersCount'] as int?) ?? 0;
      } else {
        throw const ServerException(
          type: ServerExceptionType.notFound,
          message: 'Driver not found',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Reset orders count to zero (for cleanup/maintenance).
  Future<void> resetOrdersCount(String driverId) async {
    try {
      await firebaseFirestore.updateData(
        path: 'users/$driverId',
        data: {'currentOrdersCount': 0},
      );
    } catch (e) {
      throw ServerException(
        type: ServerExceptionType.general,
        message: 'Failed to reset orders count: $e',
      );
    }
  }
}
