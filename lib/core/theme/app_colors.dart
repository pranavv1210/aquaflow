import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Primary
  static const Color ocean900 = Color(0xFF0A2E4D);
  static const Color ocean600 = Color(0xFF115C8C);
  static const Color aqua400 = Color(0xFF22D3EE);

  // Surface - Light
  static const Color surfaceLight = Color(0xFFF6F9FC);
  static const Color surfaceElevatedLight = Color(0xFFFFFFFF);

  // Surface - Dark
  static const Color surfaceDark = Color(0xFF0B1420);
  static const Color surfaceElevatedDark = Color(0xFF131F2E);

  // Ink
  static const Color ink900 = Color(0xFF0F1B2A);
  static const Color ink500 = Color(0xFF5C7185);
  
  // Semantic
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFE23744);

  // Borders
  static const Color borderHairline = Color(0xFFE4EAF0);
  static const Color borderHairlineDark = Color(0xFF1F2937);

  // Legacy mappings (temporary until full replacement)
  static const Color deepOceanBlue = ocean900;
  static const Color brightCyan = aqua400;
  static const Color emeraldGreen = success;
  static const Color amber = warning;
  static const Color softRed = danger;
  static const Color surface = surfaceLight;
  static const Color veryLightBlue = Color(0xFFF1F9FF);
  static const Color ink700 = Color(0xFF334155);
  static const Color ink300 = Color(0xFFCBD5E1);
  static const Color glassStroke = Color(0x80FFFFFF);
  static const Color glassFill = Color(0xBFFFFFFF);
}
