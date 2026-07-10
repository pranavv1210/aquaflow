import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/navigation_providers.dart';
import '../../../core/models/driver.dart';
import '../../../core/shared/masters/base_master_page.dart';
import '../application/driver_providers.dart';
import 'widgets/driver_card.dart';
import 'widgets/driver_list_skeleton.dart';

class DriversPage extends ConsumerWidget {
  const DriversPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.watch(navigationServiceProvider);

    return BaseMasterPage<Driver>(
      title: 'Drivers',
      subtitle: 'Driver master',
      searchLabel: 'Search drivers',
      emptyTitle: 'No Drivers Yet',
      emptyMessage: 'Add your first driver to assign them to orders.',
      emptyIcon: Icons.badge_outlined,
      onAdd: () => navigation.goToDriverForm(context),
      loadItems: (WidgetRef ref, String query) {
        return query.isEmpty
            ? ref.watch(driverListProvider)
            : ref.watch(driverSearchProvider(query));
      },
      buildLoading: DriverListSkeleton.new,
      onRefresh: (WidgetRef ref, String query) async {
        if (query.isEmpty) {
          ref.invalidate(driverListProvider);
        } else {
          ref.invalidate(driverSearchProvider(query));
        }
        await Future<void>.delayed(const Duration(milliseconds: 250));
      },
      buildItem: (BuildContext context, Driver driver) {
        return DriverCard(
          driver: driver,
          onTap: () => navigation.goToDriverProfile(context, driver.id),
        );
      },
    );
  }
}