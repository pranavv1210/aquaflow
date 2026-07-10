import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../widgets/glass_card.dart';
import '../widgets/status_chip.dart';

class BaseInfoCard extends StatelessWidget {
  const BaseInfoCard({
    required this.title,
    required this.subtitle,
    super.key,
    this.icon = Icons.inventory_2_outlined,
    this.status,
    this.statusColor,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String? status;
  final Color? statusColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GlassCard(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(icon, color: colorScheme.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xxs),
                Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          if (status != null)
            StatusChip(
              label: status!,
              color: statusColor ?? colorScheme.primary,
            )
          else
            trailing ?? const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}
