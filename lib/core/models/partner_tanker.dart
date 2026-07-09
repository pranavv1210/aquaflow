import 'value_objects.dart';

class PartnerTanker {
  const PartnerTanker({
    required this.id,
    required this.ownerName,
    required this.vehicleName,
    required this.registrationNumber,
    required this.createdAt,
    required this.updatedAt,
    this.phone,
    this.notes,
  });

  final String id;
  final String ownerName;
  final PhoneNumber? phone;
  final String vehicleName;
  final String registrationNumber;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
}
