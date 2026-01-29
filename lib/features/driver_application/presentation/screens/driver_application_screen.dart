import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../core/presentation/screens/full_screen_scaffold.dart';
import '../../../../core/presentation/styles/styles.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../core/presentation/widgets/custom_elevated_button.dart';
import '../../domain/driver_application.dart';
import '../providers/driver_application_provider.dart';

class DriverApplicationScreen extends HookConsumerWidget {
  const DriverApplicationScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    
    // Controllers for form fields
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final phoneController = useTextEditingController();
    final idNumberController = useTextEditingController();
    final licenseNumberController = useTextEditingController();
    final vehiclePlateController = useTextEditingController();
    final notesController = useTextEditingController();

    final formState = ref.watch(driverApplicationFormProvider);

    // Initial load of existing data if any
    useEffect(() {
      Future.microtask(() async {
        final application = await ref.read(driverApplicationProvider(userId).future);
        if (application != null) {
          final notifier = ref.read(driverApplicationFormProvider.notifier);
          
          notifier.updateName(application.name);
          nameController.text = application.name;

          notifier.updateEmail(application.email);
          emailController.text = application.email;

          notifier.updatePhone(application.phone);
          phoneController.text = application.phone;

          notifier.updateIdNumber(application.idNumber);
          idNumberController.text = application.idNumber;

          notifier.updateLicenseNumber(application.licenseNumber);
          licenseNumberController.text = application.licenseNumber;

          notifier.updateLicenseExpiryDate(application.licenseExpiryDate);
          notifier.updateVehicleType(application.vehicleType);
          
          notifier.updateVehiclePlate(application.vehiclePlate);
          vehiclePlateController.text = application.vehiclePlate;

          if (application.notes != null) {
            notifier.updateNotes(application.notes!);
            notesController.text = application.notes!;
          }
        }
      });
      return null;
    }, const []);

