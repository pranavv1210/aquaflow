import '../../../../core/models/expense_category.dart';
import '../dto/expense_category_dto.dart';

class ExpenseCategoryMapper {
  const ExpenseCategoryMapper._();

  static ExpenseCategory toDomain(ExpenseCategoryDto dto) {
    return ExpenseCategory(
      id: dto.id,
      categoryName: dto.categoryName,
      expenseType: dto.expenseType,
      description: dto.description,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  static List<ExpenseCategory> toDomainList(List<ExpenseCategoryDto> dtos) {
    return dtos.map(toDomain).toList(growable: false);
  }
}
