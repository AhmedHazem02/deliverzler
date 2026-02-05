import '../../../core/presentation/utils/file_utils.dart';
import '../../../core/domain/value_validators.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/infrastructure/error/app_exception.dart';
import '../../../core/presentation/extensions/app_error_extension.dart';
import '../../../core/presentation/helpers/localization_helper.dart';
import '../../../core/presentation/routing/app_router.dart';
import '../../../core/presentation/styles/styles.dart';
import '../../../core/presentation/utils/riverpod_framework.dart';
import '../../../core/presentation/widgets/custom_elevated_button.dart';
import '../../../core/presentation/widgets/toasts.dart';
import '../../../features/driver_application/domain/driver_application.dart';
import '../../../features/driver_application/infrastructure/driver_application_repo.dart';
import '../../domain/sign_in_with_email.dart';
import '../providers/sign_up_provider.dart';

/// Combined signup form with driver application fields.
///
/// This form collects:
/// 1. Account credentials (email, password)
/// 2. Personal information
/// 3. License information
/// 4. Vehicle information
/// 5. Required documents (uploaded to Supabase Storage)
class DriverSignupFormComponent extends HookConsumerWidget {
  const DriverSignupFormComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final isSubmitting = useState(false);
    final errorMessage = useState<String?>(null);
    final currentStep = useState(0);

    // Account fields
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    // Personal info fields
    final nameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final idNumberController = useTextEditingController();

    // License fields
    final licenseNumberController = useTextEditingController();
    final licenseExpiryDate = useState<DateTime?>(null);

    // Vehicle fields
    final vehicleType = useState(VehicleType.car);
    final vehiclePlateController = useTextEditingController();

    // Documents - support both File (mobile) and XFile (web)
    final photoFile = useState<dynamic>(null);
    final idDocumentFile = useState<dynamic>(null);
    final licenseDocumentFile = useState<dynamic>(null);
    final vehicleRegistrationFile = useState<dynamic>(null);
    final vehicleInsuranceFile = useState<dynamic>(null);

    // Web files
    final photoXFile = useState<XFile?>(null);
    final idDocumentXFile = useState<XFile?>(null);
    final licenseDocumentXFile = useState<XFile?>(null);
    final vehicleRegistrationXFile = useState<XFile?>(null);
    final vehicleInsuranceXFile = useState<XFile?>(null);

    // Notes
    final notesController = useTextEditingController();

    // Listen for signup state changes
    ref.listen(signUpStateProvider, (previous, next) {
      next.when(
        data: (result) {
          result.fold(
            () {}, // None - idle
            (user) async {
              // User created successfully, now submit driver application
              try {
                final repo = ref.read(driverApplicationRepoProvider);
                await repo.submitApplication(
                  userId: user.id,
                  name: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  idNumber: idNumberController.text,
                  licenseNumber: licenseNumberController.text,
                  licenseExpiryDate: licenseExpiryDate.value!,
                  vehicleType: vehicleType.value,
                  vehiclePlate: vehiclePlateController.text,
                  // Mobile files
                  photo: photoFile.value,
                  idDocument: idDocumentFile.value,
                  license: licenseDocumentFile.value,
                  vehicleRegistration: vehicleRegistrationFile.value,
                  vehicleInsurance: vehicleInsuranceFile.value,
                  // Web files
                  photoWeb: photoXFile.value,
                  idDocumentWeb: idDocumentXFile.value,
                  licenseWeb: licenseDocumentXFile.value,
                  vehicleRegistrationWeb: vehicleRegistrationXFile.value,
                  vehicleInsuranceWeb: vehicleInsuranceXFile.value,
                  notes: notesController.text.isEmpty
                      ? null
                      : notesController.text,
                );

                // Check if widget is still mounted before updating state
                if (!context.mounted) return;

                isSubmitting.value = false;

                // Show success toast
                Toasts.showTitledToast(
                  context,
                  title: tr(context).applicationSubmitted,
                  description: tr(context).verificationEmailSent,
                );

                // Navigate to email verification screen
                EmailVerificationRoute(email: emailController.text).go(context);
              } catch (e) {
                // Check if widget is still mounted before updating state
                if (!context.mounted) return;

                isSubmitting.value = false;
                errorMessage.value = 'حدث خطأ أثناء تقديم الطلب: $e';
              }
            },
          );
        },
        loading: () {
          if (!context.mounted) return;
          isSubmitting.value = true;
        },
        error: (error, _) {
          if (!context.mounted) return;
          isSubmitting.value = false;
          errorMessage.value = error.errorMessage(context);
        },
      );
    });

