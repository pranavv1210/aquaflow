import '../../../../core/models/expense_category.dart';
import '../../../../core/result/result.dart';
import '../expense_category_input.dart';

abstract interface class ExpenseCategoryRepository {
  Future<Result<List<ExpenseCategory>>> getExpenseCategories();
  Future<Result<ExpenseCategory>> getExpenseCategoryById(String id);
  Future<Result<ExpenseCategory>> createExpenseCategory(ExpenseCategoryInput input);
  Future<Result<ExpenseCategory>> updateExpenseCategory(String id, ExpenseCategoryInput input);
  Future<Result<void>> softDeleteExpenseCategory(String id);
  Future<Result<List<ExpenseCategory>>> searchExpenseCategories(String query);
}
