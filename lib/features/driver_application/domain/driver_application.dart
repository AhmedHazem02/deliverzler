import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_application.freezed.dart';

/// Application status matching Admin Dashboard's OnboardingStatus.
enum ApplicationStatus {
  /// Initial state - waiting for review.
  pending,

  /// Currently being reviewed by admin.
  underReview,

  /// Application approved - driver can access the app.
  approved,

  /// Application rejected - driver cannot access the app.
  rejected;

  /// Returns the Arabic display name.
  String get arabicName => switch (this) {
        ApplicationStatus.pending => 'قيد الانتظار',
        ApplicationStatus.underReview => 'قيد المراجعة',
        ApplicationStatus.approved => 'مقبول',
        ApplicationStatus.rejected => 'مرفوض',
      };

  /// Returns the English display name.
  String get englishName => switch (this) {
        ApplicationStatus.pending => 'Pending',
        ApplicationStatus.underReview => 'Under Review',
        ApplicationStatus.approved => 'Approved',
        ApplicationStatus.rejected => 'Rejected',
      };

  /// Whether this status allows app access.
  bool get canAccessApp => this == ApplicationStatus.approved;

  /// Whether this status is still pending decision.
  bool get isPending =>
      this == ApplicationStatus.pending || this == ApplicationStatus.underReview;

  /// Creates from string value.
  static ApplicationStatus fromString(String? value) {
    return ApplicationStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ApplicationStatus.pending,
    );
  }
}

/// Vehicle type enum.
enum VehicleType {
  car,
  motorcycle,
  bicycle;

  String get arabicName => switch (this) {
        VehicleType.car => 'سيارة',
        VehicleType.motorcycle => 'دراجة نارية',
        VehicleType.bicycle => 'دراجة هوائية',
      };

  String get englishName => switch (this) {
        VehicleType.car => 'Car',
        VehicleType.motorcycle => 'Motorcycle',
        VehicleType.bicycle => 'Bicycle',
      };

  static VehicleType fromString(String? value) {
    return VehicleType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => VehicleType.car,
    );
  }
}

/// Driver application entity.
///
/// Matches Admin Dashboard's DriverOnboardingEntity structure.
@freezed
class DriverApplication with _$DriverApplication {
  const factory DriverApplication({
    /// Unique application ID.
    required String id,

    /// User ID from Firebase Auth.
    required String userId,

    /// Application status.
    required ApplicationStatus status,

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

    /// License expiry date.
    required DateTime licenseExpiryDate,

    /// Type of vehicle.
    required VehicleType vehicleType,

    /// Vehicle plate number.
    required String vehiclePlate,

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

    /// Application submission date.
    required DateTime createdAt,

    /// Date when application was reviewed.
    DateTime? reviewedAt,

    /// ID of admin who reviewed.
    String? reviewedBy,

    /// Reason for rejection (if rejected).
    String? rejectionReason,

    /// Additional notes.
    String? notes,
  }) = _DriverApplication;

  const DriverApplication._();

  /// Creates an empty application for a new user.
  factory DriverApplication.empty({
    required String userId,
    required String name,
    required String email,
  }) {
    return DriverApplication(
      id: '',
      userId: userId,
      status: ApplicationStatus.pending,
      name: name,
      email: email,
      phone: '',
      idNumber: '',
      licenseNumber: '',
      licenseExpiryDate: DateTime.now().add(const Duration(days: 365)),
      vehicleType: VehicleType.car,
      vehiclePlate: '',
      createdAt: DateTime.now(),
    );
  }

  /// Whether the application is complete (all required fields filled).
  bool get isComplete =>
      phone.isNotEmpty &&
      idNumber.isNotEmpty &&
      licenseNumber.isNotEmpty &&
      vehiclePlate.isNotEmpty &&
      idDocumentUrl != null &&
      licenseUrl != null;

  /// Whether documents are uploaded.
  bool get hasDocuments =>
      idDocumentUrl != null &&
      licenseUrl != null;
}
