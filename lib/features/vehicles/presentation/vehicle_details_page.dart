import 'package:flutter/material.dart';

import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/form_section.dart';
import '../../../core/shared/widgets/order_card.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/section_title.dart';
import '../../../core/shared/widgets/ui_state_switcher.dart';

class VehicleDetailsPage extends StatelessWidget {
  const VehicleDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UiStateSwitcher(
      state: UiContentState.populated,
      emptyTitle: 'Vehicle Not Found',
      populated: AppScreen(
        children: <Widget>[
          PageHeader(title: 'Vehicle Details', subtitle: 'Vehicle --'),
          FormSection(
            title: 'Vehicle',
            children: <Widget>[
              _VehicleLine(label: 'Registration', value: '--'),
              _VehicleLine(label: 'Capacity', value: '--'),
              _VehicleLine(label: 'Driver', value: '--'),
              _VehicleLine(label: 'Status', value: '--'),
            ],
          ),
          SectionTitle(title: 'Recent Orders'),
          OrderCard(),
        ],
      ),
    );
  }
}

class _VehicleLine extends StatelessWidget {
  const _VehicleLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[Expanded(child: Text(label)), Text(value)]);
  }
}
