import 'package:equatable/equatable.dart';

class LocationDto extends Equatable {
  const LocationDto({
    required this.id,
    required this.locationName,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
  });

  factory LocationDto.fromJson(Map<String, dynamic> json) {
    return LocationDto(
      id: json['id'] as String,
      locationName: json['name'] as String,
      notes: json['notes'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updated_at'] as String).toLocal(),
    );
  }

  final String id;
  final String locationName;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': locationName,
      'notes': notes,
      'is_active': isActive,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }

  LocationDto copyWith({
    String? id, String? locationName, String? notes, bool? isActive,
    DateTime? createdAt, DateTime? updatedAt,
  }) {
    return LocationDto(
      id: id ?? this.id,
      locationName: locationName ?? this.locationName,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[id, locationName, notes, isActive, createdAt, updatedAt];
}
