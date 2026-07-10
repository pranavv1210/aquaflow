import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/navigation_providers.dart';
import '../../../core/helpers/app_formatters.dart';
import '../../../core/models/customer.dart';
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
import '../application/customer_providers.dart';
import 'widgets/customer_list_skeleton.dart';

class CustomerProfilePage extends ConsumerWidget {
  const CustomerProfilePage({required this.customerId, super.key});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(selectedCustomerProvider(customerId));

    return customer.when(
      loading:
          () => const AppScreen(
            children: <Widget>[
              PageHeader(title: 'Customer Profile', subtitle: 'Loading...'),
              CustomerListSkeleton(),
            ],
          ),
      error: (Object error, StackTrace stackTrace) {
        return AppScreen(
          children: <Widget>[
            const PageHeader(title: 'Customer Profile', subtitle: 'Error'),
            ErrorStateWidget(
              title: 'Unable to load customer',
              message: error.toString(),
              onRetry:
                  () => ref.invalidate(selectedCustomerProvider(customerId)),
            ),
          ],
        );
      },
      data: (Customer customer) {
        return _CustomerProfileContent(customer: customer);
      },
    );
  }
}

class _CustomerProfileContent extends ConsumerWidget {
  const _CustomerProfileContent({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScreen(
      children: <Widget>[
        PageHeader(
          title: customer.displayName,
          subtitle: 'Customer Profile',
          trailing: IconButton.filledTonal(
            onPressed:
                () => ref
                    .read(navigationServiceProvider)
                    .goToEditCustomer(context, customer.id),
            icon: const Icon(Icons.edit_outlined),
          ),
        ),
        GlassCard(
          child: Column(
            children: <Widget>[
              _DetailRow(
                label: 'Phone',
                value: customer.phoneNumber?.value ?? 'Not set',
              ),
              const SizedBox(height: AppSpacing.sm),
              _DetailRow(
                label: 'Address',
                value: customer.address ?? 'Not set',
              ),
              const SizedBox(height: AppSpacing.sm),
              _DetailRow(
                label: 'Location',
                value: customer.defaultLocationId ?? 'Not set',
              ),
              const SizedBox(height: AppSpacing.sm),
              _DetailRow(label: 'Notes', value: customer.notes ?? 'Not set'),
              const SizedBox(height: AppSpacing.sm),
              _DetailRow(
                label: 'Created',
                value: AppFormatters.date(customer.createdAt),
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
                  title: 'Revenue',
                  value: '₹--',
                  icon: Icons.currency_rupee_rounded,
                ),
                DashboardCard(
                  title: 'Pending Payment',
                  value: '₹--',
                  icon: Icons.pending_actions_rounded,
                ),
                DashboardCard(
                  title: 'Total Orders',
                  value: '--',
                  icon: Icons.receipt_long_outlined,
                ),
              ],
            );
          },
        ),
        const SectionTitle(title: 'Order History'),
        const EmptyStateWidget(
          title: 'Order History Pending',
          message: 'Orders will appear after the Orders phase is connected.',
          icon: Icons.receipt_long_outlined,
        ),
        SecondaryButton(
          label: 'Delete Customer',
          icon: Icons.delete_outline_rounded,
          onPressed: () => _deleteCustomer(context, ref),
        ),
      ],
    );
  }

  Future<void> _deleteCustomer(BuildContext context, WidgetRef ref) async {
    final confirmed = await MasterDialogs.confirmDelete(
      context,
      title: 'Delete Customer?',
      message: 'This will deactivate the customer without removing history.',
    );
    if (!confirmed || !context.mounted) {
      return;
    }

    final result = await ref.read(deleteCustomerUseCaseProvider)(customer.id);

    result.when(
      success: (_) {
        ref.invalidate(customerListProvider);
        ref.invalidate(selectedCustomerProvider(customer.id));
        if (context.mounted) {
          MasterDialogs.showSaved(context, 'Customer deleted');
          ref.read(navigationServiceProvider).goToCustomers(context);
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
