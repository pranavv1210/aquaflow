import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/application/navigation_providers.dart';
import '../../../core/helpers/app_formatters.dart';
import '../../../core/models/water_point.dart';
import '../../../core/shared/masters/master_dialogs.dart';
import '../../../core/shared/widgets/app_buttons.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/empty_state_widget.dart';
import '../../../core/shared/widgets/error_state_widget.dart';
import '../../../core/shared/widgets/glass_card.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/section_title.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/water_point_providers.dart';
import 'widgets/water_point_list_skeleton.dart';

class WaterPointProfilePage extends ConsumerWidget {
  const WaterPointProfilePage({required this.waterPointId, super.key});
  final String waterPointId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wp = ref.watch(selectedWaterPointProvider(waterPointId));
    return wp.when(
      loading: () => const AppScreen(children: [PageHeader(title: 'Water Point Profile', subtitle: 'Loading...'), WaterPointListSkeleton()]),
      error: (e, s) => AppScreen(children: [const PageHeader(title: 'Water Point Profile', subtitle: 'Error'), ErrorStateWidget(title: 'Unable to load water point', message: e.toString(), onRetry: () => ref.invalidate(selectedWaterPointProvider(waterPointId)))]),
      data: (WaterPoint w) => _WaterPointProfileContent(waterPoint: w),
    );
  }
}

class _WaterPointProfileContent extends ConsumerWidget {
  const _WaterPointProfileContent({required this.waterPoint});
  final WaterPoint waterPoint;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScreen(children: [
      PageHeader(title: waterPoint.waterPointName, subtitle: 'Water Point Profile', trailing: IconButton.filledTonal(onPressed: () => ref.read(navigationServiceProvider).goToEditWaterPoint(context, waterPoint.id), icon: const Icon(Icons.edit_outlined))),
      GlassCard(child: Column(children: [
        _DetailRow(label: 'Location ID', value: waterPoint.locationId ?? 'Not set'),
        const SizedBox(height: AppSpacing.sm),
        _DetailRow(label: 'Notes', value: waterPoint.notes ?? 'Not set'),
        const SizedBox(height: AppSpacing.sm),
        _DetailRow(label: 'Created', value: AppFormatters.date(waterPoint.createdAt)),
        const SizedBox(height: AppSpacing.sm),
        _DetailRow(label: 'Updated', value: AppFormatters.date(waterPoint.updatedAt)),
      ])),
      const SectionTitle(title: 'Related Orders'),
      const EmptyStateWidget(title: 'Orders Pending', message: 'Orders will appear after the Orders phase is connected.', icon: Icons.receipt_long_outlined),
      SecondaryButton(label: 'Delete Water Point', icon: Icons.delete_outline_rounded, onPressed: () async {
        final confirmed = await MasterDialogs.confirmDelete(context, title: 'Delete Water Point?', message: 'This will deactivate the water point without removing history.');
        if (!confirmed || !context.mounted) return;
        final result = await ref.read(deleteWaterPointUseCaseProvider)(waterPoint.id);
        result.when(success: (_) { ref.invalidate(waterPointListProvider); ref.invalidate(selectedWaterPointProvider(waterPoint.id)); if (context.mounted) { MasterDialogs.showSaved(context, 'Water point deleted'); ref.read(navigationServiceProvider).goToWaterPoints(context); } }, failure: (e) { if (context.mounted) MasterDialogs.showError(context, e.message); });
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
