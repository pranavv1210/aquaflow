import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_design_tokens.dart';
import '../../theme/app_elevation.dart';
import '../../theme/app_radius.dart';

class AquaFlowFab extends StatelessWidget {
  const AquaFlowFab({
    required this.onPressed,
    super.key,
    this.tooltip,
    this.icon = Icons.add_rounded,
  });

  final VoidCallback? onPressed;
  final String? tooltip;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip ?? '',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppBlur.medium,
            sigmaY: AppBlur.medium,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppGradients.action(colorScheme.primary),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: Colors.white.withValues(alpha: 0.42)),
              boxShadow: AppElevation.medium,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap:
                    onPressed == null
                        ? null
                        : () {
                          HapticFeedback.lightImpact();
                          onPressed?.call();
                        },
                child: SizedBox.square(
                  dimension: 58,
                  child: Icon(icon, color: Colors.white, size: AppIconSizes.lg),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PremiumFAB extends StatelessWidget {
  const PremiumFAB({
    required this.onPressed,
    super.key,
    this.tooltip,
    this.icon = Icons.add_rounded,
  });

  final VoidCallback? onPressed;
  final String? tooltip;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AquaFlowFab(onPressed: onPressed, tooltip: tooltip, icon: icon);
  }
}
