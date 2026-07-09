import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/analytics/presentation/analytics_page.dart';
import '../../features/home/presentation/home_shell.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/masters/presentation/masters_page.dart';
import '../../features/more/presentation/more_page.dart';
import '../../features/orders/orders_page.dart';
import '../../features/splash/presentation/splash_page.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.splash,
      builder:
          (BuildContext context, GoRouterState state) => const SplashPage(),
    ),
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return HomeShell(currentPath: state.uri.path, child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.home,
          builder:
              (BuildContext context, GoRouterState state) => const HomePage(),
        ),
        GoRoute(
          path: AppRoutes.orders,
          builder:
              (BuildContext context, GoRouterState state) => const OrdersPage(),
        ),
        GoRoute(
          path: AppRoutes.analytics,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const AnalyticsPage(),
        ),
        GoRoute(
          path: AppRoutes.masters,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const MastersPage(),
        ),
        GoRoute(
          path: AppRoutes.more,
          builder:
              (BuildContext context, GoRouterState state) => const MorePage(),
        ),
      ],
    ),
  ],
);
