// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rejection_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RejectionRequestDtoImpl _$$RejectionRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$RejectionRequestDtoImpl(
      orderId: json['orderId'] as String,
      driverId: json['driverId'] as String,
      driverName: json['driverName'] as String,
      reason: json['reason'] as String,
      adminDecision: $enumDecode(_$AdminDecisionEnumMap, json['adminDecision']),
      createdAt: _timestampFromJson(json['createdAt']),
      adminComment: json['adminComment'] as String?,
      updatedAt: _timestampFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$RejectionRequestDtoImplToJson(
        _$RejectionRequestDtoImpl instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'driverId': instance.driverId,
      'driverName': instance.driverName,
      'reason': instance.reason,
      'adminDecision': _$AdminDecisionEnumMap[instance.adminDecision]!,
      'createdAt': _timestampToJson(instance.createdAt),
      'adminComment': instance.adminComment,
      'updatedAt': _timestampToJson(instance.updatedAt),
    };

const _$AdminDecisionEnumMap = {
  AdminDecision.pending: 'pending',
  AdminDecision.approved: 'approved',
  AdminDecision.rejected: 'rejected',
};
