import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/application/navigation_providers.dart';
import '../../../core/helpers/app_formatters.dart';
import '../../../core/models/expense_category.dart';
import '../../../core/shared/masters/master_dialogs.dart';
import '../../../core/shared/widgets/app_buttons.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/empty_state_widget.dart';
import '../../../core/shared/widgets/error_state_widget.dart';
import '../../../core/shared/widgets/glass_card.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/section_title.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/expense_category_providers.dart';
import 'widgets/expense_category_list_skeleton.dart';

class ExpenseCategoryProfilePage extends ConsumerWidget {
  const ExpenseCategoryProfilePage({
    required this.expenseCategoryId,
    super.key,
  });
  final String expenseCategoryId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ec = ref.watch(selectedExpenseCategoryProvider(expenseCategoryId));
    return switch (ec) {
      AsyncData<ExpenseCategory>(:final value) =>
        _ExpenseCategoryProfileContent(expenseCategory: value),
      AsyncError<ExpenseCategory>(:final error) => AppScreen(
        children: [
          const PageHeader(
            title: 'Expense Category Profile',
            subtitle: 'Error',
          ),
          ErrorStateWidget(
            title: 'Unable to load expense category',
            message: error.toString(),
            onRetry:
                () => ref.invalidate(
                  selectedExpenseCategoryProvider(expenseCategoryId),
                ),
          ),
        ],
      ),
      _ => const AppScreen(
        children: [
          PageHeader(title: 'Expense Category Profile', subtitle: 'Loading...'),
          ExpenseCategoryListSkeleton(),
        ],
      ),
    };
  }
}

class _ExpenseCategoryProfileContent extends ConsumerWidget {
  const _ExpenseCategoryProfileContent({required this.expenseCategory});
  final ExpenseCategory expenseCategory;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScreen(
      children: [
        PageHeader(
          title: expenseCategory.categoryName,
          subtitle: 'Expense Category Profile',
          trailing: IconButton.filledTonal(
            onPressed:
                () => ref
                    .read(navigationServiceProvider)
                    .goToEditExpenseCategory(context, expenseCategory.id),
            icon: const Icon(Icons.edit_outlined),
          ),
        ),
        GlassCard(
          child: Column(
            children: [
              _DetailRow(
                label: 'Expense Type',
                value: expenseCategory.expenseType,
              ),
              const SizedBox(height: AppSpacing.sm),
              _DetailRow(
                label: 'Description',
                value: expenseCategory.description ?? 'Not set',
              ),
              const SizedBox(height: AppSpacing.sm),
              _DetailRow(
                label: 'Created',
                value: AppFormatters.date(expenseCategory.createdAt),
              ),
              const SizedBox(height: AppSpacing.sm),
              _DetailRow(
                label: 'Updated',
                value: AppFormatters.date(expenseCategory.updatedAt),
              ),
            ],
          ),
        ),
        const SectionTitle(title: 'Related Expenses'),
        const EmptyStateWidget(
          title: 'Expenses Pending',
          message:
              'Expenses will appear after the Expenses phase is connected.',
          icon: Icons.receipt_long_outlined,
        ),
        SecondaryButton(
          label: 'Delete Category',
          icon: Icons.delete_outline_rounded,
          onPressed: () async {
            final confirmed = await MasterDialogs.confirmDelete(
              context,
              title: 'Delete Category?',
              message:
                  'This will deactivate the expense category without removing history.',
            );
            if (!confirmed || !context.mounted) {
              return;
            }
            final result = await ref.read(deleteExpenseCategoryUseCaseProvider)(
              expenseCategory.id,
            );
            result.when(
              success: (_) {
                ref.invalidate(expenseCategoryListProvider);
                ref.invalidate(
                  selectedExpenseCategoryProvider(expenseCategory.id),
                );
                if (context.mounted) {
                  MasterDialogs.showSaved(context, 'Category deleted');
                  ref
                      .read(navigationServiceProvider)
                      .goToExpenseCategories(context);
                }
              },
              failure: (e) {
                if (context.mounted) {
                  MasterDialogs.showError(context, e.message);
                }
              },
            );
          },
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
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
