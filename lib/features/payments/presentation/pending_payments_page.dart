import 'package:flutter/material.dart';

import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/order_card.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/search_field.dart';
import '../../../core/shared/widgets/ui_state_switcher.dart';

class PendingPaymentsPage extends StatelessWidget {
  const PendingPaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UiStateSwitcher(
      state: UiContentState.populated,
      emptyTitle: 'No Pending Payments',
      emptyMessage: 'Open payments will appear here.',
      emptyIcon: Icons.account_balance_wallet_outlined,
      populated: AppScreen(
        children: <Widget>[
          PageHeader(title: 'Pending Payments', subtitle: 'Payment follow-up'),
          SearchField(label: 'Search payments'),
          OrderCard(),
          OrderCard(),
        ],
      ),
    );
  }
}
