import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({
    super.key,
    this.height = 16,
    this.width,
    this.radius = AppRadius.sm,
  });

  final double height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: AppColors.ink300.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(radius),
          ),
        )
        .animate(
          onPlay: (AnimationController controller) => controller.repeat(),
        )
        .shimmer(duration: const Duration(milliseconds: 1100));
  }
}
