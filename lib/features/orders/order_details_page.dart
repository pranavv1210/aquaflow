import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/helpers/app_formatters.dart';
import '../../core/router/app_routes.dart';
import '../../core/shared/masters/master_dialogs.dart';
import '../../core/shared/widgets/app_buttons.dart';
import '../../core/shared/widgets/app_screen.dart';
import '../../core/shared/widgets/error_state_widget.dart';
import '../../core/shared/widgets/form_section.dart';
import '../../core/shared/widgets/glass_card.dart';
import '../../core/shared/widgets/page_header.dart';
import '../../core/shared/widgets/skeleton_loader.dart';
import '../../core/shared/widgets/stat_card.dart';
import '../../core/shared/widgets/timeline_tile.dart';
import '../../core/theme/app_spacing.dart';
import 'application/order_providers.dart';
import 'domain/order_record.dart';

class OrderDetailsPage extends ConsumerWidget {
  const OrderDetailsPage({super.key, this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (orderId == null) {
      return const AppScreen(
        children: <Widget>[
          PageHeader(title: 'Order Details', subtitle: 'Order not selected'),
          ErrorStateWidget(title: 'Order Not Found'),
        ],
      );
    }

    final order = ref.watch(selectedOrderProvider(orderId!));
    return order.when(
      loading:
          () => const AppScreen(
            children: <Widget>[
              PageHeader(title: 'Order Details', subtitle: 'Loading...'),
              SkeletonLoader(height: 160),
              SkeletonLoader(height: 180),
              SkeletonLoader(height: 180),
            ],
          ),
      error:
          (Object error, StackTrace stackTrace) => AppScreen(
            children: <Widget>[
              const PageHeader(title: 'Order Details', subtitle: 'Error'),
              ErrorStateWidget(
                title: 'Unable to Load Order',
                message: error.toString(),
                onRetry: () => ref.invalidate(selectedOrderProvider(orderId!)),
              ),
            ],
          ),
      data: (OrderRecord order) => _OrderDetailsContent(order: order),
    );
  }
}

class _OrderDetailsContent extends ConsumerWidget {
  const _OrderDetailsContent({required this.order});

  final OrderRecord order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScreen(
      children: <Widget>[
        PageHeader(title: 'Order Details', subtitle: order.orderNumber),
        GlassCard(
          child: Column(
            children: <Widget>[
              AquaTimelineTile(
                title: 'Order Created',
                subtitle: AppFormatters.date(order.createdAt),
                icon: Icons.add_circle_outline_rounded,
              ),
              AquaTimelineTile(
                title: 'Delivery Status',
                subtitle: _statusLabel(order.deliveryStatus),
                icon: Icons.local_shipping_outlined,
              ),
              AquaTimelineTile(
                title: 'Payment Status',
                subtitle: _statusLabel(order.paymentStatus),
                icon: Icons.currency_rupee_rounded,
                isLast: true,
              ),
            ],
          ),
        ),
        FormSection(
          title: 'Customer',
          children: <Widget>[
            _DetailLine(label: 'Name', value: order.customerName),
            _DetailLine(label: 'Phone', value: order.customerPhone ?? '--'),
            _DetailLine(label: 'Location', value: order.locationName),
            _DetailLine(label: 'Water Point', value: order.waterPointName),
          ],
        ),
        FormSection(
          title: 'Vehicle',
          children: <Widget>[
            _DetailLine(label: 'Vehicle', value: order.vehicleName),
            _DetailLine(label: 'Driver', value: order.driverName),
            const _DetailLine(label: 'Partner Tanker', value: '--'),
          ],
        ),
        FormSection(
          title: 'Payment',
          children: <Widget>[
            StatCard(
              label: 'Amount',
              value: AppFormatters.currency(order.amount),
              icon: Icons.currency_rupee_rounded,
            ),
            StatCard(
              label: 'Paid Amount',
              value: AppFormatters.currency(order.paidAmount),
              icon: Icons.payments_outlined,
            ),
            StatCard(
              label: 'Pending Amount',
              value: AppFormatters.currency(order.pendingAmount),
              icon: Icons.pending_actions_rounded,
            ),
            _DetailLine(
              label: 'Payment Status',
              value: _statusLabel(order.paymentStatus),
            ),
            _DetailLine(
              label: 'Delivery Status',
              value: _statusLabel(order.deliveryStatus),
            ),
            _DetailLine(
              label: 'Order Date',
              value: AppFormatters.date(order.orderDate),
            ),
            _DetailLine(label: 'Order Time', value: order.orderTime),
            _DetailLine(
              label: 'Created Date',
              value: AppFormatters.date(order.createdAt),
            ),
            _DetailLine(
              label: 'Updated Date',
              value: AppFormatters.date(order.updatedAt),
            ),
            _DetailLine(label: 'Remarks', value: order.remarks ?? '--'),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: SecondaryButton(
                label: 'Delete',
                icon: Icons.delete_outline_rounded,
                onPressed: () => _delete(context, ref),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: PrimaryButton(
                label: 'Edit',
                icon: Icons.edit_outlined,
                onPressed: () => context.go(AppRoutes.editOrderPath(order.id)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await MasterDialogs.confirmDelete(
      context,
      title: 'Delete Order?',
      message: 'This order will be removed from active lists.',
    );
    if (!confirmed) {
      return;
    }
    final result = await ref.read(deleteOrderUseCaseProvider)(order.id);
    result.when(
      success: (_) {
        ref.invalidate(orderListProvider);
        ref.invalidate(selectedOrderProvider(order.id));
        MasterDialogs.showSaved(context, 'Order deleted');
        context.go(AppRoutes.orders);
      },
      failure: (failure) => MasterDialogs.showError(context, failure.message),
    );
  }

  String _statusLabel(String value) {
    return value
        .split('_')
        .where((String part) => part.isNotEmpty)
        .map((String part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

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
