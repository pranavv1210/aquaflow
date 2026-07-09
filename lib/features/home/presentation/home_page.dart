import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/shared/widgets/action_tile.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/dashboard_card.dart';
import '../../../core/shared/widgets/glass_card.dart';
import '../../../core/shared/widgets/order_card.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/section_title.dart';
import '../../../core/shared/widgets/status_chip.dart';
import '../../../core/shared/widgets/ui_state_switcher.dart';
import '../../../core/theme/app_spacing.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return UiStateSwitcher(
      state: UiContentState.populated,
      emptyTitle: 'No Dashboard Data',
      emptyMessage: 'Dashboard metrics will appear after orders are added.',
      populated: AppScreen(
        children: <Widget>[
          PageHeader(
            title: AppConstants.appHeader,
            subtitle: 'Today at a glance',
            trailing: IconButton.filledTonal(
              onPressed: () => context.go(AppRoutes.globalSearch),
              icon: const Icon(Icons.search_rounded),
            ),
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
                childAspectRatio: isWide ? 1.35 : 1,
                children: const <Widget>[
                  DashboardCard(
                    title: 'Today Orders',
                    value: '--',
                    subtitle: 'No data',
                    icon: Icons.water_drop_outlined,
                  ),
                  DashboardCard(
                    title: 'Revenue',
                    value: '₹--',
                    subtitle: 'No data',
                    icon: Icons.currency_rupee_rounded,
                  ),
                  DashboardCard(
                    title: 'Pending',
                    value: '₹--',
                    subtitle: 'No data',
                    icon: Icons.pending_actions_rounded,
                  ),
                  DashboardCard(
                    title: 'Loads',
                    value: '--',
                    subtitle: 'No data',
                    icon: Icons.local_shipping_outlined,
                  ),
                ],
              );
            },
          ),
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
                  title: 'Pending Payments',
                  subtitle: 'Review open payment items',
                  icon: Icons.account_balance_wallet_outlined,
                  onTap: () => context.go(AppRoutes.pendingPayments),
                ),
                ActionTile(
                  title: 'Masters',
                  subtitle: 'Customers, vehicles, drivers, partners',
                  icon: Icons.storage_outlined,
                  onTap: () => context.go(AppRoutes.masters),
                ),
              ],
            ),
          ),
          const SectionTitle(title: 'Recent Orders'),
          OrderCard(onTap: () => context.go(AppRoutes.orderDetails)),
          const SectionTitle(title: 'Vehicle Status'),
          GlassCard(
            child: Column(
              children: <Widget>[
                _VehicleStatusRow(
                  label: 'Available',
                  value: '--',
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.sm),
                _VehicleStatusRow(
                  label: 'On Trip',
                  value: '--',
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(height: AppSpacing.sm),
                _VehicleStatusRow(
                  label: 'Maintenance',
                  value: '--',
                  color: Theme.of(context).colorScheme.error,
                ),
              ],
            ),
          ),
        ],
      ),
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
