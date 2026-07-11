import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_typography.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.ocean900,
      brightness: Brightness.light,
      primary: AppColors.ocean600,
      secondary: AppColors.aqua400,
      tertiary: AppColors.ocean900,
      error: AppColors.danger,
      surface: AppColors.surfaceLight,
    );

    return FlexThemeData.light(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackground: AppColors.surfaceLight,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 0, // Keep colors pure
      appBarElevation: 0,
      subThemesData: const FlexSubThemesData(
        defaultRadius: AppRadius.md,
        interactionEffects: true,
        tintedDisabledControls: true,
        inputDecoratorIsFilled: true,
        inputDecoratorFillColor: AppColors.surfaceElevatedLight,
        inputDecoratorBorderType: FlexInputBorderType.outline,
      ),
      textTheme: AppTypography.textTheme(scheme),
      fontFamily: 'Inter',
    ).copyWith(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.ocean900,
      brightness: Brightness.dark,
      primary: AppColors.ocean600,
      secondary: AppColors.aqua400,
      tertiary: AppColors.ocean900,
      error: AppColors.danger,
      surface: AppColors.surfaceDark,
    );

    return FlexThemeData.dark(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackground: AppColors.surfaceDark,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 0,
      appBarElevation: 0,
      subThemesData: const FlexSubThemesData(
        defaultRadius: AppRadius.md,
        interactionEffects: true,
        tintedDisabledControls: true,
        inputDecoratorIsFilled: true,
        inputDecoratorFillColor: AppColors.surfaceElevatedDark,
        inputDecoratorBorderType: FlexInputBorderType.outline,
      ),
      textTheme: AppTypography.textTheme(scheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      fontFamily: 'Inter',
    ).copyWith(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
