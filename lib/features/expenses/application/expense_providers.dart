import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/use_case.dart';
import '../../../core/services/supabase_providers.dart';
import '../data/repositories/supabase_expense_repository.dart';
import '../domain/expense_input.dart';
import '../domain/expense_record.dart';
import '../domain/repositories/expense_repository.dart';
import 'expense_validation_service.dart';
import 'use_cases/expense_use_cases.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return SupabaseExpenseRepository(ref.watch(supabaseClientProvider));
});

final expenseValidationServiceProvider = Provider<ExpenseValidationService>((
  ref,
) {
  return const ExpenseValidationService();
});

final getExpensesUseCaseProvider = Provider<GetExpensesUseCase>((ref) {
  return GetExpensesUseCase(ref.watch(expenseRepositoryProvider));
});

final getExpenseUseCaseProvider = Provider<GetExpenseUseCase>((ref) {
  return GetExpenseUseCase(ref.watch(expenseRepositoryProvider));
});

final searchExpensesUseCaseProvider = Provider<SearchExpensesUseCase>((ref) {
  return SearchExpensesUseCase(ref.watch(expenseRepositoryProvider));
});

final createExpenseUseCaseProvider = Provider<CreateExpenseUseCase>((ref) {
  return CreateExpenseUseCase(
    ref.watch(expenseRepositoryProvider),
    ref.watch(expenseValidationServiceProvider),
  );
});

final updateExpenseUseCaseProvider = Provider<UpdateExpenseUseCase>((ref) {
  return UpdateExpenseUseCase(
    ref.watch(expenseRepositoryProvider),
    ref.watch(expenseValidationServiceProvider),
  );
});

final refreshExpensesUseCaseProvider = Provider<RefreshExpensesUseCase>((ref) {
  return const RefreshExpensesUseCase();
});

final expenseListProvider = FutureProvider.autoDispose<List<ExpenseRecord>>((
  ref,
) async {
  final result = await ref.watch(getExpensesUseCaseProvider)();
  return result.getOrThrow();
});

final expenseSearchProvider = FutureProvider.autoDispose
    .family<List<ExpenseRecord>, String>((ref, query) async {
      final result = await ref.watch(searchExpensesUseCaseProvider)(query);
      return result.getOrThrow();
    });

final selectedExpenseProvider = FutureProvider.autoDispose
    .family<ExpenseRecord, String>((ref, expenseId) async {
      final result = await ref.watch(getExpenseUseCaseProvider)(expenseId);
      return result.getOrThrow();
    });

final expenseRealtimeProvider =
    StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
      return ref
          .watch(realtimeServiceProvider)
          .tableStream(table: 'expenses', primaryKey: <String>['id']);
    });

Future<void> refreshExpenseProviders(WidgetRef ref) async {
  await ref.read(refreshExpensesUseCaseProvider)();
  ref.invalidate(expenseListProvider);
}

Future<void> saveExpenseProviders(
  WidgetRef ref, {
  required String? expenseId,
  required ExpenseInput input,
  required void Function(ExpenseRecord expense) onSuccess,
  required void Function(String message) onFailure,
}) async {
  final result =
      expenseId == null
          ? await ref.read(createExpenseUseCaseProvider)(input)
          : await ref.read(updateExpenseUseCaseProvider)(
            UpdateParams<ExpenseInput>(id: expenseId, input: input),
          );

  result.when(
    success: (ExpenseRecord expense) {
      ref.invalidate(expenseListProvider);
      ref.invalidate(selectedExpenseProvider(expense.id));
      onSuccess(expense);
    },
    failure: (failure) => onFailure(failure.message),
  );
}
