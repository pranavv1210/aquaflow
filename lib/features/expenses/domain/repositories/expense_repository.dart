import '../../../../core/result/result.dart';

abstract interface class ExpenseRepository {
  Future<Result<List<Map<String, dynamic>>>> getExpenses();

  Future<Result<Map<String, dynamic>>> getExpenseById(String id);

  Future<Result<Map<String, dynamic>>> createExpense(
    Map<String, dynamic> input,
  );

  Future<Result<Map<String, dynamic>>> updateExpense(
    String id,
    Map<String, dynamic> input,
  );

  Future<Result<void>> deleteExpense(String id);

  Future<Result<List<Map<String, dynamic>>>> searchExpenses(String query);
}
