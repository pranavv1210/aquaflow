import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/application/navigation_providers.dart';
import '../../../core/helpers/app_formatters.dart';
import '../../../core/models/partner_tanker.dart';
import '../../../core/shared/masters/master_dialogs.dart';
import '../../../core/shared/widgets/app_buttons.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/empty_state_widget.dart';
import '../../../core/shared/widgets/error_state_widget.dart';
import '../../../core/shared/widgets/glass_card.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/section_title.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/partner_tanker_providers.dart';
import 'widgets/partner_tanker_list_skeleton.dart';

class PartnerTankerProfilePage extends ConsumerWidget {
  const PartnerTankerProfilePage({required this.partnerTankerId, super.key});
  final String partnerTankerId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pt = ref.watch(selectedPartnerTankerProvider(partnerTankerId));
    return pt.when(
      loading: () => const AppScreen(children: [PageHeader(title: 'Partner Tanker Profile', subtitle: 'Loading...'), PartnerTankerListSkeleton()]),
      error: (e, s) => AppScreen(children: [const PageHeader(title: 'Partner Tanker Profile', subtitle: 'Error'), ErrorStateWidget(title: 'Unable to load partner tanker', message: e.toString(), onRetry: () => ref.invalidate(selectedPartnerTankerProvider(partnerTankerId)))]),
      data: (PartnerTanker p) => _PartnerTankerProfileContent(partnerTanker: p),
    );
  }
}

class _PartnerTankerProfileContent extends ConsumerWidget {
  const _PartnerTankerProfileContent({required this.partnerTanker});
  final PartnerTanker partnerTanker;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScreen(children: [
      PageHeader(title: partnerTanker.ownerName, subtitle: 'Partner Tanker Profile', trailing: IconButton.filledTonal(onPressed: () => ref.read(navigationServiceProvider).goToEditPartnerTanker(context, partnerTanker.id), icon: const Icon(Icons.edit_outlined))),
      GlassCard(child: Column(children: [
        _DetailRow(label: 'Vehicle', value: partnerTanker.vehicleName),
        const SizedBox(height: AppSpacing.sm),
        _DetailRow(label: 'Registration', value: partnerTanker.registrationNumber),
        const SizedBox(height: AppSpacing.sm),
        _DetailRow(label: 'Phone', value: partnerTanker.phone?.value ?? 'Not set'),
        const SizedBox(height: AppSpacing.sm),
        _DetailRow(label: 'Notes', value: partnerTanker.notes ?? 'Not set'),
        const SizedBox(height: AppSpacing.sm),
        _DetailRow(label: 'Created', value: AppFormatters.date(partnerTanker.createdAt)),
        const SizedBox(height: AppSpacing.sm),
        _DetailRow(label: 'Updated', value: AppFormatters.date(partnerTanker.updatedAt)),
      ])),
      const SectionTitle(title: 'Recent Orders'),
      const EmptyStateWidget(title: 'Orders Pending', message: 'Orders will appear after the Orders phase is connected.', icon: Icons.receipt_long_outlined),
      SecondaryButton(label: 'Delete Partner Tanker', icon: Icons.delete_outline_rounded, onPressed: () async {
        final confirmed = await MasterDialogs.confirmDelete(context, title: 'Delete Partner Tanker?', message: 'This will deactivate the partner tanker without removing history.');
        if (!confirmed || !context.mounted) return;
        final result = await ref.read(deletePartnerTankerUseCaseProvider)(partnerTanker.id);
        result.when(success: (_) { ref.invalidate(partnerTankerListProvider); ref.invalidate(selectedPartnerTankerProvider(partnerTanker.id)); if (context.mounted) { MasterDialogs.showSaved(context, 'Partner tanker deleted'); ref.read(navigationServiceProvider).goToPartnerTankers(context); } }, failure: (e) { if (context.mounted) MasterDialogs.showError(context, e.message); });
      }),
    ]);
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label; final String value;
  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: Text(label)), const SizedBox(width: AppSpacing.md), Expanded(child: Text(value, textAlign: TextAlign.end, style: Theme.of(context).textTheme.titleMedium))]);
}
