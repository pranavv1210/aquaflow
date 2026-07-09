import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({required this.currentPath, required this.child, super.key});

  final String currentPath;
  final Widget child;

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
    final selectedIndex = _destinations.indexWhere(
      (_NavigationDestinationConfig destination) =>
          currentPath == destination.route,
    );

    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
        onDestinationSelected: (int index) {
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
    );
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
