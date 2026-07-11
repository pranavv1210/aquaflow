import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/helpers/app_formatters.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/shared/widgets/action_tile.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/dashboard_card.dart';
import '../../../core/shared/widgets/empty_state_widget.dart';
import '../../../core/shared/widgets/error_state_widget.dart';
import '../../../core/shared/widgets/glass_card.dart';
import '../../../core/shared/widgets/order_card.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/section_title.dart';
import '../../../core/shared/widgets/skeleton_loader.dart';
import '../../../core/shared/widgets/status_chip.dart';
import '../../../core/shared/widgets/timed_loading_view.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../analytics/application/analytics_providers.dart';
import '../../analytics/application/business_metrics.dart';
import '../../expenses/application/expense_providers.dart';
import '../../orders/application/order_providers.dart';
import '../../orders/domain/order_record.dart';
import '../../vehicles/application/vehicle_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _listenForRealtime(ref);
    final metrics = ref.watch(dashboardMetricsProvider);
    return metrics.when(
      loading:
          () => AppScreen(
            children: <Widget>[
              PageHeader(title: _greeting(), subtitle: "Today's Business"),
              TimedLoadingView(
                onRetry: () => ref.invalidate(dashboardMetricsProvider),
                loading: const Column(
                  children: <Widget>[
                    SkeletonLoader(height: 220),
                    SizedBox(height: AppSpacing.md),
                    SkeletonLoader(height: 180),
                    SizedBox(height: AppSpacing.md),
                    SkeletonLoader(height: 140),
                  ],
                ),
              ),
            ],
          ),
      error:
          (Object error, StackTrace stackTrace) => AppScreen(
            children: <Widget>[
              PageHeader(
                title: _greeting(),
                subtitle: "Today's Business",
                trailing: IconButton.filledTonal(
                  onPressed: () => context.go(AppRoutes.globalSearch),
                  icon: const Icon(Icons.search_rounded),
                ),
              ),
              ErrorStateWidget(
                title: 'Unable to load dashboard',
                message: error.toString(),
                onRetry: () => ref.invalidate(dashboardMetricsProvider),
              ),
            ],
          ),
      data: (DashboardMetrics data) {
        return AppScreen(
          children: <Widget>[
            PageHeader(
              title: _greeting(),
              subtitle: "Today's Business",
              trailing: IconButton.filledTonal(
                onPressed: () => context.go(AppRoutes.globalSearch),
                icon: const Icon(Icons.search_rounded),
              ),
            ),
            _DashboardGrid(metrics: data),
            const SectionTitle(title: 'Quick Actions'),
            GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: <Widget>[
                  ActionTile(
                    title: 'New Order',
                    subtitle: 'Create a tanker delivery entry',
                    icon: Icons.add_circle_outline_rounded,
                    onTap: () => context.go(AppRoutes.newOrder),
                  ),
                  ActionTile(
                    title: 'New Expense',
                    subtitle: 'Record vehicle or business spending',
                    icon: Icons.receipt_long_outlined,
                    onTap: () => context.go(AppRoutes.expenseForm),
                  ),
                  ActionTile(
                    title: 'Customers',
                    subtitle: 'Open customer master',
                    icon: Icons.people_outline_rounded,
                    onTap: () => context.go(AppRoutes.customers),
                  ),
                  ActionTile(
                    title: 'Pending Payments',
                    subtitle: 'Review open payment items',
                    icon: Icons.account_balance_wallet_outlined,
                    onTap: () => context.go(AppRoutes.pendingPayments),
                  ),
                ],
              ),
            ),
            const SectionTitle(title: 'Recent Orders'),
            if (data.recentOrders.isEmpty)
              const EmptyStateWidget(
                title: 'No Orders Yet',
                message: 'Recent orders will appear here.',
                icon: Icons.receipt_long_outlined,
              )
            else
              ...data.recentOrders.map(
                (OrderRecord order) => OrderCard(
                  orderNumber: order.orderNumber,
                  customerName: order.customerName,
                  locationName: order.locationName,
                  vehicleName: order.vehicleName,
                  driverName: order.driverName,
                  amount: AppFormatters.currency(order.amount),
                  pendingAmount: AppFormatters.currency(order.pendingAmount),
                  loadCount: order.loadCount.toString(),
                  paymentStatus: _statusLabel(order.paymentStatus),
                  deliveryStatus: _statusLabel(order.deliveryStatus),
                  date: AppFormatters.date(order.orderDate),
                  onTap: () => context.go(AppRoutes.orderDetailsPath(order.id)),
                ),
              ),
            const SectionTitle(title: 'Vehicle Status'),
            GlassCard(
              child: Column(
                children: <Widget>[
                  _VehicleStatusRow(
                    label: 'Available',
                    value: data.availableVehicles.toString(),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _VehicleStatusRow(
                    label: 'Busy',
                    value: data.busyVehicles.toString(),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _listenForRealtime(WidgetRef ref) {
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
    ref.listen(vehicleRealtimeProvider, (_, next) {
      if (next.hasValue) {
        ref.invalidate(vehicleListProvider);
        invalidateBusinessMetrics(ref);
      }
    });
  }

  String _statusLabel(String value) {
    return value
        .split('_')
        .where((String part) => part.isNotEmpty)
        .map((String part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning, Harish \u{1F44B}';
    }
    if (hour >= 12 && hour < 17) {
      return 'Good Afternoon, Harish \u{2600}\u{FE0F}';
    }
    if (hour >= 17 && hour < 21) {
      return 'Good Evening, Harish \u{1F307}';
    }
    return 'Good Night, Harish \u{1F319}';
  }
}

class _DashboardGrid extends StatelessWidget {
  const _DashboardGrid({required this.metrics});

  final DashboardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    // Glass-effect Hero Card with Today's Key Stats
    return GlassCard(
      isGlass: true,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Snapshot',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.white : AppColors.ink900,
                ),
              ),
              const Icon(Icons.auto_graph_rounded, color: AppColors.aqua400),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  label: 'Revenue',
                  value: AppFormatters.currency(metrics.todayRevenue),
                  trendUp: true,
                ),
              ),
              Container(
                width: 1, 
                height: 40, 
                color: AppColors.borderHairline,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              ),
              Expanded(
                child: _HeroStat(
                  label: 'Orders',
                  value: metrics.ordersToday.toString(),
                  trendUp: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  label: 'Pending',
                  value: AppFormatters.currency(metrics.pendingPayments),
                  trendUp: false,
                  color: AppColors.warning,
                ),
              ),
              Container(
                width: 1, 
                height: 40, 
                color: AppColors.borderHairline,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              ),
              Expanded(
                child: _HeroStat(
                  label: 'Active Deliveries',
                  value: metrics.busyVehicles.toString(),
                  trendUp: null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.label, 
    required this.value, 
    this.trendUp,
    this.color,
  });

  final String label;
  final String value;
  final bool? trendUp;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.ink500,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Text(
                value,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: color ?? (Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.ink900),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (trendUp != null) ...[
              const SizedBox(width: AppSpacing.xxs),
              Icon(
                trendUp! ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                size: 16,
                color: trendUp! ? AppColors.success : AppColors.danger,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _VehicleStatusRow extends StatelessWidget {
  const _VehicleStatusRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(label)),
        StatusChip(label: value, color: color),
      ],
    );
  }
}