    bool validateDocuments() {
      if (kIsWeb) {
        return photoXFile.value != null &&
            idDocumentXFile.value != null &&
            licenseDocumentXFile.value != null &&
            vehicleRegistrationXFile.value != null &&
            vehicleInsuranceXFile.value != null;
      } else {
        return photoFile.value != null &&
            idDocumentFile.value != null &&
            licenseDocumentFile.value != null &&
            vehicleRegistrationFile.value != null &&
            vehicleInsuranceFile.value != null;
      }
    }

    bool validateCurrentStep() {
      // Validate all fields in the current step (trigger validators)
      final isFormValid = formKey.currentState!.validate();

      // Additional checks for non-form-field inputs
      bool isAdditionalValid = true;
      if (currentStep.value == 3) {
        // License step (now index 3)
        if (licenseExpiryDate.value == null) {
          isAdditionalValid = false;
        } else if (licenseExpiryDate.value!
            .isBefore(DateTime.now().add(const Duration(days: 30)))) {
          // Show toast/snackbar since we can't easily set form field error here for the date picker
          // Or we rely on the submit check.
          // But let's add a check here to prevent proceeding.
          Toasts.showTitledToast(context,
              title: tr(context).attention,
              description:
                  'يجب أن تكون صلاحية الرخصة سارية لمدة شهر على الأقل من تاريخ اليوم');
          isAdditionalValid = false;
        }
      }

      return isFormValid && isAdditionalValid;
    }

    void submitForm() {
      if (!formKey.currentState!.validate()) return;

      if (!validateDocuments()) {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr(context).attention,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Icon(Icons.warning_amber_rounded,
                      size: 50, color: Colors.orange),
                  const SizedBox(height: 16),
                  Text(
                    tr(context).uploadAllRequiredImages,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
        return;
      }

      errorMessage.value = null;
      isSubmitting.value = true;

      // First create the account
      ref.read(signUpStateProvider.notifier).signUp(
            email: emailController.text,
            password: passwordController.text,
            name: nameController.text,
          );
    }

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Error message
          if (errorMessage.value != null && errorMessage.value!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: Sizes.marginV16),
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.marginH16,
                vertical: Sizes.marginV12,
              ),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      errorMessage.value!,
                      style:
                          TextStyle(color: Colors.red.shade700, fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => errorMessage.value = null,
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),

          // Step indicator
          _StepIndicator(
            currentStep: currentStep.value,
            totalSteps: 5,
            labels: [
              tr(context).accountInfo,
              tr(context).personalInfo,
              tr(context).vehicleInfo,
              tr(context).licenseInfo,
              tr(context).documents,
            ],
          ),
          const SizedBox(height: Sizes.marginV24),

