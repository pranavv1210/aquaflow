import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
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
    final content = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
      ),
    );

    final decorated = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.veryLightBlue,
            Colors.white,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
          ],
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -96,
            right: -72,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.12),
              ),
              child: const SizedBox.square(dimension: 220),
            ),
          ),
          Positioned(
            bottom: 120,
            left: -96,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.brightCyan.withValues(alpha: 0.10),
              ),
              child: const SizedBox.square(dimension: 240),
            ),
          ),
          content,
        ],
      ),
    );

    if (floatingActionButton == null) {
      return decorated;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: decorated,
      floatingActionButton: floatingActionButton,
    );
  }
}