    return FullScreenScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Sizes.marginH20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: Sizes.marginV16),
                // Header
                Text(
                  tr(context).driverApplicationTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Sizes.marginV8),
                Text(
                  tr(context).driverApplicationSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Sizes.marginV24),

                // Error message
                // Error message
                if (formState.error != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: Sizes.marginV16),
                    padding: const EdgeInsets.fromLTRB(Sizes.marginH16, Sizes.marginV12, Sizes.marginH8, Sizes.marginV12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700),
                        const SizedBox(width: Sizes.marginH12),
                        Expanded(
                          child: Text(
                            formState.error!,
                            style: TextStyle(
                              color: Colors.red.shade900,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          color: Colors.red.shade700,
                          onPressed: () {
                             ref.read(driverApplicationFormProvider.notifier).clearError();
                          },
                        ),
                      ],
                    ),
                  ),

                // Personal Information Section
                _SectionTitle(title: tr(context).personalInfo),
                const SizedBox(height: Sizes.marginV12),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: tr(context).fullName,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? tr(context).requiredField : null,
                  onChanged: ref
                      .read(driverApplicationFormProvider.notifier)
                      .updateName,
                  enabled: !formState.isSubmitting,
                ),
                const SizedBox(height: Sizes.marginV12),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: tr(context).email,
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      v == null || v.isEmpty ? tr(context).requiredField : null,
                  onChanged: ref
                      .read(driverApplicationFormProvider.notifier)
                      .updateEmail,
                  enabled: !formState.isSubmitting,
                ),
                const SizedBox(height: Sizes.marginV12),
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
                  onChanged: ref
                      .read(driverApplicationFormProvider.notifier)
                      .updatePhone,
                  enabled: !formState.isSubmitting,
                ),
                const SizedBox(height: Sizes.marginV12),
                TextFormField(
                  controller: idNumberController,
                  decoration: InputDecoration(
                    labelText: tr(context).idNumber,
                    prefixIcon: const Icon(Icons.badge),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return tr(context).requiredField;
                    if (v.length != 14) return tr(context).idNumberLengthError;
                    return null;
                  },
                  onChanged: ref
                      .read(driverApplicationFormProvider.notifier)
                      .updateIdNumber,
                  enabled: !formState.isSubmitting,
                ),

                const SizedBox(height: Sizes.marginV24),

                // Vehicle Information Section (Now Position 2 after Personal Info)
                _SectionTitle(title: tr(context).vehicleInfo),
                const SizedBox(height: Sizes.marginV12),
                DropdownButtonFormField<VehicleType>(
                  value: formState.vehicleType,
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
                  onChanged: formState.isSubmitting
                      ? null
                      : (value) {
                          if (value != null) {
                            ref
                                .read(driverApplicationFormProvider.notifier)
                                .updateVehicleType(value);
                          }
                        },
                ),
                const SizedBox(height: Sizes.marginV12),
                TextFormField(
                  controller: vehiclePlateController,
                  decoration: InputDecoration(
                    labelText: tr(context).vehiclePlate,
                    prefixIcon: const Icon(Icons.confirmation_number),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? tr(context).requiredField : null,
                  onChanged: ref
                      .read(driverApplicationFormProvider.notifier)
                      .updateVehiclePlate,
                  enabled: !formState.isSubmitting,
                ),

                const SizedBox(height: Sizes.marginV24),

                // License Information Section (Now Position 3)
                _SectionTitle(title: tr(context).licenseInfo),
                const SizedBox(height: Sizes.marginV12),
                TextFormField(
                  controller: licenseNumberController,
                  decoration: InputDecoration(
                    labelText: tr(context).licenseNumber,
                    prefixIcon: const Icon(Icons.card_membership),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return tr(context).requiredField;
                    if (v.length != 14) return tr(context).licenseNumberLengthError;
                    return null;
                  },
                  onChanged: ref
                      .read(driverApplicationFormProvider.notifier)
                      .updateLicenseNumber,
                  enabled: !formState.isSubmitting,
                ),
                const SizedBox(height: Sizes.marginV12),
                _DatePickerField(
                  label: tr(context).licenseExpiryDate,
                  value: formState.licenseExpiryDate,
                  onChanged: ref
                      .read(driverApplicationFormProvider.notifier)
                      .updateLicenseExpiryDate,
                  enabled: !formState.isSubmitting,
                ),

                const SizedBox(height: Sizes.marginV24),

                // Documents Section
                _SectionTitle(title: tr(context).documents),
                const SizedBox(height: Sizes.marginV12),
                _DocumentUploadField(
                  label: tr(context).personalPhoto,
                  file: formState.photo,
                  onPick: (file) => ref
                      .read(driverApplicationFormProvider.notifier)
                      .updatePhoto(file),
                  enabled: !formState.isSubmitting,
                ),
                _DocumentUploadField(
                  label: tr(context).idDocument,
                  file: formState.idDocument,
                  onPick: (file) => ref
                      .read(driverApplicationFormProvider.notifier)
                      .updateIdDocument(file),
                  enabled: !formState.isSubmitting,
                ),
                _DocumentUploadField(
                  label: tr(context).licenseDocument,
                  file: formState.license,
                  onPick: (file) => ref
                      .read(driverApplicationFormProvider.notifier)
                      .updateLicense(file),
                  enabled: !formState.isSubmitting,
                ),
                _DocumentUploadField(
                  label: tr(context).vehicleRegistration,
                  file: formState.vehicleRegistration,
                  onPick: (file) => ref
                      .read(driverApplicationFormProvider.notifier)
                      .updateVehicleRegistration(file),
                  enabled: !formState.isSubmitting,
                ),
                _DocumentUploadField(
                  label: tr(context).vehicleInsurance,
                  file: formState.vehicleInsurance,
                  onPick: (file) => ref
                      .read(driverApplicationFormProvider.notifier)
                      .updateVehicleInsurance(file),
                  enabled: !formState.isSubmitting,
                ),

                const SizedBox(height: Sizes.marginV24),

                // Notes Section
                _SectionTitle(title: tr(context).additionalNotes),
                const SizedBox(height: Sizes.marginV12),
                TextFormField(
                  controller: notesController,
                  decoration: InputDecoration(
                    labelText: tr(context).notes,
                    prefixIcon: const Icon(Icons.note),
                  ),
                  maxLines: 3,
                  onChanged: ref
                      .read(driverApplicationFormProvider.notifier)
                      .updateNotes,
                  enabled: !formState.isSubmitting,
                ),

                const SizedBox(height: Sizes.marginV32),

                // Submit Button
                CustomElevatedButton(
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.buttonPaddingV14,
                    horizontal: Sizes.buttonPaddingH24,
                  ),
                  onPressed: formState.isSubmitting
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            if (formState.photo == null ||
                                formState.idDocument == null ||
                                formState.license == null ||
                                formState.vehicleRegistration == null ||
                                formState.vehicleInsurance == null) {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              tr(context).attention,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed: () =>
                                                  Navigator.pop(context),
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
                            final applicationId = await ref
                                .read(driverApplicationFormProvider.notifier)
                                .submitApplication(userId);

                            if (applicationId != null && context.mounted) {
                              // Navigate to pending screen
                              context.go('/');
                            }
                          }
                        },
                  child: formState.isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(tr(context).submitApplication),
                ),
                const SizedBox(height: Sizes.marginV16),
              ],
            ),
            ),
            ),
          ),
        ),
      ),
    );
  }

  String _getVehicleTypeName(BuildContext context, VehicleType type) {
    switch (type) {
      case VehicleType.car:
        return tr(context).car;
      case VehicleType.motorcycle:
        return tr(context).motorcycle;
      case VehicleType.bicycle:
        return tr(context).bicycle;
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.enabled,
  });

  final String label;
  final DateTime? value;
  final void Function(DateTime) onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled
          ? () async {
              final date = await showDatePicker(
                context: context,
                initialDate:
                    value ?? DateTime.now().add(const Duration(days: 31)),
                firstDate: DateTime.now().add(const Duration(days: 30)),
                lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
              );
              if (date != null) {
                onChanged(date);
              }
            }
          : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          value != null
              ? '${value!.day}/${value!.month}/${value!.year}'
              : tr(context).selectDate,
          style: TextStyle(
            color: value != null ? null : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _DocumentUploadField extends StatelessWidget {
  const _DocumentUploadField({
    required this.label,
    required this.file,
    required this.onPick,
    required this.enabled,
  });

  final String label;
  final file; // Can be File or XFile
  final void Function(dynamic) onPick;
  final bool enabled;

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
                    file != null ? Icons.check_circle : Icons.upload_file,
                    color: file != null ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: Sizes.marginH8),
                  Expanded(
                    child: Text(
                      file != null ? (file.name ?? file.path.split('/').last) : label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: file != null ? null : Colors.grey,
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
                      onPick(image); // Pass XFile directly
                    }
                  }
                : null,
            icon: const Icon(Icons.add_photo_alternate),
          ),
          if (file != null)
            IconButton(
              onPressed: enabled ? () => onPick(null) : null,
              icon: const Icon(Icons.close, color: Colors.red),
            ),
        ],
      ),
    );
  }
}