          // Step content
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildStepContent(
              context,
              ref,
              currentStep: currentStep.value,
              isSubmitting: isSubmitting.value,
              // Account
              emailController: emailController,
              passwordController: passwordController,
              confirmPasswordController: confirmPasswordController,
              // Personal
              nameController: nameController,
              phoneController: phoneController,
              idNumberController: idNumberController,
              // License
              licenseNumberController: licenseNumberController,
              licenseExpiryDate: licenseExpiryDate,
              // Vehicle
              vehicleType: vehicleType,
              vehiclePlateController: vehiclePlateController,
              // Documents - mobile
              photoFile: photoFile,
              idDocumentFile: idDocumentFile,
              licenseDocumentFile: licenseDocumentFile,
              vehicleRegistrationFile: vehicleRegistrationFile,
              vehicleInsuranceFile: vehicleInsuranceFile,
              // Documents - web
              photoXFile: photoXFile,
              idDocumentXFile: idDocumentXFile,
              licenseDocumentXFile: licenseDocumentXFile,
              vehicleRegistrationXFile: vehicleRegistrationXFile,
              vehicleInsuranceXFile: vehicleInsuranceXFile,
              // Notes
              notesController: notesController,
            ),
          ),

          const SizedBox(height: Sizes.marginV24),

          // Navigation buttons
          Row(
            children: [
              if (currentStep.value > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: isSubmitting.value
                        ? null
                        : () {
                            errorMessage.value = null;
                            currentStep.value--;
                          },
                    child: Text(tr(context).previous),
                  ),
                ),
              if (currentStep.value > 0) const SizedBox(width: Sizes.marginH12),
              Expanded(
                child: CustomElevatedButton(
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.buttonPaddingV14,
                    horizontal: Sizes.buttonPaddingH24,
                  ),
                  onPressed: isSubmitting.value
                      ? null
                      : () {
                          if (currentStep.value < 4) {
                            if (validateCurrentStep()) {
                              errorMessage.value = null;
                              currentStep.value++;
                            } else {
                              errorMessage.value = tr(context).fillAllFields;
                            }
                          } else {
                            submitForm();
                          }
                        },
                  child: isSubmitting.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          currentStep.value < 4
                              ? tr(context).next
                              : tr(context).submitApplication,
                        ),
                ),
              ),
            ],
          ),

          const SizedBox(height: Sizes.marginV16),

          // Back to login link
          TextButton(
            onPressed: isSubmitting.value
                ? null
                : () => context.go(const SignInRoute().location),
            child: Text(tr(context).alreadyHaveAccount),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(
    BuildContext context,
    WidgetRef ref, {
    required int currentStep,
    required bool isSubmitting,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    required TextEditingController nameController,
    required TextEditingController phoneController,
    required TextEditingController idNumberController,
    required TextEditingController licenseNumberController,
    required ValueNotifier<DateTime?> licenseExpiryDate,
    required ValueNotifier<VehicleType> vehicleType,
    required TextEditingController vehiclePlateController,
    // Mobile files
    required ValueNotifier<dynamic> photoFile,
    required ValueNotifier<dynamic> idDocumentFile,
    required ValueNotifier<dynamic> licenseDocumentFile,
    required ValueNotifier<dynamic> vehicleRegistrationFile,
    required ValueNotifier<dynamic> vehicleInsuranceFile,
    // Web files
    required ValueNotifier<XFile?> photoXFile,
    required ValueNotifier<XFile?> idDocumentXFile,
    required ValueNotifier<XFile?> licenseDocumentXFile,
    required ValueNotifier<XFile?> vehicleRegistrationXFile,
    required ValueNotifier<XFile?> vehicleInsuranceXFile,
    required TextEditingController notesController,
  }) {
    switch (currentStep) {
      case 0:
        return _AccountStep(
          key: const ValueKey('account'),
          emailController: emailController,
          passwordController: passwordController,
          confirmPasswordController: confirmPasswordController,
          isSubmitting: isSubmitting,
        );
      case 1:
        return _PersonalInfoStep(
          key: const ValueKey('personal'),
          nameController: nameController,
          phoneController: phoneController,
          idNumberController: idNumberController,
          isSubmitting: isSubmitting,
        );
      case 2:
        return _VehicleStep(
          key: const ValueKey('vehicle'),
          vehicleType: vehicleType,
          vehiclePlateController: vehiclePlateController,
          isSubmitting: isSubmitting,
        );
      case 3:
        return _LicenseStep(
          key: const ValueKey('license'),
          licenseNumberController: licenseNumberController,
          licenseExpiryDate: licenseExpiryDate,
          isSubmitting: isSubmitting,
        );
      case 4:
        return _DocumentsStep(
          key: const ValueKey('documents'),
          photoFile: photoFile,
          idDocumentFile: idDocumentFile,
          licenseDocumentFile: licenseDocumentFile,
          vehicleRegistrationFile: vehicleRegistrationFile,
          vehicleInsuranceFile: vehicleInsuranceFile,
          photoXFile: photoXFile,
          idDocumentXFile: idDocumentXFile,
          licenseDocumentXFile: licenseDocumentXFile,
          vehicleRegistrationXFile: vehicleRegistrationXFile,
          vehicleInsuranceXFile: vehicleInsuranceXFile,
          notesController: notesController,
          isSubmitting: isSubmitting,
        );
      default:
        return const SizedBox();
    }
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
  });

  final int currentStep;
  final int totalSteps;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final isActive = index <= currentStep;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsetsDirectional.only(
                    end: index < totalSteps - 1 ? 4 : 0),
                decoration: BoxDecoration(
                  color: isActive
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          '${currentStep + 1}/$totalSteps - ${labels[currentStep]}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class _AccountStep extends HookWidget {
  const _AccountStep({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isSubmitting,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final isPasswordVisible = useState(false);
    final isConfirmPasswordVisible = useState(false);

    return Column(
      children: [
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: tr(context).email,
            prefixIcon: const Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: SignInWithEmail.validateEmail(context),
          enabled: !isSubmitting,
        ),
        const SizedBox(height: Sizes.marginV16),
        TextFormField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: tr(context).password,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () {
                isPasswordVisible.value = !isPasswordVisible.value;
              },
            ),
          ),
          obscureText: !isPasswordVisible.value,
          validator: SignInWithEmail.validatePassword(context),
          enabled: !isSubmitting,
        ),
        const SizedBox(height: Sizes.marginV16),
        TextFormField(
          controller: confirmPasswordController,
          decoration: InputDecoration(
            labelText: tr(context).confirmPassword,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                isConfirmPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () {
                isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
              },
            ),
          ),
          obscureText: !isConfirmPasswordVisible.value,
          validator: (v) {
            if (v != passwordController.text) {
              return tr(context).passwordsDoNotMatch;
            }
            return null;
          },
          enabled: !isSubmitting,
        ),
      ],
    );
  }
}

