import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import 'glass_card.dart';
import 'skeleton_loader.dart';

class ChartPlaceholder extends StatelessWidget {
  const ChartPlaceholder({required this.title, required this.icon, super.key});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Column(
              children: const <Widget>[
                SkeletonLoader(height: 24),
                SizedBox(height: AppSpacing.sm),
                SkeletonLoader(height: 72),
                SizedBox(height: AppSpacing.sm),
                SkeletonLoader(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
