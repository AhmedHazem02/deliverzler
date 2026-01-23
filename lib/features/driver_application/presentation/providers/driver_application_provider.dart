import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/driver_application.dart';
import '../../infrastructure/driver_application_repo.dart';

part 'driver_application_provider.g.dart';

/// Provider to watch the current user's application status
@riverpod
Stream<DriverApplication?> driverApplicationStream(
  Ref ref,
  String userId,
) {
  final repo = ref.watch(driverApplicationRepoProvider);
  return repo.watchApplicationByUserId(userId);
}

/// Provider to get the current user's application
@riverpod
Future<DriverApplication?> driverApplication(
  Ref ref,
  String userId,
) async {
  final repo = ref.watch(driverApplicationRepoProvider);
  return repo.getApplicationByUserId(userId);
}

/// Provider to check if user has an existing application
@riverpod
Future<bool> hasExistingApplication(
  Ref ref,
  String userId,
) async {
  final repo = ref.watch(driverApplicationRepoProvider);
  return repo.hasExistingApplication(userId);
}

/// Provider to get application status
@riverpod
Future<ApplicationStatus?> applicationStatus(
  Ref ref,
  String userId,
) async {
  final repo = ref.watch(driverApplicationRepoProvider);
  return repo.getApplicationStatus(userId);
}

/// State class for the submission form
class DriverApplicationFormState {
  DriverApplicationFormState({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.idNumber = '',
    this.licenseNumber = '',
    this.licenseExpiryDate,
    this.vehicleType = VehicleType.car,
    this.vehiclePlate = '',
    this.photo,
    this.idDocument,
    this.license,
    this.vehicleRegistration,
    this.vehicleInsurance,
    this.notes = '',
    this.isSubmitting = false,
    this.error,
  });

  final String name;
  final String email;
  final String phone;
  final String idNumber;
  final String licenseNumber;
  final DateTime? licenseExpiryDate;
  final VehicleType vehicleType;
  final String vehiclePlate;
  final File? photo;
  final File? idDocument;
  final File? license;
  final File? vehicleRegistration;
  final File? vehicleInsurance;
  final String notes;
  final bool isSubmitting;
  final String? error;

  bool get isValid =>
      name.isNotEmpty &&
      email.isNotEmpty &&
      phone.isNotEmpty &&
      idNumber.isNotEmpty &&
      licenseNumber.isNotEmpty &&
      licenseExpiryDate != null &&
      vehiclePlate.isNotEmpty;

  DriverApplicationFormState copyWith({
    String? name,
    String? email,
    String? phone,
    String? idNumber,
    String? licenseNumber,
    DateTime? licenseExpiryDate,
    VehicleType? vehicleType,
    String? vehiclePlate,
    File? photo,
    File? idDocument,
    File? license,
    File? vehicleRegistration,
    File? vehicleInsurance,
    String? notes,
    bool? isSubmitting,
    String? error,
  }) {
    return DriverApplicationFormState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      idNumber: idNumber ?? this.idNumber,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      vehicleType: vehicleType ?? this.vehicleType,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      photo: photo ?? this.photo,
      idDocument: idDocument ?? this.idDocument,
      license: license ?? this.license,
      vehicleRegistration: vehicleRegistration ?? this.vehicleRegistration,
      vehicleInsurance: vehicleInsurance ?? this.vehicleInsurance,
      notes: notes ?? this.notes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }
}

/// Notifier for the application form
@riverpod
class DriverApplicationForm extends _$DriverApplicationForm {
  @override
  DriverApplicationFormState build() => DriverApplicationFormState();

  void updateName(String value) {
    state = state.copyWith(name: value);
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void updatePhone(String value) {
    state = state.copyWith(phone: value);
  }

  void updateIdNumber(String value) {
    state = state.copyWith(idNumber: value);
  }

  void updateLicenseNumber(String value) {
    state = state.copyWith(licenseNumber: value);
  }

  void updateLicenseExpiryDate(DateTime value) {
    state = state.copyWith(licenseExpiryDate: value);
  }

  void updateVehicleType(VehicleType value) {
    state = state.copyWith(vehicleType: value);
  }

  void updateVehiclePlate(String value) {
    state = state.copyWith(vehiclePlate: value);
  }

  void updatePhoto(File? value) {
    state = state.copyWith(photo: value);
  }

  void updateIdDocument(File? value) {
    state = state.copyWith(idDocument: value);
  }

  void updateLicense(File? value) {
    state = state.copyWith(license: value);
  }

  void updateVehicleRegistration(File? value) {
    state = state.copyWith(vehicleRegistration: value);
  }

  void updateVehicleInsurance(File? value) {
    state = state.copyWith(vehicleInsurance: value);
  }

  void updateNotes(String value) {
    state = state.copyWith(notes: value);
  }

  Future<String?> submitApplication(String userId) async {
    if (!state.isValid) {
      state = state.copyWith(error: 'ÙŠØ±Ø¬Ù‰ Ù…Ù„Ø¡ Ø¬Ù…ÙŠØ¹ Ø§Ù„Ø­Ù‚ÙˆÙ„ Ø§Ù„Ù…Ø·Ù„ÙˆØ¨Ø©');
      return null;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final repo = ref.read(driverApplicationRepoProvider);
      final applicationId = await repo.submitApplication(
        userId: userId,
        name: state.name,
        email: state.email,
        phone: state.phone,
        idNumber: state.idNumber,
        licenseNumber: state.licenseNumber,
        licenseExpiryDate: state.licenseExpiryDate!,
        vehicleType: state.vehicleType,
        vehiclePlate: state.vehiclePlate,
        photo: state.photo,
        idDocument: state.idDocument,
        license: state.license,
        vehicleRegistration: state.vehicleRegistration,
        vehicleInsurance: state.vehicleInsurance,
        notes: state.notes.isEmpty ? null : state.notes,
      );

      state = state.copyWith(isSubmitting: false);
      return applicationId;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: 'Ø­Ø¯Ø« Ø®Ø·Ø£ Ø£Ø«Ù†Ø§Ø¡ ØªÙ‚Ø¯ÙŠÙ… Ø§Ù„Ø·Ù„Ø¨: ${e.toString()}',
      );
      return null;
    }
  }

  void reset() {
    state = DriverApplicationFormState();
  }
}

