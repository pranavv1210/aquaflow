import 'package:flutter/material.dart';

import '../../helpers/app_formatters.dart';
import 'app_text_field.dart';

class AppDatePicker extends StatelessWidget {
  const AppDatePicker({
    required this.label,
    required this.selectedDate,
    required this.onChanged,
    super.key,
    this.firstDate,
    this.lastDate,
  });

  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      readOnly: true,
      prefixIcon: Icons.calendar_today_rounded,
      controller: TextEditingController(
        text: selectedDate == null ? '' : AppFormatters.date(selectedDate!),
      ),
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? now,
          firstDate: firstDate ?? DateTime(now.year - 5),
          lastDate: lastDate ?? DateTime(now.year + 5),
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
    );
  }
}
