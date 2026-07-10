import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_constants.dart';
import '../../router/app_routes.dart';
import '../../theme/app_spacing.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    required this.title,
    super.key,
    this.subtitle = AppConstants.appHeader,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final canNavigateBack = _canNavigateBack(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Row(
        children: <Widget>[
          if (canNavigateBack) ...<Widget>[
            IconButton.filledTonal(
              tooltip: 'Back',
              onPressed: () {
                final router = GoRouter.of(context);
                if (router.canPop()) {
                  router.pop();
                } else {
                  context.go(_fallbackBackPath(context));
                }
              },
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: AppSpacing.xxs),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }

  bool _canNavigateBack(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    return path != AppRoutes.home &&
        path != AppRoutes.orders &&
        path != AppRoutes.analytics &&
        path != AppRoutes.masters &&
        path != AppRoutes.more;
  }

  String _fallbackBackPath(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    if (path == AppRoutes.customers ||
        path == AppRoutes.drivers ||
        path == AppRoutes.vehicles ||
        path == AppRoutes.locations ||
        path == AppRoutes.waterPoints ||
        path == AppRoutes.partnerTankers ||
        path == AppRoutes.expenseCategories ||
        path == AppRoutes.expenses ||
        path == AppRoutes.pendingPayments) {
      return AppRoutes.masters;
    }
    if (path.startsWith(AppRoutes.newOrder) ||
        path.startsWith(AppRoutes.orderDetails)) {
      return AppRoutes.orders;
    }
    if (path.startsWith(AppRoutes.customerProfile) ||
        path.startsWith(AppRoutes.customerForm)) {
      return AppRoutes.customers;
    }
    if (path.startsWith(AppRoutes.driverProfile) ||
        path.startsWith(AppRoutes.driverForm)) {
      return AppRoutes.drivers;
    }
    if (path.startsWith(AppRoutes.vehicleDetails) ||
        path.startsWith(AppRoutes.vehicleForm)) {
      return AppRoutes.vehicles;
    }
    if (path.startsWith(AppRoutes.locationProfile) ||
        path.startsWith(AppRoutes.locationForm)) {
      return AppRoutes.locations;
    }
    if (path.startsWith(AppRoutes.waterPointProfile) ||
        path.startsWith(AppRoutes.waterPointForm)) {
      return AppRoutes.waterPoints;
    }
    if (path.startsWith(AppRoutes.partnerTankerProfile) ||
        path.startsWith(AppRoutes.partnerTankerForm)) {
      return AppRoutes.partnerTankers;
    }
    if (path.startsWith(AppRoutes.expenseCategoryProfile) ||
        path.startsWith(AppRoutes.expenseCategoryForm)) {
      return AppRoutes.expenseCategories;
    }
    if (path.startsWith(AppRoutes.expenseDetails) ||
        path.startsWith(AppRoutes.expenseForm)) {
      return AppRoutes.expenses;
    }
    if (path.startsWith(AppRoutes.settings) ||
        path.startsWith(AppRoutes.globalSearch)) {
      return AppRoutes.more;
    }
    return AppRoutes.home;
  }
}
