import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

extension AquaFlowColorScheme on ColorScheme {
  Color get success => AppColors.emeraldGreen;
  Color get warning => AppColors.amber;
  Color get accent => AppColors.brightCyan;
  Color get mutedText => AppColors.ink500;
}
