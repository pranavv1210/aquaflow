import 'package:flutter/material.dart';

import '../../core/shared/widgets/app_buttons.dart';
import '../../core/shared/widgets/app_screen.dart';
import '../../core/shared/widgets/confirmation_dialog.dart';
import '../../core/shared/widgets/form_section.dart';
import '../../core/shared/widgets/glass_card.dart';
import '../../core/shared/widgets/page_header.dart';
import '../../core/shared/widgets/stat_card.dart';
import '../../core/shared/widgets/timeline_tile.dart';
import '../../core/shared/widgets/ui_state_switcher.dart';
import '../../core/theme/app_spacing.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UiStateSwitcher(
      state: UiContentState.populated,
      emptyTitle: 'Order Not Found',
      errorTitle: 'Unable to Load Order',
      populated: AppScreen(
        children: <Widget>[
          const PageHeader(title: 'Order Details', subtitle: 'Order #--'),
          const GlassCard(
            child: Column(
              children: <Widget>[
                AquaTimelineTile(
                  title: 'Order Created',
                  subtitle: '--',
                  icon: Icons.add_circle_outline_rounded,
                ),
                AquaTimelineTile(
                  title: 'Delivery Status',
                  subtitle: '--',
                  icon: Icons.local_shipping_outlined,
                ),
                AquaTimelineTile(
                  title: 'Payment Status',
                  subtitle: '--',
                  icon: Icons.currency_rupee_rounded,
                  isLast: true,
                ),
              ],
            ),
          ),
          const FormSection(
            title: 'Customer',
            children: <Widget>[
              _DetailLine(label: 'Name', value: '--'),
              _DetailLine(label: 'Location', value: '--'),
              _DetailLine(label: 'Water Point', value: '--'),
            ],
          ),
          const FormSection(
            title: 'Vehicle',
            children: <Widget>[
              _DetailLine(label: 'Vehicle', value: '--'),
              _DetailLine(label: 'Driver', value: '--'),
              _DetailLine(label: 'Partner Tanker', value: '--'),
            ],
          ),
          const FormSection(
            title: 'Payment',
            children: <Widget>[
              StatCard(
                label: 'Amount',
                value: '₹--',
                icon: Icons.currency_rupee_rounded,
              ),
              _DetailLine(label: 'Payment Status', value: '--'),
              _DetailLine(label: 'Remarks', value: '--'),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: SecondaryButton(
                  label: 'Delete',
                  icon: Icons.delete_outline_rounded,
                  onPressed: () {
                    ConfirmationDialog.show(
                      context,
                      title: 'Delete Order?',
                      message: 'This is a UI-only confirmation.',
                      isDestructive: true,
                    );
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: PrimaryButton(
                  label: 'Edit',
                  icon: Icons.edit_outlined,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(label)),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
