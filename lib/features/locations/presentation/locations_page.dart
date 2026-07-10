import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/application/navigation_providers.dart';
import '../../../core/models/location.dart';
import '../../../core/shared/masters/base_master_page.dart';
import '../application/location_providers.dart';
import 'widgets/location_card.dart';
import 'widgets/location_list_skeleton.dart';

class LocationsPage extends ConsumerWidget {
  const LocationsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.watch(navigationServiceProvider);
    return BaseMasterPage<Location>(
      title: 'Locations',
      subtitle: 'Location master',
      searchLabel: 'Search locations',
      emptyTitle: 'No Locations Yet',
      emptyMessage: 'Add your first location to organize your routes.',
      emptyIcon: Icons.location_on_outlined,
      onAdd: () => navigation.goToLocationForm(context),
      loadItems:
          (ref, query) =>
              query.isEmpty
                  ? ref.watch(locationListProvider)
                  : ref.watch(locationSearchProvider(query)),
      buildLoading: LocationListSkeleton.new,
      onRefresh: (ref, query) async {
        if (query.isEmpty) {
          ref.invalidate(locationListProvider);
        } else {
          ref.invalidate(locationSearchProvider(query));
        }
        await Future.delayed(const Duration(milliseconds: 250));
      },
      buildItem:
          (context, Location loc) => LocationCard(
            location: loc,
            onTap: () => navigation.goToLocationProfile(context, loc.id),
          ),
    );
  }
}
