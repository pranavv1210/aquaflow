import 'package:flutter/material.dart';

import '../../../core/shared/widgets/app_buttons.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/app_text_field.dart';
import '../../../core/shared/widgets/form_section.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/ui_state_switcher.dart';

class CustomerFormPage extends StatelessWidget {
  const CustomerFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UiStateSwitcher(
      state: UiContentState.populated,
      emptyTitle: 'Customer Form Unavailable',
      populated: AppScreen(
        children: <Widget>[
          const PageHeader(title: 'Add Customer', subtitle: 'Form UI only'),
          const FormSection(
            title: 'Basic Details',
            children: <Widget>[
              AppTextField(label: 'Customer Name', hintText: '--'),
              AppTextField(label: 'Phone', hintText: '--'),
              AppTextField(label: 'Location', hintText: '--'),
              AppTextField(label: 'Water Point', hintText: '--'),
              AppTextField(label: 'Notes', hintText: '--', maxLines: 3),
            ],
          ),
          PrimaryButton(
            label: 'Save Customer',
            icon: Icons.check_rounded,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
