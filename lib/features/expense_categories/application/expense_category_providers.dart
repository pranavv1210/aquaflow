import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/application/use_case.dart';
import '../../../core/models/expense_category.dart';
import '../../../core/services/supabase_providers.dart';
import '../../../core/shared/masters/master_providers.dart';
import '../data/repositories/supabase_expense_category_repository.dart';
import '../domain/expense_category_input.dart';
import '../domain/repositories/expense_category_repository.dart';
import 'expense_category_validation_service.dart';
import 'use_cases/expense_category_use_cases.dart';

final expenseCategoryRepositoryProvider = Provider<ExpenseCategoryRepository>(
  (ref) => SupabaseExpenseCategoryRepository(ref.watch(supabaseClientProvider)),
);
final expenseCategoryValidationServiceProvider =
    Provider<ExpenseCategoryValidationService>(
      (ref) => const ExpenseCategoryValidationService(),
    );
final getExpenseCategoriesUseCaseProvider =
    Provider<GetExpenseCategoriesUseCase>(
      (ref) => GetExpenseCategoriesUseCase(
        ref.watch(expenseCategoryRepositoryProvider),
      ),
    );
final getExpenseCategoryUseCaseProvider = Provider<GetExpenseCategoryUseCase>(
  (ref) =>
      GetExpenseCategoryUseCase(ref.watch(expenseCategoryRepositoryProvider)),
);
final searchExpenseCategoriesUseCaseProvider =
    Provider<SearchExpenseCategoriesUseCase>(
      (ref) => SearchExpenseCategoriesUseCase(
        ref.watch(expenseCategoryRepositoryProvider),
      ),
    );
final createExpenseCategoryUseCaseProvider =
    Provider<CreateExpenseCategoryUseCase>(
      (ref) => CreateExpenseCategoryUseCase(
        ref.watch(expenseCategoryRepositoryProvider),
        ref.watch(expenseCategoryValidationServiceProvider),
      ),
    );
final updateExpenseCategoryUseCaseProvider =
    Provider<UpdateExpenseCategoryUseCase>(
      (ref) => UpdateExpenseCategoryUseCase(
        ref.watch(expenseCategoryRepositoryProvider),
        ref.watch(expenseCategoryValidationServiceProvider),
      ),
    );
final deleteExpenseCategoryUseCaseProvider =
    Provider<DeleteExpenseCategoryUseCase>(
      (ref) => DeleteExpenseCategoryUseCase(
        ref.watch(expenseCategoryRepositoryProvider),
      ),
    );
final refreshExpenseCategoriesUseCaseProvider =
    Provider<RefreshExpenseCategoriesUseCase>(
      (ref) => const RefreshExpenseCategoriesUseCase(),
    );

final expenseCategoryListProvider =
    createMasterListProvider<ExpenseCategory, GetExpenseCategoriesUseCase>(
      repositoryProvider: getExpenseCategoriesUseCaseProvider,
      load: (u) => u(),
    );
final expenseCategorySearchProvider =
    createMasterSearchProvider<ExpenseCategory, SearchExpenseCategoriesUseCase>(
      repositoryProvider: searchExpenseCategoriesUseCaseProvider,
      search: (u, q) => u(q),
    );
final selectedExpenseCategoryProvider =
    createSelectedMasterProvider<ExpenseCategory, GetExpenseCategoryUseCase>(
      repositoryProvider: getExpenseCategoryUseCaseProvider,
      load: (u, id) => u(id),
    );

final expenseCategoryRealtimeProvider =
    StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
      return ref
          .watch(realtimeServiceProvider)
          .tableStream(table: 'expense_categories', primaryKey: <String>['id']);
    });

Future<void> refreshExpenseCategoryProviders(WidgetRef ref) async {
  await ref.read(refreshExpenseCategoriesUseCaseProvider)();
  ref.invalidate(expenseCategoryListProvider);
}

Future<void> saveExpenseCategoryProviders(
  WidgetRef ref, {
  required String? expenseCategoryId,
  required ExpenseCategoryInput input,
  required void Function(ExpenseCategory) onSuccess,
  required void Function(String) onFailure,
}) async {
  final result =
      expenseCategoryId == null
          ? await ref.read(createExpenseCategoryUseCaseProvider)(input)
          : await ref.read(updateExpenseCategoryUseCaseProvider)(
            UpdateParams<ExpenseCategoryInput>(
              id: expenseCategoryId,
              input: input,
            ),
          );
  result.when(
    success: (ec) {
      ref.invalidate(expenseCategoryListProvider);
      ref.invalidate(selectedExpenseCategoryProvider(ec.id));
      onSuccess(ec);
    },
    failure: (f) => onFailure(f.message),
  );
}
