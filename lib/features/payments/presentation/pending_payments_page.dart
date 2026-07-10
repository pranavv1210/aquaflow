import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/helpers/app_formatters.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/connectivity_providers.dart';
import '../../../core/shared/masters/master_dialogs.dart';
import '../../../core/shared/widgets/app_buttons.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/app_text_field.dart';
import '../../../core/shared/widgets/empty_state_widget.dart';
import '../../../core/shared/widgets/error_state_widget.dart';
import '../../../core/shared/widgets/glass_card.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/search_field.dart';
import '../../../core/shared/widgets/skeleton_loader.dart';
import '../../../core/theme/app_spacing.dart';
import '../../analytics/application/analytics_providers.dart';
import '../../orders/application/order_providers.dart';
import '../../orders/domain/order_record.dart';
import '../application/pending_payment_providers.dart';

class PendingPaymentsPage extends ConsumerStatefulWidget {
  const PendingPaymentsPage({super.key});

  @override
  ConsumerState<PendingPaymentsPage> createState() =>
      _PendingPaymentsPageState();
}

class _PendingPaymentsPageState extends ConsumerState<PendingPaymentsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(orderRealtimeProvider, (_, next) {
      if (next.hasValue) {
        ref.invalidate(orderListProvider);
        ref.invalidate(pendingPaymentListProvider);
        invalidateBusinessMetrics(ref);
      }
    });

    final payments =
        _query.trim().isEmpty
            ? ref.watch(pendingPaymentListProvider)
            : ref.watch(pendingPaymentSearchProvider(_query));

    return RefreshIndicator(
      onRefresh: _refresh,
      child: payments.when(
        loading:
            () => const AppScreen(
              children: <Widget>[
                PageHeader(title: 'Pending Payments', subtitle: 'Loading...'),
                SearchField(label: 'Search payments'),
                SkeletonLoader(height: 136),
                SkeletonLoader(height: 136),
              ],
            ),
        error:
            (Object error, StackTrace stackTrace) => AppScreen(
              children: <Widget>[
                const PageHeader(
                  title: 'Pending Payments',
                  subtitle: 'Payment follow-up',
                ),
                SearchField(
                  label: 'Search payments',
                  controller: _searchController,
                  onChanged: (String value) => setState(() => _query = value),
                ),
                ErrorStateWidget(
                  title: 'Unable to load pending payments',
                  message: error.toString(),
                  onRetry: _invalidate,
                ),
              ],
            ),
        data: (List<OrderRecord> orders) {
          return AppScreen(
            children: <Widget>[
              const PageHeader(
                title: 'Pending Payments',
                subtitle: 'Payment follow-up',
              ),
              SearchField(
                label: 'Search payments',
                controller: _searchController,
                onChanged: (String value) => setState(() => _query = value),
              ),
              if (orders.isEmpty)
                const EmptyStateWidget(
                  title: 'No Pending Payments',
                  message: 'Open payments will appear here.',
                  icon: Icons.account_balance_wallet_outlined,
                )
              else
                ...orders.map((OrderRecord order) {
                  return _PendingPaymentCard(
                    order: order,
                    onCall: () => _showCallInfo(order),
                    onMarkPaid: () => _showMarkPaidSheet(order),
                    onEdit: () => context.go(AppRoutes.editOrderPath(order.id)),
                  );
                }),
            ],
          );
        },
      ),
    );
  }

  Future<void> _refresh() async {
    _invalidate();
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }

  void _invalidate() {
    ref.invalidate(orderListProvider);
    if (_query.trim().isEmpty) {
      ref.invalidate(pendingPaymentListProvider);
    } else {
      ref.invalidate(pendingPaymentSearchProvider(_query));
    }
  }

  void _showCallInfo(OrderRecord order) {
    MasterDialogs.showSaved(
      context,
      order.customerPhone == null
          ? 'No phone number available'
          : 'Call ${order.customerPhone}',
    );
  }

  Future<void> _showMarkPaidSheet(OrderRecord order) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext context) {
        return _MarkPaidSheet(order: order);
      },
    );
    _invalidate();
  }
}

