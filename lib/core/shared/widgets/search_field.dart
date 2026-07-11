import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_design_tokens.dart';

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    required this.hintText,
    super.key,
    this.controller,
    this.onChanged,
    this.onFilterTap,
  });

  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final FocusNode _focusNode;
  bool _isFocused = false;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = widget.controller ?? TextEditingController();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      transform: Matrix4.identity()..scale(_isFocused ? 1.01 : 1.0),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: _isFocused ? AppColors.ocean600 : (isDark ? AppColors.borderHairlineDark : AppColors.borderHairline),
          width: 1,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.aqua400.withValues(alpha: 0.20),
                  blurRadius: 12,
                  spreadRadius: 2,
                )
              ]
            : [],
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.ink500,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.ink500,
            size: AppIconSizes.md,
          ),
          suffixIcon: widget.onFilterTap != null
              ? IconButton(
                  icon: const Icon(Icons.tune_rounded, color: AppColors.ink500),
                  onPressed: widget.onFilterTap,
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

// Legacy wrapper to avoid breaking changes immediately
class SearchField extends StatelessWidget {
  const SearchField({
    required this.label,
    super.key,
    this.controller,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return AppSearchBar(
      hintText: label,
      controller: controller,
      onChanged: onChanged,
    );
  }
}

class PremiumSearchBar extends StatelessWidget {
  const PremiumSearchBar({
    required this.label,
    super.key,
    this.controller,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SearchField(
      label: label,
      controller: controller,
      onChanged: onChanged,
    );
  }
}
