import 'domain_enums.dart';

class Vehicle {
  const Vehicle({
    required this.id,
    required this.vehicleName,
    required this.registrationNumber,
    required this.vehicleType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
  });

  final String id;
  final String vehicleName;
  final String registrationNumber;
  final VehicleType vehicleType;
  final VehicleStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
}
