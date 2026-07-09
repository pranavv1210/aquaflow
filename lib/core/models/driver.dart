import 'domain_enums.dart';
import 'value_objects.dart';

class Driver {
  const Driver({
    required this.id,
    required this.driverName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.phone,
    this.notes,
  });

  final String id;
  final String driverName;
  final PhoneNumber? phone;
  final DriverStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
}
