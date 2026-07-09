import 'package:flutter/material.dart';

import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/aqua_filter_chip.dart';
import '../../../core/shared/widgets/empty_state_widget.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/search_field.dart';
import '../../../core/shared/widgets/ui_state_switcher.dart';

class GlobalSearchPage extends StatelessWidget {
  const GlobalSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UiStateSwitcher(
      state: UiContentState.populated,
      emptyTitle: 'No Results',
      emptyIcon: Icons.search_off_rounded,
      populated: AppScreen(
        children: <Widget>[
          PageHeader(title: 'Global Search', subtitle: 'Search AquaFlow'),
          SearchField(label: 'Search orders, customers, vehicles'),
          AquaFilterChipBar(
            labels: <String>['All', 'Orders', 'Customers', 'Vehicles'],
          ),
          EmptyStateWidget(
            title: 'No Results Yet',
            message: 'Enter a search term to view matching records.',
            icon: Icons.search_rounded,
          ),
        ],
      ),
    );
  }
}
