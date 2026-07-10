import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/navigation_providers.dart';
import '../../../core/models/vehicle.dart';
import '../../../core/shared/masters/base_master_page.dart';
import '../application/vehicle_providers.dart';
import 'widgets/vehicle_card.dart';
import 'widgets/vehicle_list_skeleton.dart';

class VehiclesPage extends ConsumerWidget {
  const VehiclesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.watch(navigationServiceProvider);
    ref.listen(vehicleRealtimeProvider, (
      _,
      AsyncValue<List<Map<String, dynamic>>> next,
    ) {
      if (next.hasValue) {
        ref.invalidate(vehicleListProvider);
      }
    });

    return BaseMasterPage<Vehicle>(
      title: 'Vehicles',
      subtitle: 'Tanker fleet',
      searchLabel: 'Search vehicles',
      emptyTitle: 'No Vehicles Yet',
      emptyMessage: 'Add your first vehicle to manage your fleet.',
      emptyIcon: Icons.local_shipping_outlined,
      onAdd: () => navigation.goToVehicleForm(context),
      loadItems: (WidgetRef ref, String query) {
        return query.isEmpty
            ? ref.watch(vehicleListProvider)
            : ref.watch(vehicleSearchProvider(query));
      },
      buildLoading: VehicleListSkeleton.new,
      onRefresh: (WidgetRef ref, String query) async {
        if (query.isEmpty) {
          ref.invalidate(vehicleListProvider);
        } else {
          ref.invalidate(vehicleSearchProvider(query));
        }
        await Future<void>.delayed(const Duration(milliseconds: 250));
      },
      buildItem: (BuildContext context, Vehicle vehicle) {
        return VehicleCard(
          vehicle: vehicle,
          onTap: () => navigation.goToVehicleDetails(context, vehicle.id),
        );
      },
    );
  }
}
