import 'package:equatable/equatable.dart';

class LocationInput extends Equatable {
  const LocationInput({
    required this.locationName,
    this.notes,
  });

  final String locationName;
  final String? notes;

  LocationInput trimmed() {
    return LocationInput(
      locationName: locationName.trim(),
      notes: _blankToNull(notes),
    );
  }

  static String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  @override
  List<Object?> get props => <Object?>[locationName, notes];
}
