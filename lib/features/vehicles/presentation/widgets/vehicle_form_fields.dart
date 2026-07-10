import 'package:flutter/material.dart';

import '../../../../core/models/domain_enums.dart';
import '../../../../core/shared/widgets/app_text_field.dart';
import '../../../../core/shared/widgets/app_dropdown.dart';
import '../../../../core/shared/widgets/form_section.dart';
import '../../../../core/shared/masters/master_validators.dart';

class VehicleFormFields extends StatelessWidget {
  const VehicleFormFields({
    required this.nameController,
    required this.registrationController,
    required this.vehicleTypeController,
    required this.statusController,
    required this.notesController,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController registrationController;
  final TextEditingController vehicleTypeController;
  final TextEditingController statusController;
  final TextEditingController notesController;

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: 'Basic Details',
      children: <Widget>[
        AppTextField(
          label: 'Vehicle Name',
          hintText: 'Required',
          controller: nameController,
          textInputAction: TextInputAction.next,
          validator: (String? value) {
            return MasterValidators.requiredText(
              value,
              fieldName: 'Vehicle name',
            );
          },
        ),
        AppTextField(
          label: 'Registration Number',
          hintText: 'Required',
          controller: registrationController,
          textInputAction: TextInputAction.next,
          validator: (String? value) {
            return MasterValidators.requiredText(
              value,
              fieldName: 'Registration number',
            );
          },
        ),
        AppDropdown<VehicleType>(
          label: 'Vehicle Type',
          value: _vehicleTypeValue,
          items: VehicleType.values,
          itemLabel: _vehicleTypeLabel,
          onChanged: (VehicleType? value) {
            vehicleTypeController.text = value?.name ?? '';
          },
        ),
        AppDropdown<VehicleStatus>(
          label: 'Status',
          value: _statusValue,
          items: VehicleStatus.values,
          itemLabel: _statusLabel,
          onChanged: (VehicleStatus? value) {
            statusController.text = value?.name ?? '';
          },
        ),
        AppTextField(
          label: 'Notes',
          hintText: 'Optional',
          controller: notesController,
          maxLines: 3,
        ),
      ],
    );
  }

  VehicleType? get _vehicleTypeValue {
    return VehicleType.values.cast<VehicleType?>().firstWhere(
      (VehicleType? type) => type?.name == vehicleTypeController.text,
      orElse: () => null,
    );
  }

  VehicleStatus? get _statusValue {
    return VehicleStatus.values.cast<VehicleStatus?>().firstWhere(
      (VehicleStatus? status) => status?.name == statusController.text,
      orElse: () => null,
    );
  }

  String _vehicleTypeLabel(VehicleType type) {
    return switch (type) {
      VehicleType.tractor => 'Tractor',
      VehicleType.canter => 'Canter',
      VehicleType.partner => 'Partner',
    };
  }

  String _statusLabel(VehicleStatus status) {
    return switch (status) {
      VehicleStatus.available => 'Available',
      VehicleStatus.busy => 'Busy',
      VehicleStatus.inactive => 'Inactive',
    };
  }
}
