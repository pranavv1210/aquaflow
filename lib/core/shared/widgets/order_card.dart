import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import 'glass_card.dart';
import 'status_chip.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    this.onTap,
    this.orderNumber = 'Order #--',
    this.customerName = 'Customer --',
    this.locationName = 'Location --',
    this.vehicleName = 'Vehicle --',
    this.driverName = 'Driver --',
    this.amount = '₹--',
    this.pendingAmount = '₹--',
    this.loadCount = '--',
    this.paymentStatus = 'Pending',
    this.deliveryStatus = '--',
    this.date = '--',
  });

  final VoidCallback? onTap;
  final String orderNumber;
  final String customerName;
  final String locationName;
  final String vehicleName;
  final String driverName;
  final String amount;
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
              Text(amount, style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '$loadCount loads',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Pending $pendingAmount',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ],
          ),
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
