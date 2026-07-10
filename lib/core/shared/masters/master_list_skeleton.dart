import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../widgets/glass_card.dart';
import '../widgets/skeleton_loader.dart';

class MasterListSkeleton extends StatelessWidget {
  const MasterListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(3, (int index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.md),
          child: GlassCard(
            child: Row(
              children: <Widget>[
                SkeletonLoader(height: 48, width: 48, radius: 24),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SkeletonLoader(width: 160),
                      SizedBox(height: AppSpacing.sm),
                      SkeletonLoader(width: 110, height: 12),
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
