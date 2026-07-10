import '../../orders/domain/order_record.dart';

class ChartPoint {
  const ChartPoint({required this.label, required this.value});

  final String label;
  final num value;
}

class CategoryMetric {
  const CategoryMetric({required this.label, required this.value});

  final String label;
  final num value;
}

class DashboardMetrics {
  const DashboardMetrics({
    required this.todayRevenue,
    required this.todayExpenses,
    required this.todayProfit,
    required this.pendingPayments,
    required this.ordersToday,
    required this.availableVehicles,
    required this.busyVehicles,
    required this.recentOrders,
  });

  final num todayRevenue;
  final num todayExpenses;
  final num todayProfit;
  final num pendingPayments;
  final int ordersToday;
  final int availableVehicles;
  final int busyVehicles;
  final List<OrderRecord> recentOrders;
}

class AnalyticsMetrics {
  const AnalyticsMetrics({
    required this.dailyRevenue,
    required this.monthlyRevenue,
    required this.dailyExpenses,
    required this.monthlyExpenses,
    required this.dailyProfit,
    required this.monthlyProfit,
    required this.pendingCollections,
    required this.vehicleRevenue,
    required this.driverRevenue,
    required this.customerRevenue,
    required this.expenseBreakdown,
    required this.paymentStatusSummary,
    required this.deliveryStatusSummary,
    required this.orders,
    required this.expenses,
  });

  final List<ChartPoint> dailyRevenue;
  final List<ChartPoint> monthlyRevenue;
  final List<ChartPoint> dailyExpenses;
  final List<ChartPoint> monthlyExpenses;
  final List<ChartPoint> dailyProfit;
  final List<ChartPoint> monthlyProfit;
  final num pendingCollections;
  final List<CategoryMetric> vehicleRevenue;
  final List<CategoryMetric> driverRevenue;
  final List<CategoryMetric> customerRevenue;
  final List<CategoryMetric> expenseBreakdown;
  final List<CategoryMetric> paymentStatusSummary;
  final List<CategoryMetric> deliveryStatusSummary;
  final int orders;
  final int expenses;
}
