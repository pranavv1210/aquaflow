import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

class AppGradients {
  const AppGradients._();

  static const LinearGradient screen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[AppColors.veryLightBlue, Colors.white, Color(0x14075985)],
  );

  static LinearGradient glass(Color primary) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Colors.white.withValues(alpha: 0.92),
        Colors.white.withValues(alpha: 0.64),
        primary.withValues(alpha: 0.06),
      ],
    );
  }

  static LinearGradient action(Color primary) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[primary, AppColors.aquaBlue],
    );
  }
}

class AppBlur {
  const AppBlur._();

  static const double thin = 12;
  static const double medium = 18;
  static const double heavy = 28;
}

class AppIconSizes {
  const AppIconSizes._();

  static const double sm = 18;
  static const double md = 22;
  static const double lg = 26;
  static const double xl = 34;
}

class AppPadding {
  const AppPadding._();

  static const EdgeInsets screen = EdgeInsets.fromLTRB(
    AppSpacing.md,
    AppSpacing.lg,
    AppSpacing.md,
    AppSpacing.xxxl,
  );
  static const EdgeInsets card = EdgeInsets.all(AppSpacing.md);
  static const EdgeInsets dialog = EdgeInsets.all(AppSpacing.lg);
  static const EdgeInsets field = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.sm,
  );
}

class AppAnimationCurves {
  const AppAnimationCurves._();

  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeOutBack;
  static const Curve entrance = Curves.easeOutQuart;
}

class AppBorders {
  const AppBorders._();

  static BorderRadius get card => BorderRadius.circular(AppRadius.md);
  static BorderRadius get sheet => BorderRadius.circular(AppRadius.xl);
  static BorderRadius get pill => BorderRadius.circular(AppRadius.pill);

  static BorderSide glass([double opacity = 0.58]) {
    return BorderSide(color: Colors.white.withValues(alpha: opacity));
  }
}
