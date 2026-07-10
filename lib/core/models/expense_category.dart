class ExpenseCategory {
  const ExpenseCategory({
    required this.id,
    required this.categoryName,
    required this.expenseType,
    required this.createdAt,
    required this.updatedAt,
    this.description,
  });

  final String id;
  final String categoryName;
  final String expenseType;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
}