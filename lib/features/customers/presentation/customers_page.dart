import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/aquaflow_fab.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/person_card.dart';
import '../../../core/shared/widgets/search_field.dart';
import '../../../core/shared/widgets/ui_state_switcher.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UiStateSwitcher(
      state: UiContentState.populated,
      emptyTitle: 'No Customers Yet',
      emptyMessage: 'Customer master data will appear here.',
      emptyIcon: Icons.people_outline_rounded,
      populated: AppScreen(
        floatingActionButton: AquaFlowFab(
          tooltip: 'Add customer',
          onPressed: () => context.go(AppRoutes.customerForm),
        ),
        children: <Widget>[
          const PageHeader(title: 'Customers', subtitle: 'Customer master'),
          const SearchField(label: 'Search customers'),
          PersonCard(
            title: 'Customer --',
            subtitle: 'Location --',
            icon: Icons.person_outline_rounded,
            onTap: () => context.go(AppRoutes.customerProfile),
          ),
          PersonCard(
            title: 'Customer --',
            subtitle: 'Location --',
            icon: Icons.person_outline_rounded,
            onTap: () => context.go(AppRoutes.customerProfile),
          ),
        ],
      ),
    );
  }
}
