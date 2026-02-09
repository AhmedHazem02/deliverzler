import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/domain/value_validators.dart';
import '../../../../core/presentation/helpers/localization_helper.dart';
import '../../../../core/presentation/styles/styles.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../core/presentation/widgets/custom_elevated_button.dart';
import '../../../../core/presentation/widgets/loading_widgets.dart';
import '../../../../core/presentation/widgets/toasts.dart';
import '../../../driver_application/domain/driver_application.dart';
import '../providers/edit_driver_profile_provider.dart';
import '../widgets/titled_text_field_item.dart';

class EditDriverProfileFormComponent extends HookConsumerWidget {
  const EditDriverProfileFormComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editDriverProfileProvider);

    // Load application data on first build
    useEffect(
      () {
        Future.microtask(() {
          ref.read(editDriverProfileProvider.notifier).loadApplication();
        });
        return null;
      },
      [],
    );

    // Listen for success/error
    ref.listen(editDriverProfileProvider, (prev, next) {
      if (next.savedSuccessfully) {
        Toasts.showTitledToast(
          context,
          title: tr(context).confirm,
          description: tr(context).dataUpdatedSuccessfully,
        );
        ref.read(editDriverProfileProvider.notifier).clearSuccess();
      }
      if (next.error != null) {
        Toasts.showTitledToast(
          context,
          title: tr(context).ops_err,
          description: next.error!,
        );
      }
    });

    if (state.isLoading) {
      return const Center(child: DeliveryLoadingAnimation());
    }

    if (state.application == null) {
      return Center(
        child: Text(
          tr(context).noApplicationFound,
          style: TextStyles.f18(context),
        ),
      );
    }

    return _EditForm(application: state.application!);
  }
}

class _EditForm extends HookConsumerWidget {
  const _EditForm({required this.application});

  final DriverApplication application;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editDriverProfileProvider);
    final formKey = useMemoized(GlobalKey<FormState>.new);

    // Controllers
    final nameController = useTextEditingController(text: application.name);
    final phoneController = useTextEditingController(text: application.phone);
    final idNumberController =
        useTextEditingController(text: application.idNumber);
    final licenseNumberController =
        useTextEditingController(text: application.licenseNumber);
    final vehiclePlateController =
        useTextEditingController(text: application.vehiclePlate);
    final notesController =
        useTextEditingController(text: application.notes ?? '');

    // State for license expiry date
    final licenseExpiryDate = useState<DateTime>(application.licenseExpiryDate);

    // State for vehicle type
    final vehicleType = useState<VehicleType>(application.vehicleType);

    Future<void> selectDate() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: licenseExpiryDate.value,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      );
      if (picked != null) {
        licenseExpiryDate.value = picked;
      }
    }

    void saveProfile() {
      if (formKey.currentState!.validate()) {
        ref.read(editDriverProfileProvider.notifier).updateProfile(
              name: nameController.text,
              phone: phoneController.text,
              idNumber: idNumberController.text,
              licenseNumber: licenseNumberController.text,
              licenseExpiryDate: licenseExpiryDate.value,
              vehicleType: vehicleType.value,
              vehiclePlate: vehiclePlateController.text,
              notes: notesController.text.isEmpty ? null : notesController.text,
            );
      }
    }

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.screenPaddingV20,
            horizontal: Sizes.screenPaddingH36,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section: Personal Info
              _SectionHeader(title: tr(context).personalInfo),
              const SizedBox(height: Sizes.marginV16),

              TitledTextFieldItem(
                controller: nameController,
                title: tr(context).fullName,
                hintText: tr(context).enterYourName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr(context).requiredField;
                  }
                  return null;
                },
              ),
              const SizedBox(height: Sizes.marginV16),

              TitledTextFieldItem(
                controller: phoneController,
                title: tr(context).mobileNumber,
                hintText: tr(context).enterYourNumber,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr(context).requiredField;
                  }
                  return null;
                },
              ),
              const SizedBox(height: Sizes.marginV16),

              TitledTextFieldItem(
                controller: idNumberController,
                title: tr(context).idNumber,
                hintText: tr(context).idNumber,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr(context).requiredField;
                  }
                  return null;
                },
              ),
              const SizedBox(height: Sizes.marginV28),

              // Section: License Info
              _SectionHeader(title: tr(context).licenseInfo),
              const SizedBox(height: Sizes.marginV16),

              TitledTextFieldItem(
                controller: licenseNumberController,
                title: tr(context).licenseNumber,
                hintText: tr(context).licenseNumber,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr(context).requiredField;
                  }
                  return null;
                },
              ),
              const SizedBox(height: Sizes.marginV16),

              // License Expiry Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: Sizes.paddingH4,
                      bottom: Sizes.paddingV8,
                    ),
                    child: Text(
                      tr(context).licenseExpiryDate,
                      style: TextStyles.f16(context),
                    ),
                  ),
                  InkWell(
                    onTap: selectDate,
                    borderRadius: BorderRadius.circular(Sizes.cardR12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.paddingH14,
                        vertical: Sizes.paddingV14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(Sizes.cardR12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('yyyy/MM/dd')
                                .format(licenseExpiryDate.value),
                            style: TextStyles.f16(context),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Sizes.marginV28),

              // Section: Vehicle Info
              _SectionHeader(title: tr(context).vehicleInfo),
              const SizedBox(height: Sizes.marginV16),

              // Vehicle Type Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: Sizes.paddingH4,
                      bottom: Sizes.paddingV8,
                    ),
                    child: Text(
                      tr(context).vehicleType,
                      style: TextStyles.f16(context),
                    ),
                  ),
                  DropdownButtonFormField<VehicleType>(
                    initialValue: vehicleType.value,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Sizes.cardR12),
                      ),
                    ),
                    items: VehicleType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(_getVehicleTypeName(context, type)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        vehicleType.value = value;
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: Sizes.marginV16),

              TitledTextFieldItem(
                controller: vehiclePlateController,
                title: tr(context).vehiclePlate,
                hintText: tr(context).vehiclePlate,
                validator: ValueValidators.validateVehiclePlate(
                  context,
                  isMotorcycle: vehicleType.value == VehicleType.motorcycle,
                ),
              ),
              const SizedBox(height: Sizes.marginV28),

              // Section: Additional Notes
              _SectionHeader(title: tr(context).additionalNotes),
              const SizedBox(height: Sizes.marginV16),

              TitledTextFieldItem(
                controller: notesController,
                title: tr(context).notes,
                hintText: tr(context).typeYourNote,
                textInputAction: TextInputAction.done,
                validator: (_) => null,
              ),
              const SizedBox(height: Sizes.marginV40),

              // Save Button
              Center(
                child: CustomElevatedButton(
                  enableGradient: true,
                  onPressed: state.isSaving ? null : saveProfile,
                  child: state.isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          tr(context).confirm,
                          style: TextStyles.coloredElevatedButton(context),
                        ),
                ),
              ),
              const SizedBox(height: Sizes.marginV20),
            ],
          ),
        ),
      ),
    );
  }

  String _getVehicleTypeName(BuildContext context, VehicleType type) {
    return switch (type) {
      VehicleType.car => tr(context).car,
      VehicleType.motorcycle => tr(context).motorcycle,
    };
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.f18SemiBold(context).copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: Sizes.marginV8),
        Divider(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ],
    );
  }
}
