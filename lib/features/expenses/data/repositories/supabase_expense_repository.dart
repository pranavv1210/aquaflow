import '../../../../core/repositories/supabase_repository.dart';
import '../../../../core/result/result.dart';
import '../../domain/repositories/expense_repository.dart';

class SupabaseExpenseRepository extends SupabaseRepository
    implements ExpenseRepository {
  SupabaseExpenseRepository(super.client);

  static const String _table = 'expenses';

  @override
  Future<Result<List<Map<String, dynamic>>>> getExpenses() {
    return guard<List<Map<String, dynamic>>>('Load expenses', () async {
      final response = await client
          .from(_table)
          .select()
          .order('expense_date', ascending: false);
      return _rows(response);
    });
  }

  @override
  Future<Result<Map<String, dynamic>>> getExpenseById(String id) {
    return selectRowById(_table, id);
  }

  @override
  Future<Result<Map<String, dynamic>>> createExpense(
    Map<String, dynamic> input,
  ) {
    return insertRow(_table, input);
  }

  @override
  Future<Result<Map<String, dynamic>>> updateExpense(
    String id,
    Map<String, dynamic> input,
  ) {
    return updateRow(_table, id, input);
  }

  @override
  Future<Result<void>> deleteExpense(String id) {
    return guard<void>('Delete expense', () async {
      await client.from(_table).delete().eq('id', id);
    });
  }

  @override
  Future<Result<List<Map<String, dynamic>>>> searchExpenses(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return getExpenses();
    }

    return guard<List<Map<String, dynamic>>>('Search expenses', () async {
      final escaped = trimmed.replaceAll('%', r'\%').replaceAll('_', r'\_');
      final response = await client
          .from(_table)
          .select()
          .ilike('remarks', '%$escaped%')
          .order('expense_date', ascending: false);
      return _rows(response);
    });
  }

  List<Map<String, dynamic>> _rows(dynamic response) {
    return (response as List<dynamic>).cast<Map<String, dynamic>>().toList(
      growable: false,
    );
  }
}
