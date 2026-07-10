import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/helpers/app_formatters.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/aqua_filter_chip.dart';
import '../../../core/shared/widgets/dashboard_card.dart';
import '../../../core/shared/widgets/error_state_widget.dart';
import '../../../core/shared/widgets/metric_charts.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/skeleton_loader.dart';
import '../../../core/theme/app_spacing.dart';
import '../../expenses/application/expense_providers.dart';
import '../../orders/application/order_providers.dart';
import '../application/analytics_providers.dart';
import '../application/business_metrics.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(orderRealtimeProvider, (_, next) {
      if (next.hasValue) {
        ref.invalidate(orderListProvider);
        invalidateBusinessMetrics(ref);
      }
    });
    ref.listen(expenseRealtimeProvider, (_, next) {
      if (next.hasValue) {
        ref.invalidate(expenseListProvider);
        invalidateBusinessMetrics(ref);
      }
    });

    final metrics = ref.watch(analyticsMetricsProvider);
    return metrics.when(
      loading:
          () => const AppScreen(
            children: <Widget>[
              PageHeader(title: 'Analytics', subtitle: 'Loading...'),
              SkeletonLoader(height: 180),
              SkeletonLoader(height: 220),
              SkeletonLoader(height: 220),
            ],
          ),
      error:
          (Object error, StackTrace stackTrace) => AppScreen(
            children: <Widget>[
              const PageHeader(title: 'Analytics', subtitle: 'Error'),
              ErrorStateWidget(
                title: 'Unable to load analytics',
                message: error.toString(),
                onRetry: () => ref.invalidate(analyticsMetricsProvider),
              ),
            ],
          ),
      data: (AnalyticsMetrics data) {
        final todayProfit =
            data.dailyProfit.isEmpty ? 0 : data.dailyProfit.last.value;
        final monthlyProfit =
            data.monthlyProfit.isEmpty ? 0 : data.monthlyProfit.last.value;
        final dailyRevenue =
            data.dailyRevenue.isEmpty ? 0 : data.dailyRevenue.last.value;
        final dailyExpenses =
            data.dailyExpenses.isEmpty ? 0 : data.dailyExpenses.last.value;
        final monthlyRevenue =
            data.monthlyRevenue.isEmpty ? 0 : data.monthlyRevenue.last.value;
        final monthlyExpenses =
            data.monthlyExpenses.isEmpty ? 0 : data.monthlyExpenses.last.value;
        return AppScreen(
          children: <Widget>[
            PageHeader(
              title: 'Analytics',
              subtitle: 'Database-backed insights',
              trailing: IconButton.filledTonal(
                onPressed: () => ref.invalidate(analyticsMetricsProvider),
                icon: const Icon(Icons.refresh_rounded),
              ),
            ),
            const AquaFilterChipBar(
              labels: <String>['Today', 'This Month', 'Last 6 Months'],
              selectedIndex: 2,
            ),
            _SummaryGrid(
              dailyRevenue: dailyRevenue,
              monthlyRevenue: monthlyRevenue,
              dailyExpenses: dailyExpenses,
              monthlyExpenses: monthlyExpenses,
              todayProfit: todayProfit,
              monthlyProfit: monthlyProfit,
              pendingCollections: data.pendingCollections,
              orders: data.orders,
            ),
            LineMetricChart(
              title: 'Revenue Trend',
              points: data.dailyRevenue,
              icon: Icons.show_chart_rounded,
            ),
            LineMetricChart(
              title: 'Expense Trend',
              points: data.dailyExpenses,
              icon: Icons.trending_down_rounded,
            ),
            LineMetricChart(
              title: 'Profit Trend',
              points: data.dailyProfit,
              icon: Icons.trending_up_rounded,
            ),
            BarMetricChart(
              title: 'Revenue by Vehicle',
              items: data.vehicleRevenue,
              icon: Icons.local_shipping_outlined,
            ),
            BarMetricChart(
              title: 'Revenue by Driver',
              items: data.driverRevenue,
              icon: Icons.badge_outlined,
            ),
            BarMetricChart(
              title: 'Revenue by Customer',
              items: data.customerRevenue,
              icon: Icons.people_outline_rounded,
            ),
            BarMetricChart(
              title: 'Top Customers',
              items: data.customerRevenue.take(5).toList(growable: false),
              icon: Icons.star_outline_rounded,
            ),
            BarMetricChart(
              title: 'Top Vehicles',
              items: data.vehicleRevenue.take(5).toList(growable: false),
              icon: Icons.emoji_transportation_rounded,
            ),
            BarMetricChart(
              title: 'Top Drivers',
              items: data.driverRevenue.take(5).toList(growable: false),
              icon: Icons.workspace_premium_outlined,
            ),
            DonutMetricChart(
              title: 'Expense Category Pie Chart',
              items: data.expenseBreakdown,
              icon: Icons.pie_chart_outline_rounded,
              currency: true,
            ),
            DonutMetricChart(
              title: 'Payment Status Doughnut',
              items: data.paymentStatusSummary,
              icon: Icons.donut_large_rounded,
            ),
            BarMetricChart(
              title: 'Delivery Status',
              items: data.deliveryStatusSummary,
              icon: Icons.route_outlined,
              currency: false,
            ),
            BarMetricChart(
              title: 'Expense Breakdown',
              items: data.expenseBreakdown,
              icon: Icons.category_outlined,
            ),
          ],
        );
      },
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({
    required this.dailyRevenue,
    required this.monthlyRevenue,
    required this.dailyExpenses,
    required this.monthlyExpenses,
    required this.todayProfit,
    required this.monthlyProfit,
    required this.pendingCollections,
    required this.orders,
  });

  final num dailyRevenue;
  final num monthlyRevenue;
  final num dailyExpenses;
  final num monthlyExpenses;
  final num todayProfit;
  final num monthlyProfit;
  final num pendingCollections;
  final int orders;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final isWide = constraints.maxWidth > 560;
        return GridView.count(
          crossAxisCount: isWide ? 4 : 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: isWide ? 1.45 : 1.08,
          children: <Widget>[
            DashboardCard(
              title: 'Daily Revenue',
              value: AppFormatters.currency(dailyRevenue),
              icon: Icons.currency_rupee_rounded,
            ),
            DashboardCard(
              title: 'Monthly Revenue',
              value: AppFormatters.currency(monthlyRevenue),
              icon: Icons.calendar_month_rounded,
            ),
            DashboardCard(
              title: 'Daily Expenses',
              value: AppFormatters.currency(dailyExpenses),
              icon: Icons.receipt_long_outlined,
            ),
            DashboardCard(
              title: 'Monthly Expenses',
              value: AppFormatters.currency(monthlyExpenses),
              icon: Icons.payments_outlined,
            ),
            DashboardCard(
              title: "Today's Profit",
              value: AppFormatters.currency(todayProfit),
              icon: Icons.trending_up_rounded,
            ),
            DashboardCard(
              title: 'Monthly Profit',
              value: AppFormatters.currency(monthlyProfit),
              icon: Icons.insights_rounded,
            ),
            DashboardCard(
              title: 'Pending Collections',
              value: AppFormatters.currency(pendingCollections),
              icon: Icons.pending_actions_rounded,
            ),
            DashboardCard(
              title: 'Orders',
              value: orders.toString(),
              icon: Icons.receipt_long_outlined,
            ),
          ],
        );
      },
    );
  }
}
