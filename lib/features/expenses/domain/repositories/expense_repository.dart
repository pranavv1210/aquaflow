import '../../../../core/result/result.dart';
import '../expense_input.dart';
import '../expense_record.dart';

abstract interface class ExpenseRepository {
  Future<Result<List<ExpenseRecord>>> getExpenses();

  Future<Result<ExpenseRecord>> getExpenseById(String id);

  Future<Result<ExpenseRecord>> createExpense(ExpenseInput input);

  Future<Result<ExpenseRecord>> updateExpense(String id, ExpenseInput input);

  Future<Result<List<ExpenseRecord>>> searchExpenses(String query);
}