class _PendingPaymentCard extends StatelessWidget {
  const _PendingPaymentCard({
    required this.order,
    required this.onCall,
    required this.onMarkPaid,
    required this.onEdit,
  });

  final OrderRecord order;
  final VoidCallback onCall;
  final VoidCallback onMarkPaid;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final daysPending = DateTime.now().difference(order.orderDate).inDays;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  order.customerName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                AppFormatters.currency(order.pendingAmount),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetaRow(
            icon: Icons.phone_outlined,
            text: order.customerPhone ?? '--',
          ),
          const SizedBox(height: AppSpacing.xs),
          _MetaRow(icon: Icons.location_on_outlined, text: order.locationName),
          const SizedBox(height: AppSpacing.xs),
          _MetaRow(
            icon: Icons.event_outlined,
            text:
                '${AppFormatters.date(order.orderDate)} - $daysPending days pending',
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: SecondaryButton(
                  label: 'Call',
                  icon: Icons.call_outlined,
                  onPressed: onCall,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: PrimaryButton(
                  label: 'Mark Paid',
                  icon: Icons.check_rounded,
                  onPressed: onMarkPaid,
                ),
              ),
              IconButton.filledTonal(
                tooltip: 'Edit Order',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MarkPaidSheet extends ConsumerStatefulWidget {
  const _MarkPaidSheet({required this.order});

  final OrderRecord order;

  @override
  ConsumerState<_MarkPaidSheet> createState() => _MarkPaidSheetState();
}

class _MarkPaidSheetState extends ConsumerState<_MarkPaidSheet> {
  final TextEditingController _amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.order.pendingAmount.toString();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Mark Payment', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            _PaymentLine(
              label: 'Total Amount',
              value: AppFormatters.currency(widget.order.amount),
            ),
            _PaymentLine(
              label: 'Already Paid',
              value: AppFormatters.currency(widget.order.paidAmount),
            ),
            _PaymentLine(
              label: 'Remaining',
              value: AppFormatters.currency(widget.order.pendingAmount),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Payment Received',
              controller: _amountController,
              prefixIcon: Icons.currency_rupee_rounded,
              keyboardType: TextInputType.number,
              validator: _validateAmount,
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: ref.watch(isOnlineProvider) ? 'Save Payment' : 'Offline',
              icon: Icons.check_rounded,
              isLoading: _isSaving,
              onPressed: ref.watch(isOnlineProvider) ? _save : null,
            ),
          ],
        ),
      ),
    );
  }

  String? _validateAmount(String? value) {
    final parsed = num.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed <= 0) {
      return 'Enter payment received';
    }
    if (parsed > widget.order.pendingAmount) {
      return 'Payment cannot exceed remaining amount';
    }
    return null;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _isSaving = true);
    final result = await ref
        .read(pendingPaymentRepositoryProvider)
        .recordPayment(
          orderId: widget.order.id,
          currentPaidAmount: widget.order.paidAmount,
          totalAmount: widget.order.amount,
          receivedAmount: num.parse(_amountController.text.trim()),
        );
    if (!mounted) {
      return;
    }
    setState(() => _isSaving = false);
    result.when(
      success: (_) {
        ref.invalidate(orderListProvider);
        ref.invalidate(pendingPaymentListProvider);
        invalidateBusinessMetrics(ref);
        MasterDialogs.showSaved(context, 'Payment updated');
        Navigator.of(context).pop();
      },
      failure: (failure) => MasterDialogs.showError(context, failure.message),
    );
  }
}

class _PaymentLine extends StatelessWidget {
  const _PaymentLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label)),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: AppSpacing.xs),
        Expanded(child: Text(text, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
