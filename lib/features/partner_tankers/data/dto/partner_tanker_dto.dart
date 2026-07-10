import 'package:equatable/equatable.dart';

class PartnerTankerDto extends Equatable {
  const PartnerTankerDto({
    required this.id,
    required this.ownerName,
    required this.vehicleName,
    required this.registrationNumber,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.phone,
    this.notes,
  });

  factory PartnerTankerDto.fromJson(Map<String, dynamic> json) {
    return PartnerTankerDto(
      id: json['id'] as String,
      ownerName: json['owner_name'] as String,
      phone: json['phone'] as String?,
      vehicleName: json['vehicle_name'] as String,
      registrationNumber: json['registration_number'] as String,
      notes: json['notes'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updated_at'] as String).toLocal(),
    );
  }

  final String id;
  final String ownerName;
  final String? phone;
  final String vehicleName;
  final String registrationNumber;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'owner_name': ownerName,
    'phone': phone,
    'vehicle_name': vehicleName,
    'registration_number': registrationNumber,
    'notes': notes,
    'is_active': isActive,
    'created_at': createdAt.toUtc().toIso8601String(),
    'updated_at': updatedAt.toUtc().toIso8601String(),
  };

  PartnerTankerDto copyWith({
    String? id,
    String? ownerName,
    String? phone,
    String? vehicleName,
    String? registrationNumber,
    String? notes,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PartnerTankerDto(
      id: id ?? this.id,
      ownerName: ownerName ?? this.ownerName,
      phone: phone ?? this.phone,
      vehicleName: vehicleName ?? this.vehicleName,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    ownerName,
    phone,
    vehicleName,
    registrationNumber,
    notes,
    isActive,
    createdAt,
    updatedAt,
  ];
}
