import 'package:flutter/material.dart';
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
    final formState = ref.watch(driverApplicationFormProvider);

    return FullScreenScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Sizes.marginH20),
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
                if (formState.error != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: Sizes.marginV16),
                    padding: const EdgeInsets.all(Sizes.marginV12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      formState.error!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),

                // Personal Information Section
                _SectionTitle(title: tr(context).personalInfo),
                const SizedBox(height: Sizes.marginV12),
                TextFormField(
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
                  decoration: InputDecoration(
                    labelText: tr(context).phone,
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      v == null || v.isEmpty ? tr(context).requiredField : null,
                  onChanged: ref
                      .read(driverApplicationFormProvider.notifier)
                      .updatePhone,
                  enabled: !formState.isSubmitting,
                ),
                const SizedBox(height: Sizes.marginV12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: tr(context).idNumber,
                    prefixIcon: const Icon(Icons.badge),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? tr(context).requiredField : null,
                  onChanged: ref
                      .read(driverApplicationFormProvider.notifier)
                      .updateIdNumber,
                  enabled: !formState.isSubmitting,
                ),

                const SizedBox(height: Sizes.marginV24),

                // License Information Section
                _SectionTitle(title: tr(context).licenseInfo),
                const SizedBox(height: Sizes.marginV12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: tr(context).licenseNumber,
                    prefixIcon: const Icon(Icons.card_membership),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? tr(context).requiredField : null,
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

                // Vehicle Information Section
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
                  onPressed: formState.isSubmitting
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
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
                    value ?? DateTime.now().add(const Duration(days: 30)),
                firstDate: DateTime.now(),
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
