import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../core/theme/app_spacing.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({required this.currentPath, required this.child, super.key});

  final String currentPath;
  final Widget child;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  DateTime? _lastBackPress;

  static const List<_NavigationDestinationConfig> _destinations =
      <_NavigationDestinationConfig>[
        _NavigationDestinationConfig(
          route: AppRoutes.home,
          icon: Icons.dashboard_outlined,
          selectedIcon: Icons.dashboard_rounded,
          label: 'Home',
        ),
        _NavigationDestinationConfig(
          route: AppRoutes.orders,
          icon: Icons.receipt_long_outlined,
          selectedIcon: Icons.receipt_long_rounded,
          label: 'Orders',
        ),
        _NavigationDestinationConfig(
          route: AppRoutes.analytics,
          icon: Icons.query_stats_outlined,
          selectedIcon: Icons.query_stats_rounded,
          label: 'Analytics',
        ),
        _NavigationDestinationConfig(
          route: AppRoutes.masters,
          icon: Icons.storage_outlined,
          selectedIcon: Icons.storage_rounded,
          label: 'Masters',
        ),
        _NavigationDestinationConfig(
          route: AppRoutes.more,
          icon: Icons.more_horiz_outlined,
          selectedIcon: Icons.more_horiz_rounded,
          label: 'More',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndexForPath(widget.currentPath);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        _handleBack(context);
      },
      child: Scaffold(
        extendBody: true,
        body: SafeArea(child: widget.child),
        bottomNavigationBar: _PremiumBottomNavigationBar(
          selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
          destinations: _destinations,
          onSelected: (int index) {
            HapticFeedback.selectionClick();
            context.go(_destinations[index].route);
          },
        ),
      ),
    );
  }

  void _handleBack(BuildContext context) {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
      return;
    }

    if (widget.currentPath != AppRoutes.home) {
      context.go(_fallbackBackPath(widget.currentPath));
      return;
    }

    final now = DateTime.now();
    final shouldExit =
        _lastBackPress != null &&
        now.difference(_lastBackPress!) < const Duration(seconds: 2);
    if (shouldExit) {
      SystemNavigator.pop();
      return;
    }

    _lastBackPress = now;
    SnackbarService.info('Press back again to exit');
  }

  int _selectedIndexForPath(String path) {
    if (path.startsWith('/orders')) {
      return 1;
    }
    if (path.startsWith('/analytics')) {
      return 2;
    }
    if (path.startsWith('/customers') ||
        path.startsWith('/drivers') ||
        path.startsWith('/vehicles') ||
        path.startsWith('/locations') ||
        path.startsWith('/water-points') ||
        path.startsWith('/partners') ||
        path.startsWith('/partner-tankers') ||
        path.startsWith('/expense-categories') ||
        path.startsWith('/expenses') ||
        path.startsWith('/payments') ||
        path.startsWith('/masters')) {
      return 3;
    }
    if (path.startsWith('/settings') ||
        path.startsWith('/search') ||
        path.startsWith('/more')) {
      return 4;
    }
    return 0;
  }

  String _fallbackBackPath(String path) {
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

class _NavigationDestinationConfig {
  const _NavigationDestinationConfig({
    required this.route,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final String route;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class _PremiumBottomNavigationBar extends StatelessWidget {
  const _PremiumBottomNavigationBar({
    required this.selectedIndex,
    required this.destinations,
    required this.onSelected,
  });

  final int selectedIndex;
  final List<_NavigationDestinationConfig> destinations;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.58)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.16),
                  blurRadius: 30,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                children: <Widget>[
                  for (var index = 0; index < destinations.length; index++)
                    Expanded(
                      child: _PremiumNavigationItem(
                        destination: destinations[index],
                        selected: index == selectedIndex,
                        onTap: () => onSelected(index),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumNavigationItem extends StatelessWidget {
  const _PremiumNavigationItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _NavigationDestinationConfig destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
      color:
          selected
              ? colorScheme.primary
              : colorScheme.onSurface.withValues(alpha: 0.58),
    );

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutBack,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color:
                selected
                    ? colorScheme.primary.withValues(alpha: 0.10)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedScale(
                scale: selected ? 1.08 : 1,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutBack,
                child: Icon(
                  selected ? destination.selectedIcon : destination.icon,
                  size: selected ? 24 : 22,
                  color:
                      selected
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.62),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                destination.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
