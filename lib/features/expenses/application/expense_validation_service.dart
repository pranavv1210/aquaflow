import '../../../core/application/application_service.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/result/result.dart';
import '../domain/expense_input.dart';

class ExpenseValidationService extends ApplicationService {
  const ExpenseValidationService();

  Result<ExpenseInput> validateForSave(ExpenseInput input) {
    final normalized = input.trimmed();
    if (normalized.expenseCategoryId.isEmpty) {
      return const Failure<ExpenseInput>(
        ValidationFailure(message: 'Expense category is required.'),
      );
    }
    if (normalized.amount <= 0) {
      return const Failure<ExpenseInput>(
        ValidationFailure(message: 'Amount must be greater than 0.'),
      );
    }
    return Success<ExpenseInput>(normalized);
  }
}
