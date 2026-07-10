import 'package:equatable/equatable.dart';

class VehicleInput extends Equatable {
  const VehicleInput({
    required this.vehicleName,
    required this.registrationNumber,
    required this.vehicleType,
    required this.status,
    this.notes,
  });

  final String vehicleName;
  final String registrationNumber;
  final String vehicleType;
  final String status;
  final String? notes;

  VehicleInput trimmed() {
    return VehicleInput(
      vehicleName: vehicleName.trim(),
      registrationNumber: registrationNumber.trim(),
      vehicleType: vehicleType.trim(),
      status: status.trim(),
      notes: _blankToNull(notes),
    );
  }

  static String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  @override
  List<Object?> get props => <Object?>[
    vehicleName,
    registrationNumber,
    vehicleType,
    status,
    notes,
  ];
}