import 'package:flutter/material.dart';

import '../../core/shared/widgets/empty_state_widget.dart';
import '../../core/shared/widgets/page_header.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        PageHeader(title: 'Orders'),
        Expanded(
          child: EmptyStateWidget(
            title: 'Orders module placeholder',
            message: 'Order entry and searchable master data arrive later.',
            icon: Icons.receipt_long_outlined,
          ),
        ),
      ],
    );
  }
}
