import 'package:equatable/equatable.dart';

class DriverInput extends Equatable {
  const DriverInput({
    required this.driverName,
    this.phone,
    required this.status,
    this.notes,
  });

  final String driverName;
  final String? phone;
  final String status;
  final String? notes;

  DriverInput trimmed() {
    return DriverInput(
      driverName: driverName.trim(),
      phone: _blankToNull(phone),
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
    driverName,
    phone,
    status,
    notes,
  ];
}