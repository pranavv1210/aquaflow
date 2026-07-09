import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/shared/widgets/app_screen.dart';
import '../../core/shared/widgets/aqua_filter_chip.dart';
import '../../core/shared/widgets/aquaflow_fab.dart';
import '../../core/shared/widgets/order_card.dart';
import '../../core/shared/widgets/page_header.dart';
import '../../core/shared/widgets/search_field.dart';
import '../../core/shared/widgets/ui_state_switcher.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UiStateSwitcher(
      state: UiContentState.populated,
      emptyTitle: 'No Orders Yet',
      emptyMessage: 'Orders entered by the owner will appear here.',
      emptyIcon: Icons.receipt_long_outlined,
      populated: AppScreen(
        floatingActionButton: AquaFlowFab(
          tooltip: 'New order',
          onPressed: () => context.go(AppRoutes.newOrder),
        ),
        children: <Widget>[
          PageHeader(
            title: 'Orders',
            subtitle: 'Search and filter tanker deliveries',
            trailing: IconButton.filledTonal(
              onPressed: () => _showFilterSheet(context),
              icon: const Icon(Icons.tune_rounded),
            ),
          ),
          const SearchField(label: 'Search orders'),
          const AquaFilterChipBar(
            labels: <String>['All', 'Pending', 'Delivered', 'Paid'],
          ),
          OrderCard(onTap: () => context.go(AppRoutes.orderDetails)),
          OrderCard(onTap: () => context.go(AppRoutes.orderDetails)),
          OrderCard(onTap: () => context.go(AppRoutes.orderDetails)),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.filter_list_rounded),
                title: Text('Filter Orders'),
                subtitle: Text('Filter controls are UI placeholders.'),
              ),
              AquaFilterChipBar(
                labels: <String>['Today', 'Week', 'Month', 'Custom'],
              ),
            ],
          ),
        );
      },
    );
  }
}
