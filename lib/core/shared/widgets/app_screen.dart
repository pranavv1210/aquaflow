import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter_animate/flutter_animate.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'page_header.dart';

class AppScreen extends StatefulWidget {
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
    this.onRefresh,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final Widget? floatingActionButton;
  final RefreshCallback? onRefresh;

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  late ScrollController _scrollController;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final isScrolled = _scrollController.offset > 10;
      if (isScrolled != _isScrolled) {
        setState(() {
          _isScrolled = isScrolled;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasHeader =
        widget.children.isNotEmpty && widget.children.first is PageHeader;
    final headerWidget = hasHeader ? widget.children.first as PageHeader : null;
    final contentChildren =
        hasHeader ? widget.children.sublist(1) : widget.children;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    Widget sliverList = SliverPadding(
      padding: widget.padding,
      sliver: SliverList.separated(
        itemBuilder: (BuildContext context, int index) {
          // Only animate the first 6-8 items for performance
          final child = contentChildren[index];
          if (index < 8) {
            return child
                .animate(delay: Duration(milliseconds: index * 35))
                .fadeIn(duration: const Duration(milliseconds: 220))
                .slideY(
                  begin: 0.05,
                  end: 0,
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                );
          }
          return child;
        },
        separatorBuilder:
            (BuildContext context, int index) =>
                const SizedBox(height: AppSpacing.md),
        itemCount: contentChildren.length,
      ),
    );

    if (widget.onRefresh != null) {
      sliverList = SliverMainAxisGroup(
        slivers: [
          cupertino.CupertinoSliverRefreshControl(
            onRefresh: widget.onRefresh,
            builder: (
              context,
              refreshState,
              pulledExtent,
              refreshTriggerPullDistance,
              refreshIndicatorExtent,
            ) {
              return Center(
                child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.aqua400, width: 2),
                      ),
                      child: Center(
                        child: Container(
                          width:
                              16 *
                              (pulledExtent / refreshTriggerPullDistance).clamp(
                                0.0,
                                1.0,
                              ),
                          height:
                              16 *
                              (pulledExtent / refreshTriggerPullDistance).clamp(
                                0.0,
                                1.0,
                              ),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.aqua400,
                          ),
                        ),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(),
                      target:
                          refreshState == cupertino.RefreshIndicatorMode.refresh
                              ? 1
                              : 0,
                    )
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.5, 1.5),
                      duration: const Duration(milliseconds: 1000),
                    )
                    .fadeOut(duration: const Duration(milliseconds: 1000)),
              );
            },
          ),
          sliverList,
        ],
      );
    }

    final scrollView = CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: <Widget>[
        if (headerWidget != null)
          SliverAppBar(
            backgroundColor: bgColor,
            surfaceTintColor: Colors.transparent,
            pinned: true,
            toolbarHeight: 122,
            elevation: _isScrolled ? 1 : 0,
            shadowColor: AppColors.ink900.withValues(alpha: 0.1),
            forceElevated: _isScrolled,
            automaticallyImplyLeading: false,
            bottom:
                _isScrolled
                    ? PreferredSize(
                      preferredSize: const Size.fromHeight(1),
                      child: Container(
                        color:
                            isDark
                                ? AppColors.borderHairlineDark
                                : AppColors.borderHairline,
                        height: 1,
                      ),
                    )
                    : null,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: headerWidget.buildHeaderContent(context),
            ),
          ),
        sliverList,
      ],
    );

    final content = Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: scrollView,
      ),
    );

    Widget decorated = ColoredBox(
      color: bgColor,
      child: Stack(fit: StackFit.expand, children: <Widget>[content]),
    );

    if (widget.floatingActionButton == null) {
      return decorated;
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: decorated,
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
