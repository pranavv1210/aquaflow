import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/application/navigation_providers.dart';
import '../../../core/models/partner_tanker.dart';
import '../../../core/shared/masters/base_master_page.dart';
import '../application/partner_tanker_providers.dart';
import 'widgets/partner_tanker_card.dart';
import 'widgets/partner_tanker_list_skeleton.dart';

class PartnerTankersPage extends ConsumerWidget {
  const PartnerTankersPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.watch(navigationServiceProvider);
    return BaseMasterPage<PartnerTanker>(
      title: 'Partner Tankers', subtitle: 'External partner vehicles',
      searchLabel: 'Search partner tankers', emptyTitle: 'No Partner Tankers Yet',
      emptyMessage: 'Add your first partner tanker to manage external deliveries.',
      emptyIcon: Icons.handshake_outlined,
      onAdd: () => nav.goToPartnerTankerForm(context),
      loadItems: (ref, q) => q.isEmpty ? ref.watch(partnerTankerListProvider) : ref.watch(partnerTankerSearchProvider(q)),
      buildLoading: PartnerTankerListSkeleton.new,
      onRefresh: (ref, q) async { if (q.isEmpty) ref.invalidate(partnerTankerListProvider); else ref.invalidate(partnerTankerSearchProvider(q)); await Future.delayed(const Duration(milliseconds: 250)); },
      buildItem: (ctx, pt) => PartnerTankerCard(partnerTanker: pt, onTap: () => nav.goToPartnerTankerProfile(context, pt.id)),
    );
  }
}
