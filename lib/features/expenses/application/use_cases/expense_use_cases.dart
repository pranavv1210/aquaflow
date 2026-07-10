import '../../../../core/application/use_case.dart';
import '../../../../core/result/result.dart';
import '../../domain/expense_input.dart';
import '../../domain/expense_record.dart';
import '../../domain/repositories/expense_repository.dart';
import '../expense_validation_service.dart';

class GetExpensesUseCase implements GetListUseCase<ExpenseRecord> {
  const GetExpensesUseCase(this._repository);

  final ExpenseRepository _repository;

  @override
  Future<Result<List<ExpenseRecord>>> call() => _repository.getExpenses();
}

class GetExpenseUseCase implements GetByIdUseCase<ExpenseRecord> {
  const GetExpenseUseCase(this._repository);

  final ExpenseRepository _repository;

  @override
  Future<Result<ExpenseRecord>> call(String params) {
    return _repository.getExpenseById(params);
  }
}

class SearchExpensesUseCase implements SearchUseCase<ExpenseRecord> {
  const SearchExpensesUseCase(this._repository);

  final ExpenseRepository _repository;

  @override
  Future<Result<List<ExpenseRecord>>> call(String params) {
    return _repository.searchExpenses(params);
  }
}

class CreateExpenseUseCase
    implements CreateUseCase<ExpenseRecord, ExpenseInput> {
  const CreateExpenseUseCase(this._repository, this._validationService);

  final ExpenseRepository _repository;
  final ExpenseValidationService _validationService;

  @override
  Future<Result<ExpenseRecord>> call(ExpenseInput params) async {
    final validation = _validationService.validateForSave(params);
    return validation.when(
      success: _repository.createExpense,
      failure: (failure) async => Failure<ExpenseRecord>(failure),
    );
  }
}

class UpdateExpenseUseCase
    implements UpdateUseCase<ExpenseRecord, ExpenseInput> {
  const UpdateExpenseUseCase(this._repository, this._validationService);

  final ExpenseRepository _repository;
  final ExpenseValidationService _validationService;

  @override
  Future<Result<ExpenseRecord>> call(UpdateParams<ExpenseInput> params) async {
    final validation = _validationService.validateForSave(params.input);
    return validation.when(
      success:
          (ExpenseInput input) => _repository.updateExpense(params.id, input),
      failure: (failure) async => Failure<ExpenseRecord>(failure),
    );
  }
}

class RefreshExpensesUseCase implements RefreshUseCase {
  const RefreshExpensesUseCase();

  @override
  Future<Result<void>> call() async {
    return const Success<void>(null);
  }
}
