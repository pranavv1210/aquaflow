import '../../../core/models/domain_enums.dart';
import '../../../core/models/vehicle.dart';
import '../../expenses/domain/expense_record.dart';
import '../../orders/domain/order_record.dart';
import 'business_metrics.dart';

class BusinessMetricsCalculator {
  const BusinessMetricsCalculator();

  DashboardMetrics dashboard({
    required List<OrderRecord> orders,
    required List<ExpenseRecord> expenses,
    required List<Vehicle> vehicles,
  }) {
    final today = DateTime.now();
    final todayOrders = orders.where(
      (OrderRecord order) => _sameDay(order.orderDate, today),
    );
    final todayRevenue = todayOrders
        .where((OrderRecord order) => order.deliveryStatus == 'delivered')
        .fold<num>(0, (num total, OrderRecord order) => total + order.amount);
    final todayExpenses = expenses
        .where((ExpenseRecord expense) => _sameDay(expense.expenseDate, today))
        .fold<num>(
          0,
          (num total, ExpenseRecord expense) => total + expense.amount,
        );
    final recent = List<OrderRecord>.from(orders)
      ..sort((OrderRecord a, OrderRecord b) {
        final dateCompare = b.orderDate.compareTo(a.orderDate);
        if (dateCompare != 0) {
          return dateCompare;
        }
        return b.createdAt.compareTo(a.createdAt);
      });

    return DashboardMetrics(
      todayRevenue: todayRevenue,
      todayExpenses: todayExpenses,
      todayProfit: todayRevenue - todayExpenses,
      pendingPayments: _pendingPayments(orders),
      ordersToday: todayOrders.length,
      availableVehicles:
          vehicles
              .where(
                (Vehicle vehicle) => vehicle.status == VehicleStatus.available,
              )
              .length,
      busyVehicles:
          vehicles
              .where((Vehicle vehicle) => vehicle.status == VehicleStatus.busy)
              .length,
      recentOrders: recent.take(5).toList(growable: false),
    );
  }

  AnalyticsMetrics analytics({
    required List<OrderRecord> orders,
    required List<ExpenseRecord> expenses,
  }) {
    final revenueOrders = orders;
    final dailyRevenue = _seriesByDay<OrderRecord>(
      revenueOrders,
      (OrderRecord order) => order.orderDate,
      (OrderRecord order) => order.amount,
      days: 14,
    );
    final dailyExpenses = _seriesByDay<ExpenseRecord>(
      expenses,
      (ExpenseRecord expense) => expense.expenseDate,
      (ExpenseRecord expense) => expense.amount,
      days: 14,
    );
    final monthlyRevenue = _seriesByMonth<OrderRecord>(
      revenueOrders,
      (OrderRecord order) => order.orderDate,
      (OrderRecord order) => order.amount,
      months: 6,
    );
    final monthlyExpenses = _seriesByMonth<ExpenseRecord>(
      expenses,
      (ExpenseRecord expense) => expense.expenseDate,
      (ExpenseRecord expense) => expense.amount,
      months: 6,
    );

    return AnalyticsMetrics(
      dailyRevenue: dailyRevenue,
      monthlyRevenue: monthlyRevenue,
      dailyExpenses: dailyExpenses,
      monthlyExpenses: monthlyExpenses,
      dailyProfit: _subtractSeries(dailyRevenue, dailyExpenses),
      monthlyProfit: _subtractSeries(monthlyRevenue, monthlyExpenses),
      pendingCollections: _pendingPayments(orders),
      vehicleRevenue: _topByLabel<OrderRecord>(
        revenueOrders,
        (OrderRecord order) => order.vehicleName,
        (OrderRecord order) => order.amount,
      ),
      driverRevenue: _topByLabel<OrderRecord>(
        revenueOrders,
        (OrderRecord order) => order.driverName,
        (OrderRecord order) => order.amount,
      ),
      customerRevenue: _topByLabel<OrderRecord>(
        revenueOrders,
        (OrderRecord order) => order.customerName,
        (OrderRecord order) => order.amount,
      ),
      expenseBreakdown: _topByLabel<ExpenseRecord>(
        expenses,
        (ExpenseRecord expense) => expense.categoryName,
        (ExpenseRecord expense) => expense.amount,
      ),
      paymentStatusSummary: _countByLabel<OrderRecord>(
        orders,
        (OrderRecord order) => _statusLabel(order.paymentStatus),
      ),
      deliveryStatusSummary: _countByLabel<OrderRecord>(
        orders,
        (OrderRecord order) => _statusLabel(order.deliveryStatus),
      ),
      orders: orders.length,
      expenses: expenses.length,
    );
  }

