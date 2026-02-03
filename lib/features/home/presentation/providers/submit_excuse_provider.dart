import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../rejection_requests/infrastructure/data_sources/rejection_requests_remote_data_source.dart';
import '../../../rejection_requests/infrastructure/dtos/rejection_request_dto.dart';
import '../../domain/order.dart';

part 'submit_excuse_provider.g.dart';

@riverpod
class SubmitExcuseController extends _$SubmitExcuseController {
  @override
  FutureOr<void> build() {}

  Future<void> submitExcuse({
    required AppOrder order,
    required String reason,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(currentUserProvider);
      final dataSource = ref.read(rejectionRequestsRemoteDataSourceProvider);

      // Create rejection request
      final rejectionRequest = RejectionRequestDto(
        orderId: order.id,
        driverId: user.id,
        driverName: user.name ?? 'Driver',
        reason: reason,
        adminDecision: AdminDecision.pending,
        adminComment: null,
        createdAt: DateTime.now(),
        updatedAt: null,
      );

      // Submit to Firestore
      await dataSource.createRejectionRequest(rejectionRequest);

      // Update order rejectionStatus to 'requested'
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(order.id)
          .update({
        'rejectionStatus': 'requested',
      });
    });
  }
}
