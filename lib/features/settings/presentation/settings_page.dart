import 'package:flutter/material.dart';

import '../../../core/shared/widgets/action_tile.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/glass_card.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/ui_state_switcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UiStateSwitcher(
      state: UiContentState.populated,
      emptyTitle: 'No Settings',
      populated: AppScreen(
        children: <Widget>[
          PageHeader(title: 'Settings', subtitle: 'App configuration'),
          GlassCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                ActionTile(
                  title: 'Business Profile',
                  subtitle: 'AquaFlow',
                  icon: Icons.storefront_outlined,
                ),
                ActionTile(
                  title: 'Currency',
                  subtitle: 'Indian Rupee',
                  icon: Icons.currency_rupee_rounded,
                ),
                ActionTile(
                  title: 'Date Format',
                  subtitle: 'dd MMM yyyy',
                  icon: Icons.calendar_today_outlined,
                ),
                ActionTile(
                  title: 'About',
                  subtitle: 'Water Management System',
                  icon: Icons.info_outline_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
