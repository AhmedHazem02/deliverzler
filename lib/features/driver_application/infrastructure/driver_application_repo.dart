import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../core/infrastructure/network/network_info.dart';
import '../../../core/presentation/utils/riverpod_framework.dart';
import '../domain/driver_application.dart';
import 'data_sources/driver_application_remote_data_source.dart';
import 'dtos/driver_application_dto.dart';

part 'driver_application_repo.g.dart';

@Riverpod(keepAlive: true)
DriverApplicationRepo driverApplicationRepo(Ref ref) {
  return DriverApplicationRepo(
    networkInfo: ref.watch(networkInfoProvider),
    remoteDataSource: ref.watch(driverApplicationRemoteDataSourceProvider),
  );
}

class DriverApplicationRepo {
  DriverApplicationRepo({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  final NetworkInfo networkInfo;
  final DriverApplicationRemoteDataSource remoteDataSource;

  /// Submit a new driver application
  ///
  /// Supports both mobile (File) and web (XFile) file uploads.
  Future<String> submitApplication({
    required String userId,
    required String name,
    required String email,
    required String phone,
    required String idNumber,
    required String licenseNumber,
    required DateTime licenseExpiryDate,
    required VehicleType vehicleType,
    required String vehiclePlate,
    // Mobile files
    File? photo,
    File? idDocument,
    File? license,
    File? vehicleRegistration,
    File? vehicleInsurance,
    // Web files
    XFile? photoWeb,
    XFile? idDocumentWeb,
    XFile? licenseWeb,
    XFile? vehicleRegistrationWeb,
    XFile? vehicleInsuranceWeb,
    String? notes,
  }) async {
    // Upload all documents to Supabase Storage
    final documentUrls = <String, String>{};

    // Photo
    if (photo != null || photoWeb != null) {
      documentUrls['photo'] = await remoteDataSource.uploadDocument(
        userId: userId,
        documentType: 'photo',
        file: photo,
        webFile: photoWeb,
      );
    }

    // ID Document
    if (idDocument != null || idDocumentWeb != null) {
      documentUrls['idDocument'] = await remoteDataSource.uploadDocument(
        userId: userId,
        documentType: 'idDocument',
        file: idDocument,
        webFile: idDocumentWeb,
      );
    }

    // License
    if (license != null || licenseWeb != null) {
      documentUrls['license'] = await remoteDataSource.uploadDocument(
        userId: userId,
        documentType: 'license',
        file: license,
        webFile: licenseWeb,
      );
    }

    // Vehicle Registration
    if (vehicleRegistration != null || vehicleRegistrationWeb != null) {
      documentUrls['vehicleRegistration'] =
          await remoteDataSource.uploadDocument(
        userId: userId,
        documentType: 'vehicleRegistration',
        file: vehicleRegistration,
        webFile: vehicleRegistrationWeb,
      );
    }

    // Vehicle Insurance
    if (vehicleInsurance != null || vehicleInsuranceWeb != null) {
      documentUrls['vehicleInsurance'] = await remoteDataSource.uploadDocument(
        userId: userId,
        documentType: 'vehicleInsurance',
        file: vehicleInsurance,
        webFile: vehicleInsuranceWeb,
      );
    }

    // Create the application
    final application = DriverApplication(
      id: '', // Will be set by Firestore
      userId: userId,
      status: ApplicationStatus.pending,
      name: name,
      email: email,
      phone: phone,
      idNumber: idNumber,
      licenseNumber: licenseNumber,
      licenseExpiryDate: licenseExpiryDate,
      vehicleType: vehicleType,
      vehiclePlate: vehiclePlate,
      photoUrl: documentUrls['photo'],
      idDocumentUrl: documentUrls['idDocument'],
      licenseUrl: documentUrls['license'],
      vehicleRegistrationUrl: documentUrls['vehicleRegistration'],
      vehicleInsuranceUrl: documentUrls['vehicleInsurance'],
      createdAt: DateTime.now(),
      notes: notes,
    );

    final dto = DriverApplicationDto.fromDomain(application);
    return remoteDataSource.submitApplication(dto);
  }

  /// Get application by user ID
  Future<DriverApplication?> getApplicationByUserId(String userId) async {
    final dto = await remoteDataSource.getApplicationByUserId(userId);
    return dto?.toDomain();
  }

  /// Watch application status changes in real-time
  Stream<DriverApplication?> watchApplicationByUserId(String userId) {
    return remoteDataSource.watchApplicationByUserId(userId);
  }

  /// Check if user has an existing application
  Future<bool> hasExistingApplication(String userId) async {
    final dto = await remoteDataSource.getApplicationByUserId(userId);
    return dto != null;
  }

  /// Get application status
  Future<ApplicationStatus?> getApplicationStatus(String userId) async {
    final dto = await remoteDataSource.getApplicationByUserId(userId);
    return dto?.toDomain().status;
  }

  /// Update an existing driver application
  Future<void> updateApplication({
    required String applicationId,
    required String userId,
    String? name,
    String? phone,
    String? idNumber,
    String? licenseNumber,
    DateTime? licenseExpiryDate,
    VehicleType? vehicleType,
    String? vehiclePlate,
    String? notes,
    // Mobile files
    File? photo,
    File? idDocument,
    File? license,
    File? vehicleRegistration,
    File? vehicleInsurance,
    // Web files
    XFile? photoWeb,
    XFile? idDocumentWeb,
    XFile? licenseWeb,
    XFile? vehicleRegistrationWeb,
    XFile? vehicleInsuranceWeb,
  }) async {
    final data = <String, dynamic>{};

    // Basic fields
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (idNumber != null) data['idNumber'] = idNumber;
    if (licenseNumber != null) data['licenseNumber'] = licenseNumber;
    if (licenseExpiryDate != null) {
      data['licenseExpiryDate'] = licenseExpiryDate.millisecondsSinceEpoch;
    }
    if (vehicleType != null) data['vehicleType'] = vehicleType.name;
    if (vehiclePlate != null) data['vehiclePlate'] = vehiclePlate;
    if (notes != null) data['notes'] = notes;

    // Upload documents if provided
    if (photo != null || photoWeb != null) {
      data['photoUrl'] = await remoteDataSource.uploadDocument(
        userId: userId,
        documentType: 'photo',
        file: photo,
        webFile: photoWeb,
      );
    }

    if (idDocument != null || idDocumentWeb != null) {
      data['idDocumentUrl'] = await remoteDataSource.uploadDocument(
        userId: userId,
        documentType: 'idDocument',
        file: idDocument,
        webFile: idDocumentWeb,
      );
    }

    if (license != null || licenseWeb != null) {
      data['licenseUrl'] = await remoteDataSource.uploadDocument(
        userId: userId,
        documentType: 'license',
        file: license,
        webFile: licenseWeb,
      );
    }

    if (vehicleRegistration != null || vehicleRegistrationWeb != null) {
      data['vehicleRegistrationUrl'] = await remoteDataSource.uploadDocument(
        userId: userId,
        documentType: 'vehicleRegistration',
        file: vehicleRegistration,
        webFile: vehicleRegistrationWeb,
      );
    }

    if (vehicleInsurance != null || vehicleInsuranceWeb != null) {
      data['vehicleInsuranceUrl'] = await remoteDataSource.uploadDocument(
        userId: userId,
        documentType: 'vehicleInsurance',
        file: vehicleInsurance,
        webFile: vehicleInsuranceWeb,
      );
    }

    if (data.isNotEmpty) {
      await remoteDataSource.updateApplication(
        applicationId: applicationId,
        data: data,
      );
    }
  }
}
