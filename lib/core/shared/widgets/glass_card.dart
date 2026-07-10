import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_elevation.dart';
import '../../theme/app_glass.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.margin,
    this.radius = AppRadius.md,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppGlass.blur, sigmaY: AppGlass.blur),
        child: DecoratedBox(
          decoration: AppGlass.decoration(radius: radius).copyWith(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.white.withValues(alpha: 0.90),
                Colors.white.withValues(alpha: 0.62),
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
              ],
            ),
            boxShadow: AppElevation.soft,
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child:
          onTap == null
              ? card
              : Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(radius),
                  onTap:
                      onTap == null
                          ? null
                          : () {
                            HapticFeedback.selectionClick();
                            onTap?.call();
                          },
                  child: card,
                ),
              ),
    );
  }
}
