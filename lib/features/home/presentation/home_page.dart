import 'package:flutter/material.dart';

import '../../../core/shared/widgets/empty_state_widget.dart';
import '../../../core/shared/widgets/page_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        PageHeader(title: 'AquaFlow'),
        Expanded(
          child: EmptyStateWidget(
            title: 'Dashboard foundation ready',
            message: 'Operational widgets will connect to Supabase in Phase 1.',
            icon: Icons.dashboard_customize_outlined,
          ),
        ),
      ],
    );
  }
}
