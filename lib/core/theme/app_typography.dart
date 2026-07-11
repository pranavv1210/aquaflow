import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTypography {
  const AppTypography._();

  static TextTheme textTheme(ColorScheme colorScheme) {
    return TextTheme(
      // Display / Headers: Manrope (geometric, confident)
      displayLarge: GoogleFonts.manrope(
        fontSize: 28,
        height: 34 / 28,
        fontWeight: FontWeight.w700,
        color: AppColors.ink900,
      ),
      displayMedium: GoogleFonts.manrope(
        fontSize: 24,
        height: 30 / 24,
        fontWeight: FontWeight.w700,
        color: AppColors.ink900,
      ),
      displaySmall: GoogleFonts.manrope(
        fontSize: 22,
        height: 28 / 22,
        fontWeight: FontWeight.w700,
        color: AppColors.ink900,
      ),
      
      // Title: Manrope
      titleLarge: GoogleFonts.manrope(
        fontSize: 20,
        height: 26 / 20,
        fontWeight: FontWeight.w700,
        color: AppColors.ink900,
      ),
      // Subtitle: Inter
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        height: 22 / 16,
        fontWeight: FontWeight.w600,
        color: AppColors.ink900,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
        color: AppColors.ink900,
      ),

      // Body / UI text: Inter
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        height: 22 / 16,
        fontWeight: FontWeight.w400,
        color: AppColors.ink500,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w500,
        color: AppColors.ink900,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w400,
        color: AppColors.ink500,
      ),

      // Caption / Meta: Inter
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
        color: AppColors.ink900,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w500,
        color: AppColors.ink500,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        height: 14 / 10,
        fontWeight: FontWeight.w500,
        color: AppColors.ink500,
      ),
    );
  }
}
