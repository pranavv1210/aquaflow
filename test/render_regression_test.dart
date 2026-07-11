import 'package:aquaflow/core/theme/app_theme.dart';
import 'package:aquaflow/features/analytics/application/analytics_providers.dart';
import 'package:aquaflow/features/analytics/application/business_metrics.dart';
import 'package:aquaflow/features/home/presentation/home_page.dart';
import 'package:aquaflow/features/home/presentation/home_shell.dart';
import 'package:aquaflow/features/orders/application/order_providers.dart';
import 'package:aquaflow/features/orders/domain/order_record.dart';
import 'package:aquaflow/features/orders/orders_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('home renders with populated metrics', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardMetricsProvider.overrideWith((ref) async => _dashboard),
          orderRealtimeProvider.overrideWith((ref) => const Stream.empty()),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const HomeShell(currentPath: '/home', child: HomePage()),
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining("Today's Business"), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('orders renders with populated orders', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          orderListProvider.overrideWith((ref) async => <OrderRecord>[_order]),
          orderRealtimeProvider.overrideWith((ref) => const Stream.empty()),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const HomeShell(currentPath: '/orders', child: OrdersPage()),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Orders'), findsWidgets);
    expect(find.text('Harish'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
}

final _now = DateTime(2026, 7, 11, 9);

final _order = OrderRecord(
  id: 'order-1',
  orderNumber: 'AQ-2026-000001',
  orderDate: _now,
  orderTime: '09:00:00',
  customerId: 'customer-1',
  customerName: 'Harish',
  customerPhone: '9999999999',
  locationId: 'location-1',
  locationName: 'Main Road',
  waterPointId: 'water-1',
  waterPointName: 'Point A',
  vehicleId: 'vehicle-1',
  vehicleName: 'Tanker 1',
  driverId: 'driver-1',
  driverName: 'Driver 1',
  loadCount: 1,
  amount: 850,
  paidAmount: 0,
  paymentStatus: 'unpaid',
  deliveryStatus: 'delivered',
  createdAt: _now,
  updatedAt: _now,
);

final _dashboard = DashboardMetrics(
  todayRevenue: 850,
  todayExpenses: 0,
  todayProfit: 850,
  pendingPayments: 850,
  ordersToday: 1,
  availableVehicles: 1,
  busyVehicles: 0,
  recentOrders: <OrderRecord>[_order],
);
