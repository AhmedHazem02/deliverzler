import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/infrastructure/error/app_exception.dart';
import '../../../../core/infrastructure/network/main_api/api_callers/firebase_firestore_facade.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../home/domain/value_objects.dart';
import '../../../home/infrastructure/repos/driver_orders_counter_repo.dart';
import '../data_sources/rejection_requests_remote_data_source.dart';
import '../dtos/rejection_request_dto.dart';

part 'rejection_handler_repo.g.dart';

@Riverpod(keepAlive: true)
RejectionHandlerRepo rejectionHandlerRepo(Ref ref) {
  return RejectionHandlerRepo(
    ref,
    dataSource: ref.watch(rejectionRequestsRemoteDataSourceProvider),
    firebaseFirestore: ref.watch(firebaseFirestoreFacadeProvider),
    ordersCounterRepo: ref.watch(driverOrdersCounterRepoProvider),
  );
}

/// Repository for handling admin decisions on rejection requests.
///
/// Uses Firestore Transactions to ensure data consistency when:
/// - Approving excuse: Update order, increment driver rejection counter, mark request as approved
/// - Rejecting excuse: Mark request as rejected with admin comment
class RejectionHandlerRepo {
  RejectionHandlerRepo(
    this.ref, {
    required this.dataSource,
    required this.firebaseFirestore,
    required this.ordersCounterRepo,
  });

  final Ref ref;
  final RejectionRequestsRemoteDataSource dataSource;
  final FirebaseFirestoreFacade firebaseFirestore;
  final DriverOrdersCounterRepo ordersCounterRepo;

  /// Approve driver's excuse - Remove driver from order and increment rejection counter.
  ///
  /// Transaction ensures:
  /// 1. Order's driverId is cleared and status reverts to pending
  /// 2. Order's rejectionStatus is set to adminApproved
  /// 3. Driver's rejectionsCounter is incremented
  /// 4. Driver's currentOrdersCount is decremented (order removed)
  /// 5. Rejection request is marked as approved
  Future<void> approveExcuse({
    required String requestId,
    required String orderId,
    required String driverId,
    String? adminComment,
  }) async {
    try {
      final db = FirebaseFirestore.instance;

      await db.runTransaction((transaction) async {
        // References
        final orderRef = db.collection('orders').doc(orderId);
        final driverRef = db.collection('users').doc(driverId);
        final requestRef = db.collection('rejection_requests').doc(requestId);

        // Read current values
        final orderDoc = await transaction.get(orderRef);
        final driverDoc = await transaction.get(driverRef);

        if (!orderDoc.exists) {
          throw const ServerException(
            type: ServerExceptionType.notFound,
            message: 'Order not found',
          );
        }

        if (!driverDoc.exists) {
          throw const ServerException(
            type: ServerExceptionType.notFound,
            message: 'Driver not found',
          );
        }

        // Update order: Remove driver, revert to pending
        transaction.update(orderRef, {
          'deliveryId': null,
          'deliveryStatus': DeliveryStatus.pending.jsonValue,
          'rejectionStatus': RejectionStatus.adminApproved.jsonValue,
        });

        // Increment driver's rejection counter & decrement current orders count
        final currentRejectionsCounter =
            (driverDoc.data()?['rejectionsCounter'] as int?) ?? 0;
        final currentOrdersCount =
            (driverDoc.data()?['currentOrdersCount'] as int?) ?? 0;

        transaction.update(driverRef, {
          'rejectionsCounter': currentRejectionsCounter + 1,
          'currentOrdersCount':
              currentOrdersCount > 0 ? currentOrdersCount - 1 : 0,
        });

        // Mark rejection request as approved
        transaction.update(requestRef, {
          'adminDecision': AdminDecision.approved.jsonValue,
          if (adminComment != null) 'adminComment': adminComment,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      throw ServerException(
        type: ServerExceptionType.general,
        message: 'Failed to approve excuse: $e',
      );
    }
  }

  /// Reject driver's excuse - Driver must complete the order.
  ///
  /// Updates:
  /// 1. Rejection request is marked as rejected with admin comment
  /// 2. Order's rejectionStatus is set to adminRefused
  Future<void> rejectExcuse({
    required String requestId,
    required String orderId,
    String? adminComment,
  }) async {
    try {
      final db = FirebaseFirestore.instance;

      await db.runTransaction((transaction) async {
        // References
        final orderRef = db.collection('orders').doc(orderId);
        final requestRef = db.collection('rejection_requests').doc(requestId);

        // Read order to ensure it exists
        final orderDoc = await transaction.get(orderRef);
        if (!orderDoc.exists) {
          throw const ServerException(
            type: ServerExceptionType.notFound,
            message: 'Order not found',
          );
        }

        // Update order: Mark rejection as refused
        transaction.update(orderRef, {
          'rejectionStatus': RejectionStatus.adminRefused.jsonValue,
        });

        // Mark rejection request as rejected
        transaction.update(requestRef, {
          'adminDecision': AdminDecision.rejected.jsonValue,
          if (adminComment != null) 'adminComment': adminComment,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      throw ServerException(
        type: ServerExceptionType.general,
        message: 'Failed to reject excuse: $e',
      );
    }
  }
}
