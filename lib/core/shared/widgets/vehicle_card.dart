import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import 'glass_card.dart';
import 'status_chip.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    required this.title,
    required this.subtitle,
    required this.status,
    super.key,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GlassCard(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.local_shipping_rounded,
            color: colorScheme.primary,
            size: 34,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xxs),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          StatusChip(label: status, color: colorScheme.secondary),
        ],
      ),
    );
  }
}
