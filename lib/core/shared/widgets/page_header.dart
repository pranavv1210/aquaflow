import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_constants.dart';
import '../../router/app_routes.dart';
import '../../theme/app_colors.dart';
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
    // If PageHeader is used outside of AppScreen, it will render normally
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: buildHeaderContent(context),
    );
  }

  // Method to allow AppScreen to extract and use the content in a SliverAppBar
  Widget buildHeaderContent(BuildContext context) {
    final canNavigateBack = _canNavigateBack(context);
    final isGreeting = title.startsWith('Good ');
    final titleStyle =
        isGreeting
            ? Theme.of(context).textTheme.displayMedium
            : Theme.of(context).textTheme.displayLarge;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _AppBrandHeader(),
        const SizedBox(height: AppSpacing.sm),
        Row(
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
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    style: titleStyle,
                    maxLines: isGreeting ? 2 : 1,
                    overflow:
                        isGreeting
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...<Widget>[
              const SizedBox(width: AppSpacing.sm),
              trailing!,
            ],
          ],
        ),
      ],
    );
  }

  bool _canNavigateBack(BuildContext context) {
    final path = _currentPath(context);
    return path != AppRoutes.home &&
        path != AppRoutes.orders &&
        path != AppRoutes.analytics &&
        path != AppRoutes.masters &&
        path != AppRoutes.more;
  }

  String _fallbackBackPath(BuildContext context) {
    final path = _currentPath(context);
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

  String _currentPath(BuildContext context) {
    try {
      return GoRouterState.of(context).uri.path;
    } on GoError {
      return AppRoutes.home;
    }
  }
}

class _AppBrandHeader extends StatelessWidget {
  const _AppBrandHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.water_drop_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
            Text(
              AppConstants.appHeader,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColors.ink500),
            ),
          ],
        ),
      ],
    );
  }
}
