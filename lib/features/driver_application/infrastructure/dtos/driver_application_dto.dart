import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/driver_application.dart';

part 'driver_application_dto.freezed.dart';
part 'driver_application_dto.g.dart';

/// DTO for DriverApplication with Firestore serialization.
///
/// Field names match Admin Dashboard's DriverOnboardingEntity.
@freezed
class DriverApplicationDto with _$DriverApplicationDto {
  const factory DriverApplicationDto({
    /// Application ID (document ID).
    required String id,

    /// User ID from Firebase Auth.
    required String userId,

    /// Application status string.
    required String status,

    /// Driver's full name.
    required String name,

    /// Driver's email.
    required String email,

    /// Driver's phone number.
    required String phone,

    /// National ID number.
    required String idNumber,

    /// Driver's license number.
    required String licenseNumber,

    /// License expiry date as timestamp.
    required int licenseExpiryDate,

    /// Type of vehicle.
    required String vehicleType,

    /// Vehicle plate number.
    required String vehiclePlate,

    /// Application submission date as timestamp.
    required int createdAt,

    /// Type indicator for Admin Dashboard.
    @Default('driver') String type,

    /// Profile photo URL.
    String? photoUrl,

    /// National ID document URL.
    String? idDocumentUrl,

    /// Driver's license document URL.
    String? licenseUrl,

    /// Vehicle registration document URL.
    String? vehicleRegistrationUrl,

    /// Vehicle insurance document URL.
    String? vehicleInsuranceUrl,

    /// Date when application was reviewed.
    int? reviewedAt,

    /// ID of admin who reviewed.
    String? reviewedBy,

    /// Reason for rejection.
    String? rejectionReason,

    /// Additional notes.
    String? notes,
  }) = _DriverApplicationDto;

  const DriverApplicationDto._();

  /// Creates from JSON (Firestore document).
  factory DriverApplicationDto.fromJson(Map<String, dynamic> json) =>
      _$DriverApplicationDtoFromJson(json);

  /// Creates from Firestore document snapshot.
  ///
  /// Handles both int (milliseconds) and Firestore Timestamp for date fields.
  factory DriverApplicationDto.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    // Helper to parse timestamps from various formats
    int parseTimestamp(dynamic value) {
      if (value == null) return DateTime.now().millisecondsSinceEpoch;
      if (value is int) return value;
      if (value is Timestamp) return value.millisecondsSinceEpoch;
      if (value is DateTime) return value.millisecondsSinceEpoch;
      if (value is String) {
        return DateTime.tryParse(value)?.millisecondsSinceEpoch ??
            DateTime.now().millisecondsSinceEpoch;
      }
      return DateTime.now().millisecondsSinceEpoch;
    }

    int? parseNullableTimestamp(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is Timestamp) return value.millisecondsSinceEpoch;
      if (value is DateTime) return value.millisecondsSinceEpoch;
      if (value is String) {
        return DateTime.tryParse(value)?.millisecondsSinceEpoch;
      }
      return null;
    }

    final rawStatus = data['status'] as String?;
    debugPrint('🔍 [DriverApplicationDto] Reading Doc ID: ${doc.id}');
    debugPrint('🔍 [DriverApplicationDto] Raw Status: "$rawStatus"');

    return DriverApplicationDto(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      status: rawStatus ?? 'pending',
      type: data['type'] as String? ?? 'driver',
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      idNumber: data['idNumber'] as String? ?? '',
      licenseNumber: data['licenseNumber'] as String? ?? '',
      licenseExpiryDate: parseTimestamp(data['licenseExpiryDate']),
      vehicleType: data['vehicleType'] as String? ?? 'car',
      vehiclePlate: data['vehiclePlate'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
      idDocumentUrl: data['idDocumentUrl'] as String?,
      licenseUrl: data['licenseUrl'] as String?,
      vehicleRegistrationUrl: data['vehicleRegistrationUrl'] as String?,
      vehicleInsuranceUrl: data['vehicleInsuranceUrl'] as String?,
      createdAt: parseTimestamp(data['createdAt']),
      reviewedAt: parseNullableTimestamp(data['reviewedAt']),
      reviewedBy: data['reviewedBy'] as String?,
      rejectionReason: data['rejectionReason'] as String?,
      notes: data['notes'] as String?,
    );
  }

  /// Creates from domain entity.
  factory DriverApplicationDto.fromDomain(DriverApplication app) {
    return DriverApplicationDto(
      id: app.id,
      userId: app.userId,
      status: app.status.name,
      name: app.name,
      email: app.email,
      phone: app.phone,
      idNumber: app.idNumber,
      licenseNumber: app.licenseNumber,
      licenseExpiryDate: app.licenseExpiryDate.millisecondsSinceEpoch,
      vehicleType: app.vehicleType.name,
      vehiclePlate: app.vehiclePlate,
      photoUrl: app.photoUrl,
      idDocumentUrl: app.idDocumentUrl,
      licenseUrl: app.licenseUrl,
      vehicleRegistrationUrl: app.vehicleRegistrationUrl,
      vehicleInsuranceUrl: app.vehicleInsuranceUrl,
      createdAt: app.createdAt.millisecondsSinceEpoch,
      reviewedAt: app.reviewedAt?.millisecondsSinceEpoch,
      reviewedBy: app.reviewedBy,
      rejectionReason: app.rejectionReason,
      notes: app.notes,
    );
  }

  /// Converts to domain entity.
  DriverApplication toDomain() {
    return DriverApplication(
      id: id,
      userId: userId,
      status: ApplicationStatus.fromString(status),
      name: name,
      email: email,
      phone: phone,
      idNumber: idNumber,
      licenseNumber: licenseNumber,
      licenseExpiryDate: DateTime.fromMillisecondsSinceEpoch(licenseExpiryDate),
      vehicleType: VehicleType.fromString(vehicleType),
      vehiclePlate: vehiclePlate,
      photoUrl: photoUrl,
      idDocumentUrl: idDocumentUrl,
      licenseUrl: licenseUrl,
      vehicleRegistrationUrl: vehicleRegistrationUrl,
      vehicleInsuranceUrl: vehicleInsuranceUrl,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      reviewedAt: reviewedAt != null
          ? DateTime.fromMillisecondsSinceEpoch(reviewedAt!)
          : null,
      reviewedBy: reviewedBy,
      rejectionReason: rejectionReason,
      notes: notes,
    );
  }

  /// Converts to Firestore data (without ID).
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // ID is the document ID, not a field
    return json;
  }
}
