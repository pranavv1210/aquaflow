import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/shared/masters/base_info_card.dart';
import '../../../core/shared/masters/base_master_page.dart';
import '../../../core/shared/masters/master_list_item.dart';
import '../../../core/shared/masters/master_list_skeleton.dart';
import '../application/partner_tanker_providers.dart';

class PartnersPage extends ConsumerWidget {
  const PartnersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseMasterPage<MasterListItem>(
      title: 'Partner Tankers',
      subtitle: 'External fleet',
      searchLabel: 'Search partners',
      emptyTitle: 'No Partner Tankers Yet',
      emptyMessage:
          'Partner tankers will appear here after this module is connected.',
      emptyIcon: Icons.handshake_outlined,
      loadItems: (WidgetRef ref, String query) {
        return query.isEmpty
            ? ref.watch(partnerTankerListProvider)
            : ref.watch(partnerTankerSearchProvider(query));
      },
      buildLoading: MasterListSkeleton.new,
      onRefresh: (WidgetRef ref, String query) async {
        if (query.isEmpty) {
          ref.invalidate(partnerTankerListProvider);
        } else {
          ref.invalidate(partnerTankerSearchProvider(query));
        }
        await Future<void>.delayed(const Duration(milliseconds: 250));
      },
      buildItem: (BuildContext context, MasterListItem partner) {
        return BaseInfoCard(
          title: partner.title,
          subtitle: partner.subtitle,
          icon: Icons.handshake_outlined,
          status: partner.status,
        );
      },
    );
  }
}
