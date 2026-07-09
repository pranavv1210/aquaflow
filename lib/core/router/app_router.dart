import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/analytics/presentation/analytics_page.dart';
import '../../features/customers/presentation/customer_form_page.dart';
import '../../features/customers/presentation/customer_profile_page.dart';
import '../../features/customers/presentation/customers_page.dart';
import '../../features/drivers/presentation/driver_profile_page.dart';
import '../../features/drivers/presentation/drivers_page.dart';
import '../../features/home/presentation/global_search_page.dart';
import '../../features/home/presentation/home_shell.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/masters/presentation/masters_page.dart';
import '../../features/more/presentation/more_page.dart';
import '../../features/orders/new_order_page.dart';
import '../../features/orders/order_details_page.dart';
import '../../features/orders/orders_page.dart';
import '../../features/partners/presentation/partners_page.dart';
import '../../features/payments/presentation/pending_payments_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/splash/presentation/splash_page.dart';
import '../../features/vehicles/presentation/vehicle_details_page.dart';
import '../../features/vehicles/presentation/vehicles_page.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.splash,
      pageBuilder:
          (BuildContext context, GoRouterState state) =>
              _fadePage(state, const SplashPage()),
    ),
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return HomeShell(currentPath: state.uri.path, child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.home,
          pageBuilder:
              (BuildContext context, GoRouterState state) =>
                  _fadePage(state, const HomePage()),
        ),
        GoRoute(
          path: AppRoutes.orders,
          pageBuilder:
              (BuildContext context, GoRouterState state) =>
                  _fadePage(state, const OrdersPage()),
        ),
        GoRoute(
          path: AppRoutes.newOrder,
          pageBuilder:
              (BuildContext context, GoRouterState state) =>
                  _slidePage(state, const NewOrderPage()),
        ),
        GoRoute(
          path: AppRoutes.orderDetails,
          pageBuilder:
              (BuildContext context, GoRouterState state) =>
                  _slidePage(state, const OrderDetailsPage()),
        ),
        GoRoute(
          path: AppRoutes.analytics,
          pageBuilder:
              (BuildContext context, GoRouterState state) =>
                  _fadePage(state, const AnalyticsPage()),
        ),
        GoRoute(
          path: AppRoutes.masters,
          pageBuilder:
              (BuildContext context, GoRouterState state) =>
                  _fadePage(state, const MastersPage()),
        ),
        GoRoute(
          path: AppRoutes.customers,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const CustomersPage(),
        ),
        GoRoute(
          path: AppRoutes.customerProfile,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const CustomerProfilePage(),
        ),
        GoRoute(
          path: AppRoutes.customerForm,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const CustomerFormPage(),
        ),
        GoRoute(
          path: AppRoutes.drivers,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const DriversPage(),
        ),
        GoRoute(
          path: AppRoutes.driverProfile,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const DriverProfilePage(),
        ),
        GoRoute(
          path: AppRoutes.vehicles,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const VehiclesPage(),
        ),
        GoRoute(
          path: AppRoutes.vehicleDetails,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const VehicleDetailsPage(),
        ),
        GoRoute(
          path: AppRoutes.partners,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const PartnersPage(),
        ),
        GoRoute(
          path: AppRoutes.pendingPayments,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const PendingPaymentsPage(),
        ),
        GoRoute(
          path: AppRoutes.globalSearch,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const GlobalSearchPage(),
        ),
        GoRoute(
          path: AppRoutes.settings,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const SettingsPage(),
        ),
        GoRoute(
          path: AppRoutes.more,
          pageBuilder:
              (BuildContext context, GoRouterState state) =>
                  _fadePage(state, const MorePage()),
        ),
      ],
    ),
  ],
);

CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

CustomTransitionPage<void> _slidePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      final tween = Tween<Offset>(
        begin: const Offset(0.04, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: animation.drive(tween), child: child),
      );
    },
  );
}
