import 'package:equatable/equatable.dart';

class ExpenseCategoryDto extends Equatable {
  const ExpenseCategoryDto({
    required this.id,
    required this.categoryName,
    required this.expenseType,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.description,
  });

  factory ExpenseCategoryDto.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryDto(
      id: json['id'] as String,
      categoryName: json['category_name'] as String,
      expenseType: json['expense_type'] as String? ?? 'other',
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updated_at'] as String).toLocal(),
    );
  }

  final String id;
  final String categoryName;
  final String expenseType;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'category_name': categoryName,
    'expense_type': expenseType,
    'description': description,
    'is_active': isActive,
    'created_at': createdAt.toUtc().toIso8601String(),
    'updated_at': updatedAt.toUtc().toIso8601String(),
  };

  ExpenseCategoryDto copyWith({
    String? id,
    String? categoryName,
    String? expenseType,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpenseCategoryDto(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      expenseType: expenseType ?? this.expenseType,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    categoryName,
    expenseType,
    description,
    isActive,
    createdAt,
    updatedAt,
  ];
}
