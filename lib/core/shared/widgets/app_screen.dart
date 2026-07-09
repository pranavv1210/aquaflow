import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({
    required this.children,
    super.key,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.md,
      AppSpacing.lg,
      AppSpacing.md,
      AppSpacing.xxl,
    ),
    this.floatingActionButton,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final content = CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: padding,
          sliver: SliverList.separated(
            itemBuilder: (BuildContext context, int index) => children[index],
            separatorBuilder:
                (BuildContext context, int index) =>
                    const SizedBox(height: AppSpacing.md),
            itemCount: children.length,
          ),
        ),
      ],
    );

    if (floatingActionButton == null) {
      return content;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: content,
      floatingActionButton: floatingActionButton,
    );
  }
}
