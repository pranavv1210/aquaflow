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
    if (path.startsWith('/orders')) {
      return AppRoutes.orders;
    }
    if (path.startsWith('/customers')) {
      return AppRoutes.customers;
    }
    if (path.startsWith('/drivers')) {
      return AppRoutes.drivers;
    }
    if (path.startsWith('/vehicles')) {
      return AppRoutes.vehicles;
    }
    if (path.startsWith('/locations')) {
      return AppRoutes.locations;
    }
    if (path.startsWith('/water-points')) {
      return AppRoutes.waterPoints;
    }
    if (path.startsWith('/partner-tankers')) {
      return AppRoutes.partnerTankers;
    }
    if (path.startsWith('/expense-categories')) {
      return AppRoutes.expenseCategories;
    }
    if (path.startsWith('/expenses')) {
      return AppRoutes.expenses;
    }
    if (path.startsWith('/payments')) {
      return AppRoutes.pendingPayments;
    }
    if (path.startsWith('/settings') || path.startsWith('/search')) {
      return AppRoutes.more;
    }
    return AppRoutes.home;
  }
}
