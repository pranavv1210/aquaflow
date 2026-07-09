import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import 'glass_card.dart';
import 'section_title.dart';

class FormSection extends StatelessWidget {
  const FormSection({required this.title, required this.children, super.key});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SectionTitle(title: title),
        GlassCard(
          child: Column(
            children: List<Widget>.generate(children.length * 2 - 1, (int i) {
              if (i.isOdd) {
                return const SizedBox(height: AppSpacing.md);
              }
              return children[i ~/ 2];
            }),
          ),
        ),
      ],
    );
  }
}
