import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_design_tokens.dart';
import '../../theme/app_elevation.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

class PremiumBottomSheet extends StatelessWidget {
  const PremiumBottomSheet({required this.child, super.key});

  final Widget child;

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      builder:
          (BuildContext context) => PremiumBottomSheet(child: builder(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.xl),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppBlur.heavy, sigmaY: AppBlur.heavy),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppGradients.glass(Theme.of(context).colorScheme.primary),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl),
            ),
            border: Border(top: AppBorders.glass()),
            boxShadow: AppElevation.medium,
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.18),
                      borderRadius: AppBorders.pill,
                    ),
                    child: const SizedBox(width: 44, height: 4),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
