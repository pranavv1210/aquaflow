import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppElevation {
  const AppElevation._();

  static const List<BoxShadow> soft = <BoxShadow>[
    BoxShadow(color: Color(0x140A2E4D), blurRadius: 24, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> medium = <BoxShadow>[
    BoxShadow(color: Color(0x1F0A2E4D), blurRadius: 32, offset: Offset(0, 12)),
  ];

  static BorderSide get subtleBorder =>
      const BorderSide(color: AppColors.borderHairline);
}
