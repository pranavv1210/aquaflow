import 'package:equatable/equatable.dart';

class WaterPointInput extends Equatable {
  const WaterPointInput({
    required this.waterPointName,
    this.locationId,
    this.notes,
  });

  final String waterPointName;
  final String? locationId;
  final String? notes;

  WaterPointInput trimmed() {
    return WaterPointInput(
      waterPointName: waterPointName.trim(),
      locationId: _blankToNull(locationId),
      notes: _blankToNull(notes),
    );
  }

  static String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  @override
  List<Object?> get props => <Object?>[waterPointName, locationId, notes];
}
