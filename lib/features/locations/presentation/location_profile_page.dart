import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/application/navigation_providers.dart';
import '../../../core/helpers/app_formatters.dart';
import '../../../core/models/location.dart';
import '../../../core/shared/masters/master_dialogs.dart';
import '../../../core/shared/widgets/app_buttons.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/empty_state_widget.dart';
import '../../../core/shared/widgets/error_state_widget.dart';
import '../../../core/shared/widgets/glass_card.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/section_title.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/location_providers.dart';
import 'widgets/location_list_skeleton.dart';

class LocationProfilePage extends ConsumerWidget {
  const LocationProfilePage({required this.locationId, super.key});
  final String locationId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(selectedLocationProvider(locationId));
    return switch (location) {
      AsyncData<Location>(:final value) => _LocationProfileContent(
        location: value,
      ),
      AsyncError<Location>(:final error) => AppScreen(
        children: [
          const PageHeader(title: 'Location Profile', subtitle: 'Error'),
          ErrorStateWidget(
            title: 'Unable to load location',
            message: error.toString(),
            onRetry: () => ref.invalidate(selectedLocationProvider(locationId)),
          ),
        ],
      ),
      _ => const AppScreen(
        children: [
          PageHeader(title: 'Location Profile', subtitle: 'Loading...'),
          LocationListSkeleton(),
        ],
      ),
    };
  }
}

class _LocationProfileContent extends ConsumerWidget {
  const _LocationProfileContent({required this.location});
  final Location location;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScreen(
      children: [
        PageHeader(
          title: location.locationName,
          subtitle: 'Location Profile',
          trailing: IconButton.filledTonal(
            onPressed:
                () => ref
                    .read(navigationServiceProvider)
                    .goToEditLocation(context, location.id),
            icon: const Icon(Icons.edit_outlined),
          ),
        ),
        GlassCard(
          child: Column(
            children: [
              _DetailRow(label: 'Notes', value: location.notes ?? 'Not set'),
              const SizedBox(height: AppSpacing.sm),
              _DetailRow(
                label: 'Created',
                value: AppFormatters.date(location.createdAt),
              ),
              const SizedBox(height: AppSpacing.sm),
              _DetailRow(
                label: 'Updated',
                value: AppFormatters.date(location.updatedAt),
              ),
            ],
          ),
        ),
        const SectionTitle(title: 'Related Orders'),
        const EmptyStateWidget(
          title: 'Orders Pending',
          message: 'Orders will appear after the Orders phase is connected.',
          icon: Icons.receipt_long_outlined,
        ),
        SecondaryButton(
          label: 'Delete Location',
          icon: Icons.delete_outline_rounded,
          onPressed: () async {
            final confirmed = await MasterDialogs.confirmDelete(
              context,
              title: 'Delete Location?',
              message:
                  'This will deactivate the location without removing history.',
            );
            if (!confirmed || !context.mounted) return;
            final result = await ref.read(deleteLocationUseCaseProvider)(
              location.id,
            );
            result.when(
              success: (_) {
                ref.invalidate(locationListProvider);
                ref.invalidate(selectedLocationProvider(location.id));
                if (context.mounted) {
                  MasterDialogs.showSaved(context, 'Location deleted');
                  ref.read(navigationServiceProvider).goToLocations(context);
                }
              },
              failure: (error) {
                if (context.mounted) {
                  MasterDialogs.showError(context, error.message);
                }
              },
            );
          },
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label)),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