class _PersonalInfoStep extends StatelessWidget {
  const _PersonalInfoStep({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.idNumberController,
    required this.isSubmitting,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController idNumberController;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: tr(context).fullName,
            prefixIcon: const Icon(Icons.person),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? tr(context).requiredField : null,
          enabled: !isSubmitting,
        ),
        const SizedBox(height: Sizes.marginV16),
        TextFormField(
          controller: phoneController,
          decoration: InputDecoration(
            labelText: tr(context).phone,
            prefixIcon: const Icon(Icons.phone),
          ),
          keyboardType: TextInputType.phone,
          validator: (v) {
            if (v == null || v.isEmpty) return tr(context).requiredField;
            if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(v)) {
              return tr(context).enterValidEgyptianPhone;
            }
            return null;
          },
          enabled: !isSubmitting,
        ),
        const SizedBox(height: Sizes.marginV16),
        TextFormField(
          controller: idNumberController,
          decoration: InputDecoration(
            labelText: tr(context).idNumber,
            prefixIcon: const Icon(Icons.badge),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return tr(context).requiredField;
            if (v.length != 14) return tr(context).idNumberLengthError;
            return null;
          },
          keyboardType: TextInputType.number,
          enabled: !isSubmitting,
        ),
      ],
    );
  }
}

