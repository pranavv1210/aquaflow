import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import 'glass_card.dart';
import 'status_chip.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Order #--',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              StatusChip(label: 'Pending', color: colorScheme.primary),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetaRow(icon: Icons.person_outline_rounded, text: 'Customer --'),
          const SizedBox(height: AppSpacing.xs),
          _MetaRow(icon: Icons.location_on_outlined, text: 'Location --'),
          const SizedBox(height: AppSpacing.xs),
          _MetaRow(icon: Icons.local_shipping_outlined, text: 'Vehicle --'),
          const Divider(height: AppSpacing.xl),
          Row(
            children: <Widget>[
              Text('₹--', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              Text('-- loads', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
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
