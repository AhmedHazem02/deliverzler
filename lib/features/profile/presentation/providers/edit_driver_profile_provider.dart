import 'package:image_picker/image_picker.dart';

import '../../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../driver_application/domain/driver_application.dart';
import '../../../driver_application/infrastructure/driver_application_repo.dart';
import '../../infrastructure/repos/profile_repo.dart';
import '../../domain/profile_details.dart';

part 'edit_driver_profile_provider.g.dart';

/// State for editing driver profile
class EditDriverProfileState {
  EditDriverProfileState({
    this.application,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.savedSuccessfully = false,
  });

  final DriverApplication? application;
  final bool isLoading;
  final bool isSaving;
  final String? error;
  final bool savedSuccessfully;

  EditDriverProfileState copyWith({
    DriverApplication? application,
    bool? isLoading,
    bool? isSaving,
    String? error,
    bool? savedSuccessfully,
  }) {
    return EditDriverProfileState(
      application: application ?? this.application,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
      savedSuccessfully: savedSuccessfully ?? this.savedSuccessfully,
    );
  }
}

/// Provider to manage editing driver profile
@riverpod
class EditDriverProfile extends _$EditDriverProfile {
  @override
  EditDriverProfileState build() => EditDriverProfileState();

  /// Load the current application data
  Future<void> loadApplication() async {
    state = state.copyWith(isLoading: true);

    try {
      final user = ref.read(currentUserProvider);
      final repo = ref.read(driverApplicationRepoProvider);
      final application = await repo.getApplicationByUserId(user.id);

      state = state.copyWith(
        application: application,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'فشل تحميل البيانات: $e',
      );
    }
  }

  /// Update profile data
  Future<void> updateProfile({
    required String name,
    required String phone,
    required String idNumber,
    required String licenseNumber,
    required DateTime licenseExpiryDate,
    required VehicleType vehicleType,
    required String vehiclePlate,
    String? notes,
    // Mobile files
    dynamic photo,
    dynamic idDocument,
    dynamic license,
    dynamic vehicleRegistration,
    dynamic vehicleInsurance,
    // Web files
    XFile? photoWeb,
    XFile? idDocumentWeb,
    XFile? licenseWeb,
    XFile? vehicleRegistrationWeb,
    XFile? vehicleInsuranceWeb,
  }) async {
    if (state.application == null) {
      state = state.copyWith(error: 'لا يوجد طلب للتعديل');
      return;
    }

    state = state.copyWith(isSaving: true, savedSuccessfully: false);

    try {
      final user = ref.read(currentUserProvider);
      final repo = ref.read(driverApplicationRepoProvider);
      final profileRepo = ref.read(profileRepoProvider);

      // Update driver application data
      await repo.updateApplication(
        applicationId: state.application!.id,
        userId: user.id,
        name: name,
        phone: phone,
        idNumber: idNumber,
        licenseNumber: licenseNumber,
        licenseExpiryDate: licenseExpiryDate,
        vehicleType: vehicleType,
        vehiclePlate: vehiclePlate,
        notes: notes,
        photo: photo,
        idDocument: idDocument,
        license: license,
        vehicleRegistration: vehicleRegistration,
        vehicleInsurance: vehicleInsurance,
        photoWeb: photoWeb,
        idDocumentWeb: idDocumentWeb,
        licenseWeb: licenseWeb,
        vehicleRegistrationWeb: vehicleRegistrationWeb,
        vehicleInsuranceWeb: vehicleInsuranceWeb,
      );

      // Also update user profile (name & phone) in users collection
      await profileRepo.updateProfileData(
        ProfileDetails(
          name: name,
          phone: phone,
        ),
      );

      // Update local auth state
      ref.read(authStateProvider.notifier).updateUser(
            ProfileDetails(
              name: name,
              phone: phone,
            ),
          );

      // Reload application data
      final updatedApplication = await repo.getApplicationByUserId(user.id);

      state = state.copyWith(
        application: updatedApplication,
        isSaving: false,
        savedSuccessfully: true,
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'فشل حفظ البيانات: $e',
      );
    }
  }

  /// Clear success state
  void clearSuccess() {
    state = state.copyWith(savedSuccessfully: false);
  }
}
