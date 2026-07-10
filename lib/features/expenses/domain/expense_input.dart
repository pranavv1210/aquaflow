import 'package:equatable/equatable.dart';

class ExpenseInput extends Equatable {
  const ExpenseInput({
    required this.expenseDate,
    required this.expenseCategoryId,
    required this.amount,
    this.vehicleId,
    this.driverId,
    this.remarks,
  });

  final DateTime expenseDate;
  final String expenseCategoryId;
  final num amount;
  final String? vehicleId;
  final String? driverId;
  final String? remarks;

  ExpenseInput trimmed() {
    return ExpenseInput(
      expenseDate: expenseDate,
      expenseCategoryId: expenseCategoryId.trim(),
      amount: amount,
      vehicleId: _blankToNull(vehicleId),
      driverId: _blankToNull(driverId),
      remarks: _blankToNull(remarks),
    );
  }

  static String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  @override
  List<Object?> get props => <Object?>[
    expenseDate,
    expenseCategoryId,
    amount,
    vehicleId,
    driverId,
    remarks,
  ];
}
