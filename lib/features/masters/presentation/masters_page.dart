import 'package:flutter/material.dart';

import '../../../core/shared/widgets/empty_state_widget.dart';
import '../../../core/shared/widgets/page_header.dart';

class MastersPage extends StatelessWidget {
  const MastersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        PageHeader(title: 'Masters'),
        Expanded(
          child: EmptyStateWidget(
            title: 'Master data placeholder',
            message:
                'Customers, drivers, vehicles, and partners live here later.',
            icon: Icons.storage_outlined,
          ),
        ),
      ],
    );
  }
}
