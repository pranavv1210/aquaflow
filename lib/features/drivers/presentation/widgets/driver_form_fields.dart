import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/app_text_field.dart';
import '../../../../core/shared/widgets/form_section.dart';
import '../../../../core/shared/masters/master_validators.dart';

class DriverFormFields extends StatelessWidget {
  const DriverFormFields({
    required this.nameController,
    required this.phoneController,
    required this.notesController,
    required this.statusController,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController notesController;
  final TextEditingController statusController;

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: 'Basic Details',
      children: <Widget>[
        AppTextField(
          label: 'Driver Name',
          hintText: 'Required',
          controller: nameController,
          textInputAction: TextInputAction.next,
          validator: (String? value) {
            return MasterValidators.requiredText(
              value,
              fieldName: 'Driver name',
            );
          },
        ),
        AppTextField(
          label: 'Phone',
          hintText: 'Optional',
          controller: phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          validator: MasterValidators.optionalPhone,
        ),
        AppTextField(
          label: 'Status',
          hintText: 'e.g. available, busy, inactive',
          controller: statusController,
          textInputAction: TextInputAction.next,
          validator: (String? value) {
            return MasterValidators.requiredText(
              value,
              fieldName: 'Status',
            );
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