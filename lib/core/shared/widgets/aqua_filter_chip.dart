import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

class AquaFilterChip extends StatelessWidget {
  const AquaFilterChip({
    required this.label,
    super.key,
    this.selected = false,
    this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}

class AquaFilterChipBar extends StatelessWidget {
  const AquaFilterChipBar({
    required this.labels,
    super.key,
    this.selectedIndex = 0,
  });

  final List<String> labels;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return AquaFilterChip(
            label: labels[index],
            selected: index == selectedIndex,
          );
        },
        separatorBuilder:
            (BuildContext context, int index) =>
                const SizedBox(width: AppSpacing.xs),
        itemCount: labels.length,
      ),
    );
  }
}
