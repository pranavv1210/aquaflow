import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/app_text_field.dart';
import '../../../../core/shared/widgets/form_section.dart';
import '../../../../core/shared/masters/master_validators.dart';

class WaterPointFormFields extends StatelessWidget {
  const WaterPointFormFields({required this.nameController, required this.locationController, required this.notesController, super.key});
  final TextEditingController nameController; final TextEditingController locationController; final TextEditingController notesController;
  @override
  Widget build(BuildContext context) => FormSection(title: 'Basic Details', children: [
    AppTextField(label: 'Water Point Name', hintText: 'Required', controller: nameController, textInputAction: TextInputAction.next, validator: (v) => MasterValidators.requiredText(v, fieldName: 'Water point name')),
    AppTextField(label: 'Location ID', hintText: 'Optional', controller: locationController, textInputAction: TextInputAction.next),
    AppTextField(label: 'Notes', hintText: 'Optional', controller: notesController, maxLines: 3),
  ]);
}
