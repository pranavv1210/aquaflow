import 'package:equatable/equatable.dart';

class PartnerTankerInput extends Equatable {
  const PartnerTankerInput({
    required this.ownerName,
    required this.vehicleName,
    required this.registrationNumber,
    this.phone,
    this.notes,
  });

  final String ownerName;
  final String vehicleName;
  final String registrationNumber;
  final String? phone;
  final String? notes;

  PartnerTankerInput trimmed() {
    return PartnerTankerInput(
      ownerName: ownerName.trim(),
      vehicleName: vehicleName.trim(),
      registrationNumber: registrationNumber.trim(),
      phone: _blankToNull(phone),
      notes: _blankToNull(notes),
    );
  }

  static String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  @override
  List<Object?> get props => <Object?>[
    ownerName,
    vehicleName,
    registrationNumber,
    phone,
    notes,
  ];
}
