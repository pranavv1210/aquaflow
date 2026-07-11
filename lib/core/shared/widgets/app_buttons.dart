import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_design_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final child =
        isLoading
            ? const SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
            : _ButtonContent(label: label, icon: icon);

    return FilledButton(
      onPressed:
          isLoading || onPressed == null
              ? null
              : () {
                HapticFeedback.lightImpact();
                onPressed?.call();
              },
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.ocean900,
        foregroundColor: Colors.white,
        overlayColor: AppColors.aqua400,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      child: child,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed:
          onPressed == null
              ? null
              : () {
                HapticFeedback.selectionClick();
                onPressed?.call();
              },
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ocean600,
        side: const BorderSide(color: AppColors.ocean600),
        overlayColor: AppColors.aqua400,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      child: _ButtonContent(label: label, icon: icon),
    );
  }
}

class GlassButton extends StatelessWidget {
  const GlassButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SecondaryButton(label: label, onPressed: onPressed, icon: icon);
  }
}

class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      tooltip: tooltip,
      onPressed:
          onPressed == null
              ? null
              : () {
                HapticFeedback.selectionClick();
                onPressed?.call();
              },
      iconSize: AppIconSizes.md,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.ocean600.withValues(alpha: 0.1),
        foregroundColor: AppColors.ocean600,
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (icon != null) ...<Widget>[
          Icon(icon, size: 18),
          const SizedBox(width: AppSpacing.xs),
        ],
        Flexible(
          child: Text(
            label, 
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          )
        ),
      ],
    );
  }
}
