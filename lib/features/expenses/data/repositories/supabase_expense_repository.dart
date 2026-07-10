import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../../../core/result/result.dart';
import '../../domain/expense_input.dart';
import '../../domain/expense_record.dart';
import '../../domain/repositories/expense_repository.dart';

class SupabaseExpenseRepository extends BaseRepository
    implements ExpenseRepository {
  SupabaseExpenseRepository(this._client);

  final SupabaseClient _client;

  static const String _table = 'expenses';
  static const String _select = '''
    *,
    expense_categories(id, category_name, expense_type),
    vehicles(id, vehicle_name, registration_number),
    drivers(id, driver_name, phone)
  ''';

  @override
  Future<Result<List<ExpenseRecord>>> getExpenses() {
    return guard<List<ExpenseRecord>>('Load expenses', () async {
      final response = await _client
          .from(_table)
          .select(_select)
          .order('expense_date', ascending: false)
          .order('created_at', ascending: false);
      return _mapList(response);
    }, fallbackMessage: 'Unable to load expenses.');
  }

  @override
  Future<Result<ExpenseRecord>> getExpenseById(String id) {
    return guard<ExpenseRecord>('Load expense', () async {
      final response =
          await _client.from(_table).select(_select).eq('id', id).maybeSingle();
      if (response == null) {
        throw const DatabaseFailure(message: 'Expense not found.');
      }
      return _mapRow(Map<String, dynamic>.from(response));
    }, fallbackMessage: 'Unable to load expense.');
  }

  @override
  Future<Result<ExpenseRecord>> createExpense(ExpenseInput input) {
    return guard<ExpenseRecord>('Create expense', () async {
      final response =
          await _client
              .from(_table)
              .insert(_inputToJson(input.trimmed()))
              .select(_select)
              .single();
      return _mapRow(Map<String, dynamic>.from(response));
    }, fallbackMessage: 'Unable to save expense.');
  }

  @override
  Future<Result<ExpenseRecord>> updateExpense(String id, ExpenseInput input) {
    return guard<ExpenseRecord>('Update expense', () async {
      final response =
          await _client
              .from(_table)
              .update(_inputToJson(input.trimmed()))
              .eq('id', id)
              .select(_select)
              .single();
      return _mapRow(Map<String, dynamic>.from(response));
    }, fallbackMessage: 'Unable to save expense.');
  }

  @override
  Future<Result<List<ExpenseRecord>>> searchExpenses(String query) async {
    final result = await getExpenses();
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return result;
    }
    return result.when(
      success: (List<ExpenseRecord> expenses) {
        return Success<List<ExpenseRecord>>(
          expenses
              .where((ExpenseRecord expense) {
                return expense.categoryName.toLowerCase().contains(
                      normalized,
                    ) ||
                    (expense.vehicleName?.toLowerCase().contains(normalized) ??
                        false) ||
                    (expense.driverName?.toLowerCase().contains(normalized) ??
                        false) ||
                    (expense.remarks?.toLowerCase().contains(normalized) ??
                        false);
              })
              .toList(growable: false),
        );
      },
      failure: Failure<List<ExpenseRecord>>.new,
    );
  }

  Map<String, dynamic> _inputToJson(ExpenseInput input) {
    return <String, dynamic>{
      'expense_date': _dateToDb(input.expenseDate),
      'vehicle_id': input.vehicleId,
      'driver_id': input.driverId,
      'expense_category_id': input.expenseCategoryId,
      'amount': input.amount,
      'remarks': input.remarks,
    };
  }

  List<ExpenseRecord> _mapList(dynamic response) {
    return (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(_mapRow)
        .toList(growable: false);
  }

  ExpenseRecord _mapRow(Map<String, dynamic> row) {
    final category = _nested(row, 'expense_categories');
    final vehicle = _nested(row, 'vehicles');
    final driver = _nested(row, 'drivers');
    return ExpenseRecord(
      id: row['id'] as String,
      expenseDate: DateTime.parse(row['expense_date'] as String).toLocal(),
      expenseCategoryId: row['expense_category_id'] as String,
      categoryName: category['category_name'] as String? ?? '--',
      vehicleId: row['vehicle_id'] as String?,
      vehicleName: vehicle['vehicle_name'] as String?,
      driverId: row['driver_id'] as String?,
      driverName: driver['driver_name'] as String?,
      amount: _numValue(row['amount']),
      remarks: row['remarks'] as String?,
      createdAt: DateTime.parse(row['created_at'] as String).toLocal(),
      updatedAt: DateTime.parse(row['updated_at'] as String).toLocal(),
    );
  }

  Map<String, dynamic> _nested(Map<String, dynamic> row, String key) {
    final value = row[key];
    if (value is Map<String, dynamic>) {
      return value;
    }
    return const <String, dynamic>{};
  }

  num _numValue(dynamic value) {
    if (value is num) {
      return value;
    }
    return num.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _dateToDb(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}
