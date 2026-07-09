import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/shared/widgets/action_tile.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/glass_card.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/ui_state_switcher.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return UiStateSwitcher(
      state: UiContentState.populated,
      emptyTitle: 'No Options',
      populated: AppScreen(
        children: <Widget>[
          const PageHeader(title: 'More', subtitle: 'Search and preferences'),
          GlassCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                ActionTile(
                  title: 'Global Search',
                  subtitle: 'Search across app sections',
                  icon: Icons.search_rounded,
                  onTap: () => context.go(AppRoutes.globalSearch),
                ),
                ActionTile(
                  title: 'Settings',
                  subtitle: 'App preferences',
                  icon: Icons.settings_outlined,
                  onTap: () => context.go(AppRoutes.settings),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
