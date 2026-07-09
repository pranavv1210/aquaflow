import 'package:flutter/material.dart';

import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/aqua_filter_chip.dart';
import '../../../core/shared/widgets/chart_placeholder.dart';
import '../../../core/shared/widgets/dashboard_card.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/ui_state_switcher.dart';
import '../../../core/theme/app_spacing.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: UiStateSwitcher(
        state: UiContentState.populated,
        emptyTitle: 'No Analytics Yet',
        emptyMessage: 'Analytics will be calculated from Supabase data.',
        emptyIcon: Icons.query_stats_outlined,
        populated: AppScreen(
          children: <Widget>[
            PageHeader(
              title: 'Analytics',
              subtitle: 'Database-backed insights',
              trailing: IconButton.filledTonal(
                onPressed: () {},
                icon: const Icon(Icons.calendar_month_rounded),
              ),
            ),
            const AquaFilterChipBar(
              labels: <String>['Today', 'This Week', 'This Month', 'Custom'],
              selectedIndex: 2,
            ),
            const TabBar(
              tabs: <Widget>[
                Tab(text: 'Revenue'),
                Tab(text: 'Orders'),
                Tab(text: 'Vehicles'),
              ],
            ),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final isWide = constraints.maxWidth > 560;
                return GridView.count(
                  crossAxisCount: isWide ? 4 : 2,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: isWide ? 1.45 : 1.18,
                  children: const <Widget>[
                    DashboardCard(
                      title: 'Revenue',
                      value: '₹--',
                      icon: Icons.currency_rupee_rounded,
                    ),
                    DashboardCard(
                      title: 'Orders',
                      value: '--',
                      icon: Icons.receipt_long_outlined,
                    ),
                    DashboardCard(
                      title: 'Loads',
                      value: '--',
                      icon: Icons.water_drop_outlined,
                    ),
                    DashboardCard(
                      title: 'Pending',
                      value: '₹--',
                      icon: Icons.pending_actions_rounded,
                    ),
                  ],
                );
              },
            ),
            const ChartPlaceholder(
              title: 'Revenue Trend',
              icon: Icons.show_chart_rounded,
            ),
            const ChartPlaceholder(
              title: 'Order Volume',
              icon: Icons.bar_chart_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
