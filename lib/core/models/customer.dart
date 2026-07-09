import 'value_objects.dart';

class Customer {
  const Customer({
    required this.id,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
    this.phoneNumber,
    this.defaultLocationId,
    this.address,
    this.notes,
  });

  final String id;
  final String displayName;
  final PhoneNumber? phoneNumber;
  final String? defaultLocationId;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
}
