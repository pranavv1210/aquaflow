import 'package:equatable/equatable.dart';

class VehicleDto extends Equatable {
  const VehicleDto({
    required this.id,
    required this.vehicleName,
    required this.registrationNumber,
    required this.vehicleType,
    required this.status,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
  });

  factory VehicleDto.fromJson(Map<String, dynamic> json) {
    return VehicleDto(
      id: json['id'] as String,
      vehicleName: json['vehicle_name'] as String,
      registrationNumber: json['registration_number'] as String,
      vehicleType: json['vehicle_type'] as String? ?? 'tractor',
      status: json['status'] as String? ?? 'available',
      notes: json['notes'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updated_at'] as String).toLocal(),
    );
  }

  final String id;
  final String vehicleName;
  final String registrationNumber;
  final String vehicleType;
  final String status;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'vehicle_name': vehicleName,
      'registration_number': registrationNumber,
      'vehicle_type': vehicleType,
      'status': status,
      'notes': notes,
      'is_active': isActive,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }

  VehicleDto copyWith({
    String? id,
    String? vehicleName,
    String? registrationNumber,
    String? vehicleType,
    String? status,
    String? notes,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VehicleDto(
      id: id ?? this.id,
      vehicleName: vehicleName ?? this.vehicleName,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    vehicleName,
    registrationNumber,
    vehicleType,
    status,
    notes,
    isActive,
    createdAt,
    updatedAt,
  ];
}