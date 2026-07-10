import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/app_text_field.dart';
import '../../../../core/shared/widgets/form_section.dart';
import '../../../../core/shared/masters/master_validators.dart';

class LocationFormFields extends StatelessWidget {
  const LocationFormFields({required this.nameController, required this.notesController, super.key});
  final TextEditingController nameController; final TextEditingController notesController;
  @override
  Widget build(BuildContext context) => FormSection(title: 'Basic Details', children: [
    AppTextField(label: 'Location Name', hintText: 'Required', controller: nameController, textInputAction: TextInputAction.next, validator: (v) => MasterValidators.requiredText(v, fieldName: 'Location name')),
    AppTextField(label: 'Notes', hintText: 'Optional', controller: notesController, maxLines: 3),
  ]);
}
