import 'value_objects.dart';

class Expense {
  const Expense({
    required this.id,
    required this.date,
    required this.vehicleId,
    required this.expenseCategoryId,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    this.driverId,
    this.remarks,
  });

  final String id;
  final BusinessDate date;
  final String vehicleId;
  final String? driverId;
  final String expenseCategoryId;
  final Money amount;
  final String? remarks;
  final DateTime createdAt;
  final DateTime updatedAt;
}
