import 'package:flutter/material.dart';

import '../../../../core/models/domain_enums.dart';
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
      _vehicleTypeLabel(vehicle.vehicleType),
      _statusLabel(vehicle.status),
    ];
    return parts.join(' \u00b7 ');
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
