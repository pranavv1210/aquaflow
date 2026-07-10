import '../../../core/application/application_service.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/result/result.dart';
import '../domain/expense_category_input.dart';

class ExpenseCategoryValidationService extends ApplicationService {
  const ExpenseCategoryValidationService();

  Result<ExpenseCategoryInput> validateForSave(ExpenseCategoryInput input) {
    final normalized = input.trimmed();
    if (normalized.categoryName.isEmpty) {
      return const Failure<ExpenseCategoryInput>(
        ValidationFailure(message: 'Category name is required.'),
      );
    }
    if (normalized.expenseType.isEmpty) {
      return const Failure<ExpenseCategoryInput>(
        ValidationFailure(message: 'Expense type is required.'),
      );
    }
    return Success<ExpenseCategoryInput>(normalized);
  }
}
