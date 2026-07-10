import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/application/navigation_providers.dart';
import '../../../core/models/expense_category.dart';
import '../../../core/shared/masters/base_master_page.dart';
import '../application/expense_category_providers.dart';
import 'widgets/expense_category_card.dart';
import 'widgets/expense_category_list_skeleton.dart';

class ExpenseCategoriesPage extends ConsumerWidget {
  const ExpenseCategoriesPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.watch(navigationServiceProvider);
    return BaseMasterPage<ExpenseCategory>(
      title: 'Expense Categories',
      subtitle: 'Expense classification',
      searchLabel: 'Search categories',
      emptyTitle: 'No Categories Yet',
      emptyMessage: 'Add your first expense category to classify expenses.',
      emptyIcon: Icons.category_outlined,
      onAdd: () => nav.goToExpenseCategoryForm(context),
      loadItems:
          (ref, q) =>
              q.isEmpty
                  ? ref.watch(expenseCategoryListProvider)
                  : ref.watch(expenseCategorySearchProvider(q)),
      buildLoading: ExpenseCategoryListSkeleton.new,
      onRefresh: (ref, q) async {
        if (q.isEmpty) {
          ref.invalidate(expenseCategoryListProvider);
        } else {
          ref.invalidate(expenseCategorySearchProvider(q));
        }
        await Future.delayed(const Duration(milliseconds: 250));
      },
      buildItem:
          (ctx, ec) => ExpenseCategoryCard(
            expenseCategory: ec,
            onTap: () => nav.goToExpenseCategoryProfile(context, ec.id),
          ),
    );
  }
}
