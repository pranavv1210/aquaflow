import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import 'glass_card.dart';
import 'status_chip.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    this.onTap,
    this.onTogglePayment,
    this.onToggleDelivery,
    this.orderNumber = 'Order #--',
    this.customerName = 'Customer --',
    this.locationName = 'Location --',
    this.vehicleName = 'Vehicle --',
    this.driverName = 'Driver --',
    this.amount = '₹--',
    this.paidAmount,
    this.pendingAmount = '₹--',
    this.loadCount = '--',
    this.paymentStatus = 'Pending',
    this.deliveryStatus = '--',
    this.date = '--',
  });

  final VoidCallback? onTap;
  final VoidCallback? onTogglePayment;
  final VoidCallback? onToggleDelivery;
  final String orderNumber;
  final String customerName;
  final String locationName;
  final String vehicleName;
  final String driverName;
  final String amount;
  final String? paidAmount;
  final String pendingAmount;
  final String loadCount;
  final String paymentStatus;
  final String deliveryStatus;
  final String date;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  orderNumber,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              StatusChip(label: paymentStatus, color: colorScheme.primary),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetaRow(icon: Icons.person_outline_rounded, text: customerName),
          const SizedBox(height: AppSpacing.xs),
          _MetaRow(icon: Icons.location_on_outlined, text: locationName),
          const SizedBox(height: AppSpacing.xs),
          _MetaRow(
            icon: Icons.local_shipping_outlined,
            text: '$vehicleName - $driverName',
          ),
          const SizedBox(height: AppSpacing.xs),
          _MetaRow(icon: Icons.event_outlined, text: '$date - $deliveryStatus'),
          const Divider(height: AppSpacing.xl),
          Row(
            children: <Widget>[
              Expanded(
                child: _AmountBlock(
                  amount: amount,
                  paidAmount: paidAmount,
                  pendingAmount: pendingAmount,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '$loadCount loads',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          if (onTogglePayment != null || onToggleDelivery != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: <Widget>[
                if (onTogglePayment != null)
                  Expanded(
                    child: _QuickStatusButton(
                      label:
                          paymentStatus.toLowerCase() == 'paid'
                              ? 'Set Unpaid'
                              : 'Mark Paid',
                      icon:
                          paymentStatus.toLowerCase() == 'paid'
                              ? Icons.money_off_csred_outlined
                              : Icons.verified_rounded,
                      onPressed: onTogglePayment,
                    ),
                  ),
                if (onTogglePayment != null && onToggleDelivery != null)
                  const SizedBox(width: AppSpacing.sm),
                if (onToggleDelivery != null)
                  Expanded(
                    child: _QuickStatusButton(
                      label:
                          deliveryStatus.toLowerCase() == 'delivered'
                              ? 'Reopen'
                              : 'Delivered',
                      icon:
                          deliveryStatus.toLowerCase() == 'delivered'
                              ? Icons.undo_rounded
                              : Icons.local_shipping_rounded,
                      onPressed: onToggleDelivery,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _AmountBlock extends StatelessWidget {
  const _AmountBlock({
    required this.amount,
    required this.pendingAmount,
    this.paidAmount,
  });

  final String amount;
  final String? paidAmount;
  final String pendingAmount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(amount, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 2),
        Text(
          paidAmount == null
              ? 'Pending $pendingAmount'
              : 'Paid $paidAmount - Pending $pendingAmount',
          style: Theme.of(context).textTheme.labelMedium,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _QuickStatusButton extends StatelessWidget {
  const _QuickStatusButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, overflow: TextOverflow.ellipsis),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(42),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
