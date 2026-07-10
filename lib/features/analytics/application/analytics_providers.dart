import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../expenses/application/expense_providers.dart';
import '../../orders/application/order_providers.dart';
import '../../vehicles/application/vehicle_providers.dart';
import 'business_metrics.dart';
import 'business_metrics_calculator.dart';

final businessMetricsCalculatorProvider = Provider<BusinessMetricsCalculator>((
  ref,
) {
  return const BusinessMetricsCalculator();
});

final dashboardMetricsProvider = FutureProvider.autoDispose<DashboardMetrics>((
  ref,
) async {
  final orders = await ref.watch(orderListProvider.future);
  final expenses = await ref.watch(expenseListProvider.future);
  final vehicles = await ref.watch(vehicleListProvider.future);
  return ref
      .watch(businessMetricsCalculatorProvider)
      .dashboard(orders: orders, expenses: expenses, vehicles: vehicles);
});

final analyticsMetricsProvider = FutureProvider.autoDispose<AnalyticsMetrics>((
  ref,
) async {
  final orders = await ref.watch(orderListProvider.future);
  final expenses = await ref.watch(expenseListProvider.future);
  return ref
      .watch(businessMetricsCalculatorProvider)
      .analytics(orders: orders, expenses: expenses);
});

void invalidateBusinessMetrics(WidgetRef ref) {
  ref.invalidate(dashboardMetricsProvider);
  ref.invalidate(analyticsMetricsProvider);
}
