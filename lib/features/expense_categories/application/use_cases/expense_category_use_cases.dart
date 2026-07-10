import '../../../../core/application/use_case.dart';
import '../../../../core/models/expense_category.dart';
import '../../../../core/result/result.dart';
import '../../domain/expense_category_input.dart';
import '../../domain/repositories/expense_category_repository.dart';
import '../expense_category_validation_service.dart';

class GetExpenseCategoriesUseCase implements GetListUseCase<ExpenseCategory> {
  const GetExpenseCategoriesUseCase(this._repository);
  final ExpenseCategoryRepository _repository;
  @override Future<Result<List<ExpenseCategory>>> call() => _repository.getExpenseCategories();
}

class GetExpenseCategoryUseCase implements GetByIdUseCase<ExpenseCategory> {
  const GetExpenseCategoryUseCase(this._repository);
  final ExpenseCategoryRepository _repository;
  @override Future<Result<ExpenseCategory>> call(String params) => _repository.getExpenseCategoryById(params);
}

class SearchExpenseCategoriesUseCase implements SearchUseCase<ExpenseCategory> {
  const SearchExpenseCategoriesUseCase(this._repository);
  final ExpenseCategoryRepository _repository;
  @override Future<Result<List<ExpenseCategory>>> call(String params) => _repository.searchExpenseCategories(params);
}

class CreateExpenseCategoryUseCase implements CreateUseCase<ExpenseCategory, ExpenseCategoryInput> {
  const CreateExpenseCategoryUseCase(this._repository, this._validationService);
  final ExpenseCategoryRepository _repository;
  final ExpenseCategoryValidationService _validationService;
  @override Future<Result<ExpenseCategory>> call(ExpenseCategoryInput params) async {
    final validation = _validationService.validateForSave(params);
    return validation.when(success: _repository.createExpenseCategory, failure: (f) async => Failure<ExpenseCategory>(f));
  }
}

class UpdateExpenseCategoryUseCase implements UpdateUseCase<ExpenseCategory, ExpenseCategoryInput> {
  const UpdateExpenseCategoryUseCase(this._repository, this._validationService);
  final ExpenseCategoryRepository _repository;
  final ExpenseCategoryValidationService _validationService;
  @override Future<Result<ExpenseCategory>> call(UpdateParams<ExpenseCategoryInput> params) async {
    final validation = _validationService.validateForSave(params.input);
    return validation.when(success: (i) => _repository.updateExpenseCategory(params.id, i), failure: (f) async => Failure<ExpenseCategory>(f));
  }
}

class DeleteExpenseCategoryUseCase implements DeleteUseCase {
  const DeleteExpenseCategoryUseCase(this._repository);
  final ExpenseCategoryRepository _repository;
  @override Future<Result<void>> call(String params) => _repository.softDeleteExpenseCategory(params);
}

class RefreshExpenseCategoriesUseCase implements RefreshUseCase {
  const RefreshExpenseCategoriesUseCase();
  @override Future<Result<void>> call() async => const Success<void>(null);
}