  num _pendingPayments(List<OrderRecord> orders) {
    return orders.fold<num>(
      0,
      (num total, OrderRecord order) =>
          total + (order.pendingAmount > 0 ? order.pendingAmount : 0),
    );
  }

  List<ChartPoint> _seriesByDay<T>(
    List<T> items,
    DateTime Function(T item) dateOf,
    num Function(T item) valueOf, {
    required int days,
  }) {
    final today = _dateOnly(DateTime.now());
    return List<ChartPoint>.generate(days, (int index) {
      final day = today.subtract(Duration(days: days - index - 1));
      final value = items
          .where((T item) => _sameDay(dateOf(item), day))
          .fold<num>(0, (num total, T item) => total + valueOf(item));
      return ChartPoint(label: '${day.day}/${day.month}', value: value);
    });
  }

  List<ChartPoint> _seriesByMonth<T>(
    List<T> items,
    DateTime Function(T item) dateOf,
    num Function(T item) valueOf, {
    required int months,
  }) {
    final now = DateTime.now();
    return List<ChartPoint>.generate(months, (int index) {
      final month = DateTime(now.year, now.month - months + index + 1);
      final value = items
          .where((T item) {
            final date = dateOf(item);
            return date.year == month.year && date.month == month.month;
          })
          .fold<num>(0, (num total, T item) => total + valueOf(item));
      return ChartPoint(label: '${month.month}/${month.year}', value: value);
    });
  }

  List<ChartPoint> _subtractSeries(
    List<ChartPoint> first,
    List<ChartPoint> second,
  ) {
    return List<ChartPoint>.generate(first.length, (int index) {
      return ChartPoint(
        label: first[index].label,
        value: first[index].value - second[index].value,
      );
    });
  }

  List<CategoryMetric> _topByLabel<T>(
    List<T> items,
    String Function(T item) labelOf,
    num Function(T item) valueOf,
  ) {
    final totals = <String, num>{};
    for (final item in items) {
      final label = labelOf(item);
      totals[label] = (totals[label] ?? 0) + valueOf(item);
    }
    final metrics =
        totals.entries
            .map(
              (entry) => CategoryMetric(label: entry.key, value: entry.value),
            )
            .toList()
          ..sort(
            (CategoryMetric a, CategoryMetric b) => b.value.compareTo(a.value),
          );
    return metrics.take(8).toList(growable: false);
  }

  List<CategoryMetric> _countByLabel<T>(
    List<T> items,
    String Function(T item) labelOf,
  ) {
    final totals = <String, num>{};
    for (final item in items) {
      final label = labelOf(item);
      totals[label] = (totals[label] ?? 0) + 1;
    }
    final metrics =
        totals.entries
            .map(
              (entry) => CategoryMetric(label: entry.key, value: entry.value),
            )
            .toList()
          ..sort(
            (CategoryMetric a, CategoryMetric b) => b.value.compareTo(a.value),
          );
    return metrics;
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  bool _sameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  String _statusLabel(String value) {
    return value
        .split('_')
        .where((String part) => part.isNotEmpty)
        .map((String part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }
}
