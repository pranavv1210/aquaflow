import 'package:flutter/material.dart';

import '../../../../core/helpers/app_formatters.dart';
import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/expense_record.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({required this.expense, super.key, this.onTap});

  final ExpenseRecord expense;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  expense.categoryName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                AppFormatters.currency(expense.amount),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetaRow(
            icon: Icons.event_outlined,
            text: AppFormatters.date(expense.expenseDate),
          ),
          if (expense.vehicleName != null) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            _MetaRow(
              icon: Icons.local_shipping_outlined,
              text: expense.vehicleName!,
            ),
          ],
          if (expense.driverName != null) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            _MetaRow(icon: Icons.badge_outlined, text: expense.driverName!),
          ],
          if (expense.remarks != null) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            _MetaRow(icon: Icons.notes_outlined, text: expense.remarks!),
          ],
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: AppSpacing.xs),
        Expanded(child: Text(text, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
