import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/app_text_field.dart';
import '../../../../core/shared/widgets/form_section.dart';
import '../../../../core/shared/masters/master_validators.dart';

class PartnerTankerFormFields extends StatelessWidget {
  const PartnerTankerFormFields({required this.ownerController, required this.vehicleController, required this.registrationController, required this.phoneController, required this.notesController, super.key});
  final TextEditingController ownerController; final TextEditingController vehicleController; final TextEditingController registrationController; final TextEditingController phoneController; final TextEditingController notesController;
  @override
  Widget build(BuildContext context) => FormSection(title: 'Basic Details', children: [
    AppTextField(label: 'Owner Name', hintText: 'Required', controller: ownerController, textInputAction: TextInputAction.next, validator: (v) => MasterValidators.requiredText(v, fieldName: 'Owner name')),
    AppTextField(label: 'Vehicle Name', hintText: 'Required', controller: vehicleController, textInputAction: TextInputAction.next, validator: (v) => MasterValidators.requiredText(v, fieldName: 'Vehicle name')),
    AppTextField(label: 'Registration Number', hintText: 'Required', controller: registrationController, textInputAction: TextInputAction.next, validator: (v) => MasterValidators.requiredText(v, fieldName: 'Registration number')),
    AppTextField(label: 'Phone', hintText: 'Optional', controller: phoneController, keyboardType: TextInputType.phone, textInputAction: TextInputAction.next, validator: MasterValidators.optionalPhone),
    AppTextField(label: 'Notes', hintText: 'Optional', controller: notesController, maxLines: 3),
  ]);
}
