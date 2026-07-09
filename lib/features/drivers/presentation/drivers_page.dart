import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/person_card.dart';
import '../../../core/shared/widgets/search_field.dart';
import '../../../core/shared/widgets/ui_state_switcher.dart';

class DriversPage extends StatelessWidget {
  const DriversPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UiStateSwitcher(
      state: UiContentState.populated,
      emptyTitle: 'No Drivers Yet',
      emptyIcon: Icons.badge_outlined,
      populated: AppScreen(
        children: <Widget>[
          const PageHeader(title: 'Drivers', subtitle: 'Driver master'),
          const SearchField(label: 'Search drivers'),
          PersonCard(
            title: 'Driver --',
            subtitle: 'Vehicle --',
            icon: Icons.badge_outlined,
            onTap: () => context.go(AppRoutes.driverProfile),
          ),
          PersonCard(
            title: 'Driver --',
            subtitle: 'Vehicle --',
            icon: Icons.badge_outlined,
            onTap: () => context.go(AppRoutes.driverProfile),
          ),
        ],
      ),
    );
  }
}
