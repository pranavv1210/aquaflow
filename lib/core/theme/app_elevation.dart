import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppElevation {
  const AppElevation._();

  static const List<BoxShadow> soft = <BoxShadow>[
    BoxShadow(color: Color(0x14075985), blurRadius: 18, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> medium = <BoxShadow>[
    BoxShadow(color: Color(0x1F075985), blurRadius: 28, offset: Offset(0, 14)),
  ];

  static BorderSide get subtleBorder =>
      const BorderSide(color: AppColors.glassStroke);
}
