import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/shared/widgets/action_tile.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/glass_card.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/ui_state_switcher.dart';

class MastersPage extends StatelessWidget {
  const MastersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UiStateSwitcher(
      state: UiContentState.populated,
      emptyTitle: 'No Masters Yet',
      emptyMessage: 'Master records will appear after setup.',
      emptyIcon: Icons.storage_outlined,
      populated: AppScreen(
        children: <Widget>[
          const PageHeader(title: 'Masters', subtitle: 'Core business records'),
          GlassCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                ActionTile(
                  title: 'Customers',
                  subtitle: 'Customer list and profiles',
                  icon: Icons.people_outline_rounded,
                  onTap: () => context.go(AppRoutes.customers),
                ),
                ActionTile(
                  title: 'Drivers',
                  subtitle: 'Driver list and profiles',
                  icon: Icons.badge_outlined,
                  onTap: () => context.go(AppRoutes.drivers),
                ),
                ActionTile(
                  title: 'Vehicles',
                  subtitle: 'Tankers and assigned vehicles',
                  icon: Icons.local_shipping_outlined,
                  onTap: () => context.go(AppRoutes.vehicles),
                ),
                ActionTile(
                  title: 'Locations',
                  subtitle: 'Route areas and service zones',
                  icon: Icons.location_on_outlined,
                  onTap: () => context.go(AppRoutes.locations),
                ),
                ActionTile(
                  title: 'Water Points',
                  subtitle: 'Water filling locations',
                  icon: Icons.water_drop_outlined,
                  onTap: () => context.go(AppRoutes.waterPoints),
                ),
                ActionTile(
                  title: 'Partner Tankers',
                  subtitle: 'External partner vehicles',
                  icon: Icons.handshake_outlined,
                  onTap: () => context.go(AppRoutes.partnerTankers),
                ),
                ActionTile(
                  title: 'Expense Categories',
                  subtitle: 'Expense classification',
                  icon: Icons.category_outlined,
                  onTap: () => context.go(AppRoutes.expenseCategories),
                ),
                ActionTile(
                  title: 'Expenses',
                  subtitle: 'Business spending and vehicle expenses',
                  icon: Icons.receipt_long_outlined,
                  onTap: () => context.go(AppRoutes.expenses),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
