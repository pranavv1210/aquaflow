import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/search_field.dart';
import '../../../core/shared/widgets/ui_state_switcher.dart';
import '../../../core/shared/widgets/vehicle_card.dart';

class VehiclesPage extends StatelessWidget {
  const VehiclesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UiStateSwitcher(
      state: UiContentState.populated,
      emptyTitle: 'No Vehicles Yet',
      emptyIcon: Icons.local_shipping_outlined,
      populated: AppScreen(
        children: <Widget>[
          const PageHeader(title: 'Vehicles', subtitle: 'Tanker fleet'),
          const SearchField(label: 'Search vehicles'),
          VehicleCard(
            title: 'Vehicle --',
            subtitle: 'Driver --',
            status: '--',
            onTap: () => context.go(AppRoutes.vehicleDetails),
          ),
          VehicleCard(
            title: 'Vehicle --',
            subtitle: 'Driver --',
            status: '--',
            onTap: () => context.go(AppRoutes.vehicleDetails),
          ),
        ],
      ),
    );
  }
}
