import 'package:flutter/material.dart';

import '../../../../core/models/driver.dart';
import '../../../../core/shared/widgets/person_card.dart';

class DriverCard extends StatelessWidget {
  const DriverCard({required this.driver, super.key, this.onTap});

  final Driver driver;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PersonCard(
      title: driver.driverName,
      subtitle: _subtitle,
      icon: Icons.badge_outlined,
      onTap: onTap,
    );
  }

  String get _subtitle {
    final parts = <String>[
      if (driver.phone?.value.trim().isNotEmpty ?? false)
        driver.phone!.value.trim(),
      driver.status.name,
    ];
    if (parts.isEmpty) {
      return 'No phone';
    }
    return parts.join(' · ');
  }
}