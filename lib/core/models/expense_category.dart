import 'domain_enums.dart';

class ExpenseCategory {
  const ExpenseCategory({
    required this.id,
    required this.categoryName,
    required this.expenseType,
    this.description,
  });

  final String id;
  final String categoryName;
  final ExpenseType expenseType;
  final String? description;
}
