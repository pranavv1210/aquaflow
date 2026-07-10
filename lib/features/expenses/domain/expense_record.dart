import 'package:equatable/equatable.dart';

class ExpenseRecord extends Equatable {
  const ExpenseRecord({
    required this.id,
    required this.expenseDate,
    required this.expenseCategoryId,
    required this.categoryName,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    this.vehicleId,
    this.vehicleName,
    this.driverId,
    this.driverName,
    this.remarks,
  });

  final String id;
  final DateTime expenseDate;
  final String expenseCategoryId;
  final String categoryName;
  final String? vehicleId;
  final String? vehicleName;
  final String? driverId;
  final String? driverName;
  final num amount;
  final String? remarks;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => <Object?>[
    id,
    expenseDate,
    expenseCategoryId,
    categoryName,
    vehicleId,
    vehicleName,
    driverId,
    driverName,
    amount,
    remarks,
    createdAt,
    updatedAt,
  ];
}
