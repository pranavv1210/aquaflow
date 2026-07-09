import 'package:flutter/material.dart';

import '../../core/shared/widgets/app_buttons.dart';
import '../../core/shared/widgets/app_date_picker.dart';
import '../../core/shared/widgets/app_dropdown.dart';
import '../../core/shared/widgets/app_screen.dart';
import '../../core/shared/widgets/app_text_field.dart';
import '../../core/shared/widgets/form_section.dart';
import '../../core/shared/widgets/page_header.dart';
import '../../core/shared/widgets/ui_state_switcher.dart';

class NewOrderPage extends StatelessWidget {
  const NewOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UiStateSwitcher(
      state: UiContentState.populated,
      emptyTitle: 'Order Form Unavailable',
      populated: AppScreen(
        children: <Widget>[
          const PageHeader(title: 'New Order', subtitle: 'Create order UI'),
          FormSection(
            title: 'Customer',
            children: <Widget>[
              AppDropdown<String>(
                label: 'Customer',
                items: const <String>[],
                itemLabel: (String item) => item,
              ),
              const AppTextField(label: 'Location', hintText: '--'),
              const AppTextField(label: 'Water Point', hintText: '--'),
            ],
          ),
          FormSection(
            title: 'Delivery',
            children: <Widget>[
              AppDatePicker(
                label: 'Date',
                selectedDate: null,
                onChanged: (_) {},
              ),
              AppDropdown<String>(
                label: 'Vehicle',
                items: const <String>[],
                itemLabel: (String item) => item,
              ),
              AppDropdown<String>(
                label: 'Driver',
                items: const <String>[],
                itemLabel: (String item) => item,
              ),
              AppDropdown<String>(
                label: 'Partner Tanker',
                items: const <String>[],
                itemLabel: (String item) => item,
              ),
            ],
          ),
          const FormSection(
            title: 'Billing',
            children: <Widget>[
              AppTextField(
                label: 'Load Count',
                hintText: '--',
                keyboardType: TextInputType.number,
              ),
              AppTextField(
                label: 'Amount',
                hintText: '₹--',
                keyboardType: TextInputType.number,
              ),
              AppTextField(label: 'Remarks', hintText: '--', maxLines: 3),
            ],
          ),
          PrimaryButton(
            label: 'Save Order',
            icon: Icons.check_rounded,
            onPressed: () => _showSuccessDialog(context),
          ),
          SecondaryButton(
            label: 'Cancel',
            icon: Icons.close_rounded,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.check_circle_outline_rounded),
          title: const Text('Order UI Ready'),
          content: const Text('Saving will be connected in a later phase.'),
          actions: <Widget>[
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}
