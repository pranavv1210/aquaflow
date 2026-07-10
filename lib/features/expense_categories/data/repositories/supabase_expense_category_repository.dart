import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/models/expense_category.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../../../core/result/result.dart';
import '../../../../core/shared/masters/master_validators.dart';
import '../../domain/expense_category_input.dart';
import '../../domain/repositories/expense_category_repository.dart';
import '../dto/expense_category_dto.dart';
import '../mappers/expense_category_mapper.dart';

class SupabaseExpenseCategoryRepository extends BaseRepository
    implements ExpenseCategoryRepository {
  SupabaseExpenseCategoryRepository(this._client);
  final SupabaseClient _client;
  static const String _table = 'expense_categories';

  @override
  Future<Result<List<ExpenseCategory>>> getExpenseCategories() async {
    final result = await guard<List<ExpenseCategoryDto>>(
      'Load expense categories',
      () async {
        final response = await _client
            .from(_table)
            .select()
            .eq('is_active', true)
            .order('category_name', ascending: true);
        return _mapList(response);
      },
      fallbackMessage: 'Unable to load expense categories.',
    );
    return _mapListResult(result);
  }

  @override
  Future<Result<ExpenseCategory>> getExpenseCategoryById(String id) async {
    final result = await guard<ExpenseCategoryDto>(
      'Load expense category',
      () async {
        final response =
            await _client.from(_table).select().eq('id', id).maybeSingle();
        if (response == null) {
          throw const DatabaseFailure(message: 'Expense category not found.');
        }
        return ExpenseCategoryDto.fromJson(response);
      },
      fallbackMessage: 'Unable to load expense category.',
    );
    return _mapResult(result);
  }

  @override
  Future<Result<ExpenseCategory>> createExpenseCategory(
    ExpenseCategoryInput input,
  ) async {
    final unique = await _ensureNameIsUnique(input.categoryName);
    if (unique case Failure<void> failure) {
      return Failure<ExpenseCategory>(failure.failure);
    }
    final result = await guard<ExpenseCategoryDto>(
      'Create expense category',
      () async {
        final response =
            await _client
                .from(_table)
                .insert(_inputToJson(input))
                .select()
                .single();
        return ExpenseCategoryDto.fromJson(response);
      },
      fallbackMessage: 'Unable to save expense category.',
    );
    return _mapResult(result);
  }

  @override
  Future<Result<ExpenseCategory>> updateExpenseCategory(
    String id,
    ExpenseCategoryInput input,
  ) async {
    final unique = await _ensureNameIsUnique(input.categoryName, excludeId: id);
    if (unique case Failure<void> failure) {
      return Failure<ExpenseCategory>(failure.failure);
    }
    final result = await guard<ExpenseCategoryDto>(
      'Update expense category',
      () async {
        final response =
            await _client
                .from(_table)
                .update(_inputToJson(input))
                .eq('id', id)
                .select()
                .single();
        return ExpenseCategoryDto.fromJson(response);
      },
      fallbackMessage: 'Unable to save expense category.',
    );
    return _mapResult(result);
  }

  @override
  Future<Result<void>> softDeleteExpenseCategory(String id) {
    return guard<void>(
      'Deactivate expense category',
      () async {
        final response = await _client
            .from('expenses')
            .select('id')
            .eq('expense_category_id', id)
            .limit(1);
        if (_mapRawList(response).isNotEmpty) {
          throw const ValidationFailure(
            message:
                'This category is already used by expenses and cannot be deleted.',
          );
        }
        await _client
            .from(_table)
            .update(<String, dynamic>{'is_active': false})
            .eq('id', id);
      },
      fallbackMessage: 'Unable to delete expense category.',
    );
  }

  @override
  Future<Result<List<ExpenseCategory>>> searchExpenseCategories(
    String query,
  ) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return getExpenseCategories();
    }
    final result = await guard<List<ExpenseCategoryDto>>(
      'Search expense categories',
      () async {
        final escaped = _escapeSearchTerm(trimmed);
        final response = await _client
            .from(_table)
            .select()
            .eq('is_active', true)
            .ilike('category_name', '%$escaped%')
            .order('category_name', ascending: true);
        return _mapList(response);
      },
      fallbackMessage: 'Unable to search expense categories.',
    );
    return _mapListResult(result);
  }

  Future<Result<void>> _ensureNameIsUnique(String name, {String? excludeId}) {
    return guard<void>(
      'Validate unique expense category name',
      () async {
        final response = await _client
            .from(_table)
            .select('id, category_name')
            .eq('is_active', true)
            .ilike('category_name', name);
        final duplicates = _mapRawList(
          response,
        ).where((row) => row['id'] != excludeId);
        if (duplicates.isNotEmpty) {
          throw const ValidationFailure(
            message:
                'An active expense category with this name already exists.',
          );
        }
      },
      fallbackMessage: 'Unable to validate expense category name.',
    );
  }

  Map<String, dynamic> _inputToJson(ExpenseCategoryInput input) =>
      <String, dynamic>{
        'category_name': input.categoryName,
        'expense_type': input.expenseType,
        'description': MasterValidators.blankToNull(input.description),
        'is_active': true,
      };

  Result<ExpenseCategory> _mapResult(Result<ExpenseCategoryDto> r) => r.when(
    success: (d) => Success<ExpenseCategory>(ExpenseCategoryMapper.toDomain(d)),
    failure: Failure<ExpenseCategory>.new,
  );
  Result<List<ExpenseCategory>> _mapListResult(
    Result<List<ExpenseCategoryDto>> r,
  ) => r.when(
    success:
        (d) => Success<List<ExpenseCategory>>(
          ExpenseCategoryMapper.toDomainList(d),
        ),
    failure: Failure<List<ExpenseCategory>>.new,
  );
  List<ExpenseCategoryDto> _mapList(dynamic r) =>
      _mapRawList(r).map(ExpenseCategoryDto.fromJson).toList(growable: false);
  List<Map<String, dynamic>> _mapRawList(dynamic r) =>
      (r as List<dynamic>).cast<Map<String, dynamic>>().toList(growable: false);
  String _escapeSearchTerm(String v) =>
      v.replaceAll('%', r'\%').replaceAll('_', r'\_');
}
