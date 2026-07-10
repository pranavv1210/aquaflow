import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/analytics/presentation/analytics_page.dart';
import '../../features/customers/presentation/customer_form_page.dart';
import '../../features/customers/presentation/customer_profile_page.dart';
import '../../features/customers/presentation/customers_page.dart';
import '../../features/drivers/presentation/driver_form_page.dart';
import '../../features/drivers/presentation/driver_profile_page.dart';
import '../../features/drivers/presentation/drivers_page.dart';
import '../../features/expense_categories/presentation/expense_category_form_page.dart';
import '../../features/expense_categories/presentation/expense_category_profile_page.dart';
import '../../features/expense_categories/presentation/expense_categories_page.dart';
import '../../features/expenses/presentation/expense_details_page.dart';
import '../../features/expenses/presentation/expense_form_page.dart';
import '../../features/expenses/presentation/expenses_page.dart';
import '../../features/home/presentation/global_search_page.dart';
import '../../features/home/presentation/home_shell.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/locations/presentation/location_form_page.dart';
import '../../features/locations/presentation/location_profile_page.dart';
import '../../features/locations/presentation/locations_page.dart';
import '../../features/masters/presentation/masters_page.dart';
import '../../features/more/presentation/more_page.dart';
import '../../features/orders/new_order_page.dart';
import '../../features/orders/order_details_page.dart';
import '../../features/orders/orders_page.dart';
import '../../features/partner_tankers/presentation/partner_tanker_form_page.dart';
import '../../features/partner_tankers/presentation/partner_tanker_profile_page.dart';
import '../../features/partner_tankers/presentation/partner_tankers_page.dart';
import '../../features/partners/presentation/partners_page.dart';
import '../../features/payments/presentation/pending_payments_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/splash/presentation/splash_page.dart';
import '../../features/vehicles/presentation/vehicle_details_page.dart';
import '../../features/vehicles/presentation/vehicle_form_page.dart';
import '../../features/vehicles/presentation/vehicles_page.dart';
import '../../features/water_points/presentation/water_point_form_page.dart';
import '../../features/water_points/presentation/water_point_profile_page.dart';
import '../../features/water_points/presentation/water_points_page.dart';
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
          path: '${AppRoutes.newOrder}/:orderId',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return _slidePage(
              state,
              NewOrderPage(orderId: state.pathParameters['orderId']),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.orderDetails,
          pageBuilder:
              (BuildContext context, GoRouterState state) =>
                  _slidePage(state, const OrderDetailsPage()),
        ),
        GoRoute(
          path: '${AppRoutes.orderDetails}/:orderId',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return _slidePage(
              state,
              OrderDetailsPage(orderId: state.pathParameters['orderId']!),
            );
          },
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
          path: '${AppRoutes.customerProfile}/:customerId',
          builder: (BuildContext context, GoRouterState state) {
            return CustomerProfilePage(
              customerId: state.pathParameters['customerId']!,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.customerForm,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const CustomerFormPage(),
        ),
        GoRoute(
          path: '${AppRoutes.customerForm}/:customerId',
          builder: (BuildContext context, GoRouterState state) {
            return CustomerFormPage(
              customerId: state.pathParameters['customerId'],
            );
          },
        ),
        GoRoute(
          path: AppRoutes.drivers,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const DriversPage(),
        ),
        GoRoute(
          path: '${AppRoutes.driverProfile}/:driverId',
          builder: (BuildContext context, GoRouterState state) {
            return DriverProfilePage(
              driverId: state.pathParameters['driverId']!,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.driverForm,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const DriverFormPage(),
        ),
        GoRoute(
          path: '${AppRoutes.driverForm}/:driverId',
          builder: (BuildContext context, GoRouterState state) {
            return DriverFormPage(driverId: state.pathParameters['driverId']);
          },
        ),
        GoRoute(
          path: AppRoutes.vehicles,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const VehiclesPage(),
        ),
        GoRoute(
          path: '${AppRoutes.vehicleDetails}/:vehicleId',
          builder: (BuildContext context, GoRouterState state) {
            return VehicleDetailsPage(
              vehicleId: state.pathParameters['vehicleId']!,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.vehicleForm,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const VehicleFormPage(),
        ),
        GoRoute(
          path: '${AppRoutes.vehicleForm}/:vehicleId',
          builder: (BuildContext context, GoRouterState state) {
            return VehicleFormPage(
              vehicleId: state.pathParameters['vehicleId'],
            );
          },
        ),
        GoRoute(
          path: AppRoutes.locations,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const LocationsPage(),
        ),
        GoRoute(
          path: '${AppRoutes.locationProfile}/:locationId',
          builder: (BuildContext context, GoRouterState state) {
            return LocationProfilePage(
              locationId: state.pathParameters['locationId']!,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.locationForm,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const LocationFormPage(),
        ),
        GoRoute(
          path: '${AppRoutes.locationForm}/:locationId',
          builder: (BuildContext context, GoRouterState state) {
            return LocationFormPage(
              locationId: state.pathParameters['locationId'],
            );
          },
        ),
        GoRoute(
          path: AppRoutes.waterPoints,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const WaterPointsPage(),
        ),
        GoRoute(
          path: '${AppRoutes.waterPointProfile}/:waterPointId',
          builder: (BuildContext context, GoRouterState state) {
            return WaterPointProfilePage(
              waterPointId: state.pathParameters['waterPointId']!,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.waterPointForm,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const WaterPointFormPage(),
        ),
        GoRoute(
          path: '${AppRoutes.waterPointForm}/:waterPointId',
          builder: (BuildContext context, GoRouterState state) {
            return WaterPointFormPage(
              waterPointId: state.pathParameters['waterPointId'],
            );
          },
        ),
        GoRoute(
          path: AppRoutes.partnerTankers,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const PartnerTankersPage(),
        ),
        GoRoute(
          path: '${AppRoutes.partnerTankerProfile}/:partnerTankerId',
          builder: (BuildContext context, GoRouterState state) {
            return PartnerTankerProfilePage(
              partnerTankerId: state.pathParameters['partnerTankerId']!,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.partnerTankerForm,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const PartnerTankerFormPage(),
        ),
        GoRoute(
          path: '${AppRoutes.partnerTankerForm}/:partnerTankerId',
          builder: (BuildContext context, GoRouterState state) {
            return PartnerTankerFormPage(
              partnerTankerId: state.pathParameters['partnerTankerId'],
            );
          },
        ),
        GoRoute(
          path: AppRoutes.expenseCategories,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const ExpenseCategoriesPage(),
        ),
        GoRoute(
          path: '${AppRoutes.expenseCategoryProfile}/:expenseCategoryId',
          builder: (BuildContext context, GoRouterState state) {
            return ExpenseCategoryProfilePage(
              expenseCategoryId: state.pathParameters['expenseCategoryId']!,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.expenseCategoryForm,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const ExpenseCategoryFormPage(),
        ),
        GoRoute(
          path: '${AppRoutes.expenseCategoryForm}/:expenseCategoryId',
          builder: (BuildContext context, GoRouterState state) {
            return ExpenseCategoryFormPage(
              expenseCategoryId: state.pathParameters['expenseCategoryId'],
            );
          },
        ),
        GoRoute(
          path: AppRoutes.expenses,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const ExpensesPage(),
        ),
        GoRoute(
          path: '${AppRoutes.expenseDetails}/:expenseId',
          builder: (BuildContext context, GoRouterState state) {
            return ExpenseDetailsPage(
              expenseId: state.pathParameters['expenseId']!,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.expenseForm,
          builder:
              (BuildContext context, GoRouterState state) =>
                  const ExpenseFormPage(),
        ),
        GoRoute(
          path: '${AppRoutes.expenseForm}/:expenseId',
          builder: (BuildContext context, GoRouterState state) {
            return ExpenseFormPage(
              expenseId: state.pathParameters['expenseId'],
            );
          },
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
