import 'package:equatable/equatable.dart';

class DriverDto extends Equatable {
  const DriverDto({
    required this.id,
    required this.driverName,
    required this.status,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.phone,
    this.notes,
  });

  factory DriverDto.fromJson(Map<String, dynamic> json) {
    return DriverDto(
      id: json['id'] as String,
      driverName: json['driver_name'] as String,
      phone: json['phone'] as String?,
      status: json['status'] as String? ?? 'available',
      notes: json['notes'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updated_at'] as String).toLocal(),
    );
  }

  final String id;
  final String driverName;
  final String? phone;
  final String status;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'driver_name': driverName,
      'phone': phone,
      'status': status,
      'notes': notes,
      'is_active': isActive,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }

  DriverDto copyWith({
    String? id,
    String? driverName,
    String? phone,
    String? status,
    String? notes,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DriverDto(
      id: id ?? this.id,
      driverName: driverName ?? this.driverName,
      phone: phone ?? this.phone,
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
    driverName,
    phone,
    status,
    notes,
    isActive,
    createdAt,
    updatedAt,
  ];
}