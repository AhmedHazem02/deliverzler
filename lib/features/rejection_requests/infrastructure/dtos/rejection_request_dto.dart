import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/rejection_request.dart';

part 'rejection_request_dto.freezed.dart';
part 'rejection_request_dto.g.dart';

// Timestamp converter functions (must be top-level)
DateTime _timestampFromJson(dynamic timestamp) {
  if (timestamp == null) return DateTime.now();
  if (timestamp is int) return DateTime.fromMillisecondsSinceEpoch(timestamp);
  return (timestamp as Timestamp).toDate();
}

dynamic _timestampToJson(DateTime? dateTime) {
  return dateTime != null ? Timestamp.fromDate(dateTime) : null;
}

/// Admin decision on rejection request.
@JsonEnum(valueField: 'jsonValue')
enum AdminDecision {
  pending('pending'),
  approved('approved'),
  rejected('rejected');

  const AdminDecision(this.jsonValue);

  final String jsonValue;
}

/// Rejection request DTO for data layer.
@freezed
class RejectionRequestDto with _$RejectionRequestDto {
  const factory RejectionRequestDto({
    required String orderId,
    required String driverId,
    required String driverName,
    required String reason,
    required AdminDecision adminDecision,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime createdAt,
    String? adminComment,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false) String? id,
  }) = _RejectionRequestDto;

  factory RejectionRequestDto.fromDomain(RejectionRequest request) {
    return RejectionRequestDto(
      id: request.requestId,
      orderId: request.orderId,
      driverId: request.driverId,
      driverName: request.driverName,
      reason: request.reason,
      adminDecision: request.adminDecision,
      adminComment: request.adminComment,
      createdAt: request.createdAt,
      updatedAt: request.updatedAt,
    );
  }

  const RejectionRequestDto._();

  factory RejectionRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RejectionRequestDtoFromJson(json);

  factory RejectionRequestDto.fromFirestore(DocumentSnapshot document) {
    return RejectionRequestDto.fromJson(
      document.data()! as Map<String, dynamic>,
    ).copyWith(id: document.id);
  }

  static List<RejectionRequestDto> parseListOfDocument(
    List<QueryDocumentSnapshot> documents,
  ) {
    return List<RejectionRequestDto>.from(
      documents.map(RejectionRequestDto.fromFirestore),
    );
  }

  RejectionRequest toDomain() {
    return RejectionRequest(
      requestId: id ?? '',
      orderId: orderId,
      driverId: driverId,
      driverName: driverName,
      reason: reason,
      adminDecision: adminDecision,
      adminComment: adminComment,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
