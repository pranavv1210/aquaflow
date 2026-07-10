import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/navigation_providers.dart';
import '../../../core/shared/masters/base_master_page.dart';
import '../application/expense_providers.dart';
import '../domain/expense_record.dart';
import 'widgets/expense_card.dart';
import 'widgets/expense_list_skeleton.dart';

class ExpensesPage extends ConsumerWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.watch(navigationServiceProvider);
    ref.listen(expenseRealtimeProvider, (
      _,
      AsyncValue<List<Map<String, dynamic>>> next,
    ) {
      if (next.hasValue) {
        ref.invalidate(expenseListProvider);
      }
    });

    return BaseMasterPage<ExpenseRecord>(
      title: 'Expenses',
      subtitle: 'Operational spending',
      searchLabel: 'Search expenses',
      emptyTitle: 'No Expenses Yet',
      emptyMessage: 'Add expenses to track vehicle and business spending.',
      emptyIcon: Icons.receipt_long_outlined,
      onAdd: () => navigation.goToExpenseForm(context),
      loadItems: (WidgetRef ref, String query) {
        return query.isEmpty
            ? ref.watch(expenseListProvider)
            : ref.watch(expenseSearchProvider(query));
      },
      buildLoading: ExpenseListSkeleton.new,
      onRefresh: (WidgetRef ref, String query) async {
        if (query.isEmpty) {
          ref.invalidate(expenseListProvider);
        } else {
          ref.invalidate(expenseSearchProvider(query));
        }
        await Future<void>.delayed(const Duration(milliseconds: 250));
      },
      buildItem: (BuildContext context, ExpenseRecord expense) {
        return ExpenseCard(
          expense: expense,
          onTap: () => navigation.goToExpenseDetails(context, expense.id),
        );
      },
    );
  }
}
