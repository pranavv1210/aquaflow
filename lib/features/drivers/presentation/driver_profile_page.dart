import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/navigation_providers.dart';
import '../../../core/helpers/app_formatters.dart';
import '../../../core/models/driver.dart';
import '../../../core/shared/masters/master_dialogs.dart';
import '../../../core/shared/widgets/app_buttons.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/dashboard_card.dart';
import '../../../core/shared/widgets/empty_state_widget.dart';
import '../../../core/shared/widgets/error_state_widget.dart';
import '../../../core/shared/widgets/glass_card.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/section_title.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/driver_providers.dart';
import 'widgets/driver_list_skeleton.dart';

class DriverProfilePage extends ConsumerWidget {
  const DriverProfilePage({required this.driverId, super.key});

  final String driverId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driver = ref.watch(selectedDriverProvider(driverId));

    return driver.when(
      loading:
          () => const AppScreen(
            children: <Widget>[
              PageHeader(title: 'Driver Profile', subtitle: 'Loading...'),
              DriverListSkeleton(),
            ],
          ),
      error: (Object error, StackTrace stackTrace) {
        return AppScreen(
          children: <Widget>[
            const PageHeader(title: 'Driver Profile', subtitle: 'Error'),
            ErrorStateWidget(
              title: 'Unable to load driver',
              message: error.toString(),
              onRetry: () => ref.invalidate(selectedDriverProvider(driverId)),
            ),
          ],
        );
      },
      data: (Driver driver) {
        return _DriverProfileContent(driver: driver);
      },
    );
  }
}

class _DriverProfileContent extends ConsumerWidget {
  const _DriverProfileContent({required this.driver});

  final Driver driver;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScreen(
      children: <Widget>[
        PageHeader(
          title: driver.driverName,
          subtitle: 'Driver Profile',
          trailing: IconButton.filledTonal(
            onPressed:
                () => ref
                    .read(navigationServiceProvider)
                    .goToEditDriver(context, driver.id),
            icon: const Icon(Icons.edit_outlined),
          ),
        ),
        GlassCard(
          child: Column(
            children: <Widget>[
              _DetailRow(
                label: 'Phone',
                value: driver.phone?.value ?? 'Not set',
              ),
              const SizedBox(height: AppSpacing.sm),
              _DetailRow(label: 'Status', value: driver.status.name),
              const SizedBox(height: AppSpacing.sm),
              _DetailRow(label: 'Notes', value: driver.notes ?? 'Not set'),
              const SizedBox(height: AppSpacing.sm),
              _DetailRow(
                label: 'Created',
                value: AppFormatters.date(driver.createdAt),
              ),
              const SizedBox(height: AppSpacing.sm),
              _DetailRow(
                label: 'Updated',
                value: AppFormatters.date(driver.updatedAt),
              ),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final isWide = constraints.maxWidth > 560;
            return GridView.count(
              crossAxisCount: isWide ? 3 : 1,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: isWide ? 1.8 : 2.8,
              children: const <Widget>[
                DashboardCard(
                  title: 'Assigned Vehicle',
                  value: '--',
                  icon: Icons.local_shipping_outlined,
                ),
                DashboardCard(
                  title: 'Orders Completed',
                  value: '--',
                  icon: Icons.receipt_long_outlined,
                ),
                DashboardCard(
                  title: 'Revenue Generated',
                  value: '₹--',
                  icon: Icons.currency_rupee_rounded,
                ),
              ],
            );
          },
        ),
        const SectionTitle(title: 'Recent Orders'),
        const EmptyStateWidget(
          title: 'Recent Orders Pending',
          message: 'Orders will appear after the Orders phase is connected.',
          icon: Icons.route_outlined,
        ),
        SecondaryButton(
          label: 'Delete Driver',
          icon: Icons.delete_outline_rounded,
          onPressed: () => _deleteDriver(context, ref),
        ),
      ],
    );
  }

  Future<void> _deleteDriver(BuildContext context, WidgetRef ref) async {
    final confirmed = await MasterDialogs.confirmDelete(
      context,
      title: 'Delete Driver?',
      message: 'This will deactivate the driver without removing history.',
    );
    if (!confirmed || !context.mounted) {
      return;
    }

    final result = await ref.read(deleteDriverUseCaseProvider)(driver.id);

    result.when(
      success: (_) {
        ref.invalidate(driverListProvider);
        ref.invalidate(selectedDriverProvider(driver.id));
        if (context.mounted) {
          MasterDialogs.showSaved(context, 'Driver deleted');
          ref.read(navigationServiceProvider).goToDrivers(context);
        }
      },
      failure: (error) {
        if (context.mounted) {
          MasterDialogs.showError(context, error.message);
        }
      },
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
      children: <Widget>[
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
