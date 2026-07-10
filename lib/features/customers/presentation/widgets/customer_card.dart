import 'package:flutter/material.dart';

import '../../../../core/models/customer.dart';
import '../../../../core/shared/widgets/person_card.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({required this.customer, super.key, this.onTap});

  final Customer customer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PersonCard(
      title: customer.displayName,
      subtitle: _subtitle,
      icon: Icons.person_outline_rounded,
      onTap: onTap,
    );
  }

  String get _subtitle {
    final parts = <String>[
      if (customer.phoneNumber?.value.trim().isNotEmpty ?? false)
        customer.phoneNumber!.value.trim(),
      if (customer.address?.trim().isNotEmpty ?? false)
        customer.address!.trim(),
    ];
    if (parts.isEmpty) {
      return 'No phone or address';
    }
    return parts.join(' · ');
  }
}
