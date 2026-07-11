import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_colors.dart';
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
    return Tooltip(
      message: tooltip ?? '',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 16,
            sigmaY: 16,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.ocean900.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.ocean900.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                overlayColor: WidgetStateProperty.all(AppColors.aqua400.withValues(alpha: 0.2)),
                onTap:
                    onPressed == null
                        ? null
                        : () {
                          HapticFeedback.lightImpact();
                          onPressed?.call();
                        },
                child: SizedBox.square(
                  dimension: 58,
                  child: Icon(icon, color: Colors.white, size: 24),
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
