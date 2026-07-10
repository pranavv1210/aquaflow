import 'package:equatable/equatable.dart';

class WaterPointDto extends Equatable {
  const WaterPointDto({
    required this.id,
    required this.waterPointName,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.locationId,
    this.notes,
  });

  factory WaterPointDto.fromJson(Map<String, dynamic> json) {
    return WaterPointDto(
      id: json['id'] as String,
      waterPointName: json['name'] as String,
      locationId: json['location_id'] as String?,
      notes: json['notes'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updated_at'] as String).toLocal(),
    );
  }

  final String id;
  final String waterPointName;
  final String? locationId;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id, 'name': waterPointName, 'location_id': locationId,
      'notes': notes, 'is_active': isActive,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }

  WaterPointDto copyWith({String? id, String? waterPointName, String? locationId, String? notes, bool? isActive, DateTime? createdAt, DateTime? updatedAt}) {
    return WaterPointDto(
      id: id ?? this.id, waterPointName: waterPointName ?? this.waterPointName,
      locationId: locationId ?? this.locationId, notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive, createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[id, waterPointName, locationId, notes, isActive, createdAt, updatedAt];
}
