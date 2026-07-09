import 'package:flutter/material.dart';

import 'app_text_field.dart';

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
    return AppTextField(
      label: label,
      controller: controller,
      prefixIcon: Icons.search_rounded,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
    );
  }
}
