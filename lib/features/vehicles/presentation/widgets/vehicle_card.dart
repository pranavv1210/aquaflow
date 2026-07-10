import 'package:flutter/material.dart';

import '../../../../core/models/vehicle.dart';
import '../../../../core/shared/widgets/person_card.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({required this.vehicle, super.key, this.onTap});

  final Vehicle vehicle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PersonCard(
      title: vehicle.vehicleName,
      subtitle: _subtitle,
      icon: Icons.local_shipping_outlined,
      onTap: onTap,
    );
  }

  String get _subtitle {
    final parts = <String>[
      vehicle.registrationNumber,
      vehicle.vehicleType.name,
      vehicle.status.name,
    ];
    return parts.join(' \u00b7 ');
  }
}
