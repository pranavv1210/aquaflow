import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/app_text_field.dart';
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
            return MasterValidators.requiredText(value, fieldName: 'Vehicle name');
          },
        ),
        AppTextField(
          label: 'Registration Number',
          hintText: 'Required',
          controller: registrationController,
          textInputAction: TextInputAction.next,
          validator: (String? value) {
            return MasterValidators.requiredText(value, fieldName: 'Registration number');
          },
        ),
        AppTextField(
          label: 'Vehicle Type',
          hintText: 'e.g. tractor, canter, partner',
          controller: vehicleTypeController,
          textInputAction: TextInputAction.next,
          validator: (String? value) {
            return MasterValidators.requiredText(value, fieldName: 'Vehicle type');
          },
        ),
        AppTextField(
          label: 'Status',
          hintText: 'e.g. available, busy, inactive',
          controller: statusController,
          textInputAction: TextInputAction.next,
          validator: (String? value) {
            return MasterValidators.requiredText(value, fieldName: 'Status');
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
}
