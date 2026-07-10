import 'package:equatable/equatable.dart';

class ExpenseCategoryInput extends Equatable {
  const ExpenseCategoryInput({
    required this.categoryName,
    required this.expenseType,
    this.description,
  });

  final String categoryName;
  final String expenseType;
  final String? description;

  ExpenseCategoryInput trimmed() {
    return ExpenseCategoryInput(
      categoryName: categoryName.trim(),
      expenseType: expenseType.trim(),
      description: _blankToNull(description),
    );
  }

  static String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  @override
  List<Object?> get props => <Object?>[categoryName, expenseType, description];
}
