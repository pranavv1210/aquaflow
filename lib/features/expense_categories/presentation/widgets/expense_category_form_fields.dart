import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/app_text_field.dart';
import '../../../../core/shared/widgets/form_section.dart';
import '../../../../core/shared/masters/master_validators.dart';

class ExpenseCategoryFormFields extends StatelessWidget {
  const ExpenseCategoryFormFields({
    required this.nameController,
    required this.typeController,
    required this.descriptionController,
    super.key,
  });
  final TextEditingController nameController;
  final TextEditingController typeController;
  final TextEditingController descriptionController;
  @override
  Widget build(BuildContext context) => FormSection(
    title: 'Basic Details',
    children: [
      AppTextField(
        label: 'Category Name',
        hintText: 'Required',
        controller: nameController,
        textInputAction: TextInputAction.next,
        validator:
            (v) => MasterValidators.requiredText(v, fieldName: 'Category name'),
      ),
      AppTextField(
        label: 'Expense Type',
        hintText: 'e.g. diesel, service, repair',
        controller: typeController,
        textInputAction: TextInputAction.next,
        validator:
            (v) => MasterValidators.requiredText(v, fieldName: 'Expense type'),
      ),
      AppTextField(
        label: 'Description',
        hintText: 'Optional',
        controller: descriptionController,
        maxLines: 3,
      ),
    ],
  );
}
