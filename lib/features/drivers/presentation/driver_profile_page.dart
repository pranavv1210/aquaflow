import 'package:flutter/material.dart';

import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/form_section.dart';
import '../../../core/shared/widgets/order_card.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/section_title.dart';
import '../../../core/shared/widgets/ui_state_switcher.dart';

class DriverProfilePage extends StatelessWidget {
  const DriverProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UiStateSwitcher(
      state: UiContentState.populated,
      emptyTitle: 'Driver Not Found',
      populated: AppScreen(
        children: <Widget>[
          PageHeader(title: 'Driver Profile', subtitle: 'Driver --'),
          FormSection(
            title: 'Details',
            children: <Widget>[
              _ProfileLine(label: 'Phone', value: '--'),
              _ProfileLine(label: 'Assigned Vehicle', value: '--'),
              _ProfileLine(label: 'Status', value: '--'),
            ],
          ),
          SectionTitle(title: 'Recent Trips'),
          OrderCard(),
        ],
      ),
    );
  }
}

class _ProfileLine extends StatelessWidget {
  const _ProfileLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[Expanded(child: Text(label)), Text(value)]);
  }
}
