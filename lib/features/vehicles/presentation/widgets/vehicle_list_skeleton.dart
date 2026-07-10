import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/shared/widgets/skeleton_loader.dart';
import '../../../../core/theme/app_spacing.dart';

class VehicleListSkeleton extends StatelessWidget {
  const VehicleListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(4, (int index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.md),
          child: GlassCard(
            child: Row(
              children: <Widget>[
                SkeletonLoader(width: 44, height: 44, radius: 22),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SkeletonLoader(height: 16),
                      SizedBox(height: AppSpacing.sm),
                      SkeletonLoader(width: 140, height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
