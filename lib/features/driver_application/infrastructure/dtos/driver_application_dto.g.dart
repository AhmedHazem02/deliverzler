// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_application_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DriverApplicationDtoImpl _$$DriverApplicationDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$DriverApplicationDtoImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      status: json['status'] as String,
      type: json['type'] as String? ?? 'driver',
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      idNumber: json['idNumber'] as String,
      licenseNumber: json['licenseNumber'] as String,
      licenseExpiryDate: (json['licenseExpiryDate'] as num).toInt(),
      vehicleType: json['vehicleType'] as String,
      vehiclePlate: json['vehiclePlate'] as String,
      photoUrl: json['photoUrl'] as String?,
      idDocumentUrl: json['idDocumentUrl'] as String?,
      licenseUrl: json['licenseUrl'] as String?,
      vehicleRegistrationUrl: json['vehicleRegistrationUrl'] as String?,
      vehicleInsuranceUrl: json['vehicleInsuranceUrl'] as String?,
      createdAt: (json['createdAt'] as num).toInt(),
      reviewedAt: (json['reviewedAt'] as num?)?.toInt(),
      reviewedBy: json['reviewedBy'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$DriverApplicationDtoImplToJson(
        _$DriverApplicationDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'status': instance.status,
      'type': instance.type,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'idNumber': instance.idNumber,
      'licenseNumber': instance.licenseNumber,
      'licenseExpiryDate': instance.licenseExpiryDate,
      'vehicleType': instance.vehicleType,
      'vehiclePlate': instance.vehiclePlate,
      'photoUrl': instance.photoUrl,
      'idDocumentUrl': instance.idDocumentUrl,
      'licenseUrl': instance.licenseUrl,
      'vehicleRegistrationUrl': instance.vehicleRegistrationUrl,
      'vehicleInsuranceUrl': instance.vehicleInsuranceUrl,
      'createdAt': instance.createdAt,
      'reviewedAt': instance.reviewedAt,
      'reviewedBy': instance.reviewedBy,
      'rejectionReason': instance.rejectionReason,
      'notes': instance.notes,
    };
