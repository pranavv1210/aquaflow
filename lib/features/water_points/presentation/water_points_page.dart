import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/application/navigation_providers.dart';
import '../../../core/models/water_point.dart';
import '../../../core/shared/masters/base_master_page.dart';
import '../application/water_point_providers.dart';
import 'widgets/water_point_card.dart';
import 'widgets/water_point_list_skeleton.dart';

class WaterPointsPage extends ConsumerWidget {
  const WaterPointsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.watch(navigationServiceProvider);
    return BaseMasterPage<WaterPoint>(
      title: 'Water Points', subtitle: 'Water filling points',
      searchLabel: 'Search water points', emptyTitle: 'No Water Points Yet',
      emptyMessage: 'Add your first water point to manage supplies.',
      emptyIcon: Icons.water_drop_outlined,
      onAdd: () => nav.goToWaterPointForm(context),
      loadItems: (ref, q) => q.isEmpty ? ref.watch(waterPointListProvider) : ref.watch(waterPointSearchProvider(q)),
      buildLoading: WaterPointListSkeleton.new,
      onRefresh: (ref, q) async { if (q.isEmpty) ref.invalidate(waterPointListProvider); else ref.invalidate(waterPointSearchProvider(q)); await Future.delayed(const Duration(milliseconds: 250)); },
      buildItem: (ctx, wp) => WaterPointCard(waterPoint: wp, onTap: () => nav.goToWaterPointProfile(context, wp.id)),
    );
  }
}
