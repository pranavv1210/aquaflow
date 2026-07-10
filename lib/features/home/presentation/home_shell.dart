import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/services/snackbar_service.dart';

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
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.72),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.56),
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.14),
                      blurRadius: 28,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: NavigationBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
                  onDestinationSelected: (int index) {
                    HapticFeedback.selectionClick();
                    context.go(_destinations[index].route);
                  },
                  destinations: _destinations
                      .map(
                        (_NavigationDestinationConfig destination) =>
                            NavigationDestination(
                              icon: Icon(destination.icon),
                              selectedIcon: Icon(destination.selectedIcon),
                              label: destination.label,
                            ),
                      )
                      .toList(growable: false),
                ),
              ),
            ),
          ),
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