class _LicenseStep extends StatelessWidget {
  const _LicenseStep({
    super.key,
    required this.licenseNumberController,
    required this.licenseExpiryDate,
    required this.isSubmitting,
  });

  final TextEditingController licenseNumberController;
  final ValueNotifier<DateTime?> licenseExpiryDate;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: licenseNumberController,
          decoration: InputDecoration(
            labelText: tr(context).licenseNumber,
            prefixIcon: const Icon(Icons.card_membership),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return tr(context).requiredField;
            if (v.length != 14) return tr(context).licenseNumberLengthError;
            return null;
          },
          keyboardType: TextInputType.number,
          enabled: !isSubmitting,
        ),
        const SizedBox(height: Sizes.marginV16),
        InkWell(
          onTap: isSubmitting
              ? null
              : () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: licenseExpiryDate.value ??
                        DateTime.now().add(const Duration(days: 31)),
                    firstDate: DateTime.now().add(const Duration(days: 30)),
                    lastDate:
                        DateTime.now().add(const Duration(days: 365 * 10)),
                  );
                  if (date != null) {
                    licenseExpiryDate.value = date;
                  }
                },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: tr(context).licenseExpiryDate,
              prefixIcon: const Icon(Icons.calendar_today),
            ),
            child: Text(
              licenseExpiryDate.value != null
                  ? '${licenseExpiryDate.value!.day}/${licenseExpiryDate.value!.month}/${licenseExpiryDate.value!.year}'
                  : tr(context).selectDate,
              style: TextStyle(
                color: licenseExpiryDate.value != null ? null : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VehicleStep extends StatelessWidget {
  const _VehicleStep({
    super.key,
    required this.vehicleType,
    required this.vehiclePlateController,
    required this.isSubmitting,
  });

  final ValueNotifier<VehicleType> vehicleType;
  final TextEditingController vehiclePlateController;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<VehicleType>(
          value: vehicleType.value,
          decoration: InputDecoration(
            labelText: tr(context).vehicleType,
            prefixIcon: const Icon(Icons.directions_car),
          ),
          items: VehicleType.values
              .map(
                (type) => DropdownMenuItem(
                  value: type,
                  child: Text(_getVehicleTypeName(context, type)),
                ),
              )
              .toList(),
          onChanged: isSubmitting
              ? null
              : (value) {
                  if (value != null) {
                    vehicleType.value = value;
                  }
                },
        ),
        const SizedBox(height: Sizes.marginV16),
        TextFormField(
          controller: vehiclePlateController,
          decoration: InputDecoration(
            labelText: tr(context).vehiclePlate,
            prefixIcon: const Icon(Icons.confirmation_number),
          ),
          validator: ValueValidators.validateVehiclePlate(
            context,
            isMotorcycle: vehicleType.value == VehicleType.motorcycle,
          ),
          enabled: !isSubmitting,
        ),
      ],
    );
  }

  String _getVehicleTypeName(BuildContext context, VehicleType type) {
    switch (type) {
      case VehicleType.car:
        return tr(context).car;
      case VehicleType.motorcycle:
        return tr(context).motorcycle;
    }
  }
}

class _DocumentsStep extends StatelessWidget {
  const _DocumentsStep({
    super.key,
    required this.photoFile,
    required this.idDocumentFile,
    required this.licenseDocumentFile,
    required this.vehicleRegistrationFile,
    required this.vehicleInsuranceFile,
    required this.photoXFile,
    required this.idDocumentXFile,
    required this.licenseDocumentXFile,
    required this.vehicleRegistrationXFile,
    required this.vehicleInsuranceXFile,
    required this.notesController,
    required this.isSubmitting,
  });

