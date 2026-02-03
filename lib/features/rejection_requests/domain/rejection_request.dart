import 'package:freezed_annotation/freezed_annotation.dart';

import '../infrastructure/dtos/rejection_request_dto.dart';

part 'rejection_request.freezed.dart';

/// Rejection request entity.
///
/// Represents a driver's request to reject an assigned order.
/// The admin can approve or refuse the request.
@freezed
class RejectionRequest with _$RejectionRequest {
  const factory RejectionRequest({
    required String requestId,
    required String orderId,
    required String driverId,
    required String driverName,
    required String reason,
    required AdminDecision adminDecision,
    String? adminComment,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _RejectionRequest;

  const RejectionRequest._();
}
