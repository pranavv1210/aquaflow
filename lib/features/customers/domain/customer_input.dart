import 'package:equatable/equatable.dart';

class CustomerInput extends Equatable {
  const CustomerInput({
    required this.displayName,
    this.phone,
    this.defaultLocationId,
    this.address,
    this.notes,
  });

  final String displayName;
  final String? phone;
  final String? defaultLocationId;
  final String? address;
  final String? notes;

  CustomerInput trimmed() {
    return CustomerInput(
      displayName: displayName.trim(),
      phone: _blankToNull(phone),
      defaultLocationId: _blankToNull(defaultLocationId),
      address: _blankToNull(address),
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
    displayName,
    phone,
    defaultLocationId,
    address,
    notes,
  ];
}