  final ValueNotifier<dynamic> photoFile;
  final ValueNotifier<dynamic> idDocumentFile;
  final ValueNotifier<dynamic> licenseDocumentFile;
  final ValueNotifier<dynamic> vehicleRegistrationFile;
  final ValueNotifier<dynamic> vehicleInsuranceFile;
  final ValueNotifier<XFile?> photoXFile;
  final ValueNotifier<XFile?> idDocumentXFile;
  final ValueNotifier<XFile?> licenseDocumentXFile;
  final ValueNotifier<XFile?> vehicleRegistrationXFile;
  final ValueNotifier<XFile?> vehicleInsuranceXFile;
  final TextEditingController notesController;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DocumentUploadField(
          label: tr(context).personalPhoto,
          file: photoFile.value,
          xFile: photoXFile.value,
          onPick: (file, xFile) {
            photoFile.value = file;
            photoXFile.value = xFile;
          },
          enabled: !isSubmitting,
        ),
        _DocumentUploadField(
          label: tr(context).idDocument,
          file: idDocumentFile.value,
          xFile: idDocumentXFile.value,
          onPick: (file, xFile) {
            idDocumentFile.value = file;
            idDocumentXFile.value = xFile;
          },
          enabled: !isSubmitting,
        ),
        _DocumentUploadField(
          label: tr(context).licenseDocument,
          file: licenseDocumentFile.value,
          xFile: licenseDocumentXFile.value,
          onPick: (file, xFile) {
            licenseDocumentFile.value = file;
            licenseDocumentXFile.value = xFile;
          },
          enabled: !isSubmitting,
        ),
        _DocumentUploadField(
          label: tr(context).vehicleRegistration,
          file: vehicleRegistrationFile.value,
          xFile: vehicleRegistrationXFile.value,
          onPick: (file, xFile) {
            vehicleRegistrationFile.value = file;
            vehicleRegistrationXFile.value = xFile;
          },
          enabled: !isSubmitting,
        ),
        _DocumentUploadField(
          label: tr(context).vehicleInsurance,
          file: vehicleInsuranceFile.value,
          xFile: vehicleInsuranceXFile.value,
          onPick: (file, xFile) {
            vehicleInsuranceFile.value = file;
            vehicleInsuranceXFile.value = xFile;
          },
          enabled: !isSubmitting,
        ),
        const SizedBox(height: Sizes.marginV16),
        TextFormField(
          controller: notesController,
          decoration: InputDecoration(
            labelText: tr(context).additionalNotes,
            prefixIcon: const Icon(Icons.note),
          ),
          maxLines: 3,
          enabled: !isSubmitting,
        ),
      ],
    );
  }
}

class _DocumentUploadField extends StatelessWidget {
  const _DocumentUploadField({
    required this.label,
    required this.file,
    required this.xFile,
    required this.onPick,
    required this.enabled,
  });

  final String label;
  final dynamic file;
  final XFile? xFile;
  final void Function(dynamic, XFile?) onPick;
  final bool enabled;

  bool get hasFile => file != null || xFile != null;
  String get fileName {
    if (xFile != null) return xFile!.name;
    if (file != null) return file!.path.split('/').last;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.marginV12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.marginH12,
                vertical: Sizes.marginV12,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    hasFile ? Icons.check_circle : Icons.upload_file,
                    color: hasFile ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: Sizes.marginH8),
                  Expanded(
                    child: Text(
                      hasFile ? fileName : label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: hasFile ? null : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: Sizes.marginH8),
          IconButton(
            onPressed: enabled
                ? () async {
                    final picker = ImagePicker();
                    final image = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image != null) {
                      if (kIsWeb) {
                        // On web, use XFile directly
                        onPick(null, image);
                      } else {
                        // On mobile, convert to File
                        onPick(getFile(image.path), null);
                      }
                    }
                  }
                : null,
            icon: const Icon(Icons.add_photo_alternate),
          ),
          if (hasFile)
            IconButton(
              onPressed: enabled ? () => onPick(null, null) : null,
              icon: const Icon(Icons.close, color: Colors.red),
            ),
        ],
      ),
    );
  }
}
