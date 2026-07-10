import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class SnackbarService {
  const SnackbarService._();

  static void success(String message) {
    _show(message, backgroundColor: AppColors.emeraldGreen);
  }

  static void error(String message) {
    _show(message, backgroundColor: AppColors.softRed);
  }

  static void warning(String message) {
    _show(message, backgroundColor: AppColors.amber);
  }

  static void info(String message) {
    _show(message, backgroundColor: AppColors.deepOceanBlue);
  }

  static void _show(String message, {required Color backgroundColor}) {
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) {
      return;
    }
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
