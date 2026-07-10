import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/app_text_field.dart';
import '../../../../core/shared/widgets/form_section.dart';
import '../../../../core/shared/masters/master_validators.dart';

class CustomerFormFields extends StatelessWidget {
  const CustomerFormFields({
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.locationController,
    required this.notesController,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController locationController;
  final TextEditingController notesController;

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: 'Basic Details',
      children: <Widget>[
        AppTextField(
          label: 'Customer Name',
          hintText: 'Required',
          controller: nameController,
          textInputAction: TextInputAction.next,
          validator: (String? value) {
            return MasterValidators.requiredText(
              value,
              fieldName: 'Customer name',
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
          label: 'Address',
          hintText: 'Optional',
          controller: addressController,
          textInputAction: TextInputAction.next,
        ),
        AppTextField(
          label: 'Default Location',
          hintText: 'Location linking arrives in a later phase',
          controller: locationController,
          readOnly: true,
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
