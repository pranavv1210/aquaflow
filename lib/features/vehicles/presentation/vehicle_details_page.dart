import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/navigation_providers.dart';
import '../../../core/helpers/app_formatters.dart';
import '../../../core/models/domain_enums.dart';
import '../../../core/models/vehicle.dart';
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
import '../application/vehicle_providers.dart';
import 'widgets/vehicle_list_skeleton.dart';

class VehicleDetailsPage extends ConsumerWidget {
  const VehicleDetailsPage({required this.vehicleId, super.key});
  final String vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = ref.watch(selectedVehicleProvider(vehicleId));

    return switch (vehicle) {
      AsyncData<Vehicle>(:final value) => _VehicleDetailsContent(
        vehicle: value,
      ),
      AsyncError<Vehicle>(:final error) => AppScreen(
        children: <Widget>[
          const PageHeader(title: 'Vehicle Details', subtitle: 'Error'),
          ErrorStateWidget(
            title: 'Unable to load vehicle',
            message: error.toString(),
            onRetry: () => ref.invalidate(selectedVehicleProvider(vehicleId)),
          ),
        ],
      ),
      _ => const AppScreen(
        children: <Widget>[
          PageHeader(title: 'Vehicle Details', subtitle: 'Loading...'),
          VehicleListSkeleton(),
        ],
      ),
    };
  }
}

class _VehicleDetailsContent extends ConsumerWidget {
  const _VehicleDetailsContent({required this.vehicle});
  final Vehicle vehicle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScreen(
      children: <Widget>[
        PageHeader(
          title: vehicle.vehicleName,
          subtitle: 'Vehicle Details',
          trailing: IconButton.filledTonal(
            onPressed:
                () => ref
                    .read(navigationServiceProvider)
                    .goToEditVehicle(context, vehicle.id),
            icon: const Icon(Icons.edit_outlined),
          ),
        ),
        GlassCard(
          child: Column(
            children: <Widget>[
              _DetailRow(
                label: 'Registration',
                value: vehicle.registrationNumber,
              ),
              const SizedBox(height: AppSpacing.sm),
              _DetailRow(
                label: 'Type',
                value: _vehicleTypeLabel(vehicle.vehicleType),
              ),
              const SizedBox(height: AppSpacing.sm),
              _DetailRow(label: 'Status', value: _statusLabel(vehicle.status)),
              const SizedBox(height: AppSpacing.sm),
              _DetailRow(label: 'Notes', value: vehicle.notes ?? 'Not set'),
              const SizedBox(height: AppSpacing.sm),
              _DetailRow(
                label: 'Created',
                value: AppFormatters.date(vehicle.createdAt),
              ),
              const SizedBox(height: AppSpacing.sm),
              _DetailRow(
                label: 'Updated',
                value: AppFormatters.date(vehicle.updatedAt),
              ),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final isWide = constraints.maxWidth > 560;
            return GridView.count(
              crossAxisCount: isWide ? 2 : 1,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: isWide ? 1.9 : 2.8,
              children: <Widget>[
                DashboardCard(
                  title: 'Current Status',
                  value: _statusLabel(vehicle.status),
                  icon: Icons.local_shipping_outlined,
                ),
                const DashboardCard(
                  title: 'Assigned Driver',
                  value: '--',
                  icon: Icons.badge_outlined,
                ),
                const DashboardCard(
                  title: 'Trips Completed',
                  value: '--',
                  icon: Icons.route_outlined,
                ),
                const DashboardCard(
                  title: 'Revenue Generated',
                  value: '₹--',
                  icon: Icons.currency_rupee_rounded,
                ),
                const DashboardCard(
                  title: 'Expenses',
                  value: '₹--',
                  icon: Icons.receipt_long_outlined,
                ),
                const DashboardCard(
                  title: 'Net Profit',
                  value: '₹--',
                  icon: Icons.trending_up_rounded,
                ),
              ],
            );
          },
        ),
        const SectionTitle(title: 'Recent Orders'),
        const EmptyStateWidget(
          title: 'Order History Pending',
          message: 'Orders will appear after the Orders phase is connected.',
          icon: Icons.receipt_long_outlined,
        ),
        SecondaryButton(
          label: 'Delete Vehicle',
          icon: Icons.delete_outline_rounded,
          onPressed: () => _deleteVehicle(context, ref),
        ),
      ],
    );
  }

  Future<void> _deleteVehicle(BuildContext context, WidgetRef ref) async {
    final confirmed = await MasterDialogs.confirmDelete(
      context,
      title: 'Delete Vehicle?',
      message: 'This will deactivate the vehicle without removing history.',
    );
    if (!confirmed || !context.mounted) {
      return;
    }
    final result = await ref.read(deleteVehicleUseCaseProvider)(vehicle.id);
    result.when(
      success: (_) {
        ref.invalidate(vehicleListProvider);
        ref.invalidate(selectedVehicleProvider(vehicle.id));
        if (context.mounted) {
          MasterDialogs.showSaved(context, 'Vehicle deleted');
          ref.read(navigationServiceProvider).goToVehicles(context);
        }
      },
      failure: (error) {
        if (context.mounted) {
          MasterDialogs.showError(context, error.message);
        }
      },
    );
  }

  String _vehicleTypeLabel(VehicleType type) {
    return switch (type) {
      VehicleType.tractor => 'Tractor',
      VehicleType.canter => 'Canter',
      VehicleType.partner => 'Partner',
    };
  }

  String _statusLabel(VehicleStatus status) {
    return switch (status) {
      VehicleStatus.available => 'Available',
      VehicleStatus.busy => 'Busy',
      VehicleStatus.inactive => 'Inactive',
    };
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
