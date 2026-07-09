import 'package:flutter/material.dart';

import '../../../core/shared/widgets/empty_state_widget.dart';
import '../../../core/shared/widgets/page_header.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        PageHeader(title: 'Analytics'),
        Expanded(
          child: EmptyStateWidget(
            title: 'Analytics placeholder',
            message: 'All analytics will be calculated from Supabase data.',
            icon: Icons.query_stats_outlined,
          ),
        ),
      ],
    );
  }
}
