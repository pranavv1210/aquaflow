import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/navigation_providers.dart';
import '../../../core/helpers/app_formatters.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/empty_state_widget.dart';
import '../../../core/shared/widgets/error_state_widget.dart';
import '../../../core/shared/widgets/glass_card.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/section_title.dart';
import '../../../core/shared/widgets/skeleton_loader.dart';
import '../../../core/shared/widgets/stat_card.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/expense_providers.dart';
import '../domain/expense_record.dart';

class ExpenseDetailsPage extends ConsumerWidget {
  const ExpenseDetailsPage({required this.expenseId, super.key});

  final String expenseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expense = ref.watch(selectedExpenseProvider(expenseId));
    return expense.when(
      loading:
          () => const AppScreen(
            children: <Widget>[
              PageHeader(title: 'Expense Details', subtitle: 'Loading...'),
              SkeletonLoader(height: 160),
              SkeletonLoader(height: 180),
            ],
          ),
      error:
          (Object error, StackTrace stackTrace) => AppScreen(
            children: <Widget>[
              const PageHeader(title: 'Expense Details', subtitle: 'Error'),
              ErrorStateWidget(
                title: 'Unable to load expense',
                message: error.toString(),
                onRetry:
                    () => ref.invalidate(selectedExpenseProvider(expenseId)),
              ),
            ],
          ),
      data: (ExpenseRecord expense) {
        return AppScreen(
          children: <Widget>[
            PageHeader(
              title: expense.categoryName,
              subtitle: 'Expense Details',
              trailing: IconButton.filledTonal(
                onPressed:
                    () => ref
                        .read(navigationServiceProvider)
                        .goToEditExpense(context, expense.id),
                icon: const Icon(Icons.edit_outlined),
              ),
            ),
            StatCard(
              label: 'Amount',
              value: AppFormatters.currency(expense.amount),
              icon: Icons.currency_rupee_rounded,
            ),
            GlassCard(
              child: Column(
                children: <Widget>[
                  _DetailRow(
                    label: 'Date',
                    value: AppFormatters.date(expense.expenseDate),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _DetailRow(label: 'Category', value: expense.categoryName),
                  const SizedBox(height: AppSpacing.sm),
                  _DetailRow(
                    label: 'Vehicle',
                    value: expense.vehicleName ?? 'Not linked',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _DetailRow(
                    label: 'Driver',
                    value: expense.driverName ?? 'Not linked',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _DetailRow(
                    label: 'Remarks',
                    value: expense.remarks ?? 'Not set',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _DetailRow(
                    label: 'Created',
                    value: AppFormatters.date(expense.createdAt),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _DetailRow(
                    label: 'Updated',
                    value: AppFormatters.date(expense.updatedAt),
                  ),
                ],
              ),
            ),
            const SectionTitle(title: 'Delete'),
            const EmptyStateWidget(
              title: 'Delete Not Available',
              message:
                  'The current database keeps expense records active for audit history.',
              icon: Icons.lock_outline_rounded,
            ),
          ],
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: Text(label)),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
