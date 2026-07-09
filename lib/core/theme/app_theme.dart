import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_typography.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.deepOceanBlue,
      brightness: Brightness.light,
      primary: AppColors.deepOceanBlue,
      secondary: AppColors.aquaBlue,
      tertiary: AppColors.brightCyan,
      error: AppColors.softRed,
      surface: AppColors.surface,
    );

    return FlexThemeData.light(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackground: AppColors.veryLightBlue,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 6,
      appBarElevation: 0,
      subThemesData: const FlexSubThemesData(
        defaultRadius: AppRadius.md,
        interactionEffects: true,
        tintedDisabledControls: true,
        inputDecoratorIsFilled: true,
        inputDecoratorBorderType: FlexInputBorderType.outline,
      ),
      textTheme: AppTypography.textTheme(scheme),
      fontFamily: 'Inter',
    );
  }
}
