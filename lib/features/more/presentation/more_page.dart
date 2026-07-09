import 'package:flutter/material.dart';

import '../../../core/shared/widgets/empty_state_widget.dart';
import '../../../core/shared/widgets/page_header.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        PageHeader(title: 'More'),
        Expanded(
          child: EmptyStateWidget(
            title: 'Settings foundation ready',
            message:
                'Preferences and configuration screens will be added later.',
            icon: Icons.tune_outlined,
          ),
        ),
      ],
    );
  }
}
