import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_design_tokens.dart';
import '../../theme/app_spacing.dart';

class FloatingBottomNavigationItem {
  const FloatingBottomNavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class FloatingBottomNavigation extends StatelessWidget {
  const FloatingBottomNavigation({
    required this.selectedIndex,
    required this.items,
    required this.onSelected,
    super.key,
  });

  final int selectedIndex;
  final List<FloatingBottomNavigationItem> items;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: ClipRRect(
        borderRadius: AppBorders.sheet,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: AppBlur.thin, sigmaY: AppBlur.thin),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.72),
              borderRadius: AppBorders.sheet,
              border: Border.all(color: Colors.white.withValues(alpha: 0.58)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.16),
                  blurRadius: 30,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                children: <Widget>[
                  for (var index = 0; index < items.length; index++)
                    Expanded(
                      child: _FloatingNavigationItem(
                        item: items[index],
                        selected: index == selectedIndex,
                        onTap: () => onSelected(index),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingNavigationItem extends StatelessWidget {
  const _FloatingNavigationItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final FloatingBottomNavigationItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
      color:
          selected
              ? colorScheme.primary
              : colorScheme.onSurface.withValues(alpha: 0.58),
    );

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: AppAnimationCurves.emphasized,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color:
                selected
                    ? colorScheme.primary.withValues(alpha: 0.10)
                    : Colors.transparent,
            borderRadius: AppBorders.pill,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedScale(
                scale: selected ? 1.08 : 1,
                duration: const Duration(milliseconds: 220),
                curve: AppAnimationCurves.emphasized,
                child: Icon(
                  selected ? item.selectedIcon : item.icon,
                  size: selected ? AppIconSizes.lg : AppIconSizes.md,
                  color:
                      selected
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.62),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
