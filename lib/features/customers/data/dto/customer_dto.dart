import 'package:equatable/equatable.dart';

class CustomerDto extends Equatable {
  const CustomerDto({
    required this.id,
    required this.displayName,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.phone,
    this.defaultLocationId,
    this.address,
    this.notes,
  });

  factory CustomerDto.fromJson(Map<String, dynamic> json) {
    return CustomerDto(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      phone: json['phone'] as String?,
      defaultLocationId: json['default_location_id'] as String?,
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updated_at'] as String).toLocal(),
    );
  }

  final String id;
  final String displayName;
  final String? phone;
  final String? defaultLocationId;
  final String? address;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'display_name': displayName,
      'phone': phone,
      'default_location_id': defaultLocationId,
      'address': address,
      'notes': notes,
      'is_active': isActive,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }

  CustomerDto copyWith({
    String? id,
    String? displayName,
    String? phone,
    String? defaultLocationId,
    String? address,
    String? notes,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomerDto(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      phone: phone ?? this.phone,
      defaultLocationId: defaultLocationId ?? this.defaultLocationId,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    displayName,
    phone,
    defaultLocationId,
    address,
    notes,
    isActive,
    createdAt,
    updatedAt,
  ];
}
