import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';

class AppGlass {
  const AppGlass._();

  static const double blur = 18;
  static const double heavyBlur = 28;
  static const double opacity = 0.78;

  static BoxDecoration decoration({
    double radius = AppRadius.md,
    Color color = AppColors.glassFill,
  }) {
    return BoxDecoration(
      color: color.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.glassStroke),
    );
  }

  static ImageFilter blurFilter([double sigma = blur]) {
    return ImageFilter.blur(sigmaX: sigma, sigmaY: sigma);
  }
}
