import 'package:flutter/material.dart';
import '../../../../core/models/expense_category.dart';
import '../../../../core/shared/widgets/person_card.dart';

class ExpenseCategoryCard extends StatelessWidget {
  const ExpenseCategoryCard({
    required this.expenseCategory,
    super.key,
    this.onTap,
  });
  final ExpenseCategory expenseCategory;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => PersonCard(
    title: expenseCategory.categoryName,
    subtitle: expenseCategory.expenseType,
    icon: Icons.category_outlined,
    onTap: onTap,
  );
}
