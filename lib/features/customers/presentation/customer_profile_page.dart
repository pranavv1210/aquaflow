import 'package:flutter/material.dart';

import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/dashboard_card.dart';
import '../../../core/shared/widgets/glass_card.dart';
import '../../../core/shared/widgets/order_card.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/section_title.dart';
import '../../../core/shared/widgets/ui_state_switcher.dart';
import '../../../core/theme/app_spacing.dart';

class CustomerProfilePage extends StatelessWidget {
  const CustomerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return UiStateSwitcher(
      state: UiContentState.populated,
      emptyTitle: 'Customer Not Found',
      populated: AppScreen(
        children: <Widget>[
          const PageHeader(title: 'Customer Profile', subtitle: 'Customer --'),
          const GlassCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(child: Icon(Icons.person_outline_rounded)),
              title: Text('Customer --'),
              subtitle: Text('Location --'),
            ),
          ),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final isWide = constraints.maxWidth > 560;
              return GridView.count(
                crossAxisCount: isWide ? 3 : 1,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: isWide ? 1.8 : 2.8,
                children: const <Widget>[
                  DashboardCard(
                    title: 'Revenue',
                    value: '₹--',
                    icon: Icons.currency_rupee_rounded,
                  ),
                  DashboardCard(
                    title: 'Pending Payment',
                    value: '₹--',
                    icon: Icons.pending_actions_rounded,
                  ),
                  DashboardCard(
                    title: 'Total Orders',
                    value: '--',
                    icon: Icons.receipt_long_outlined,
                  ),
                ],
              );
            },
          ),
          const SectionTitle(title: 'History'),
          const OrderCard(),
        ],
      ),
    );
  }
}
