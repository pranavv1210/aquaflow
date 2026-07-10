import '../../../../core/application/use_case.dart';
import '../../../../core/models/customer.dart';
import '../../../../core/result/result.dart';
import '../../domain/customer_input.dart';
import '../../domain/repositories/customer_repository.dart';
import '../customer_validation_service.dart';

class GetCustomersUseCase implements GetListUseCase<Customer> {
  const GetCustomersUseCase(this._repository);

  final CustomerRepository _repository;

  @override
  Future<Result<List<Customer>>> call() {
    return _repository.getCustomers();
  }
}

class GetCustomerUseCase implements GetByIdUseCase<Customer> {
  const GetCustomerUseCase(this._repository);

  final CustomerRepository _repository;

  @override
  Future<Result<Customer>> call(String params) {
    return _repository.getCustomerById(params);
  }
}

class SearchCustomersUseCase implements SearchUseCase<Customer> {
  const SearchCustomersUseCase(this._repository);

  final CustomerRepository _repository;

  @override
  Future<Result<List<Customer>>> call(String params) {
    return _repository.searchCustomers(params);
  }
}

class CreateCustomerUseCase implements CreateUseCase<Customer, CustomerInput> {
  const CreateCustomerUseCase(this._repository, this._validationService);

  final CustomerRepository _repository;
  final CustomerValidationService _validationService;

  @override
  Future<Result<Customer>> call(CustomerInput params) async {
    final validation = _validationService.validateForSave(params);
    return validation.when(
      success: _repository.createCustomer,
      failure: (failure) async => Failure<Customer>(failure),
    );
  }
}

class UpdateCustomerUseCase implements UpdateUseCase<Customer, CustomerInput> {
  const UpdateCustomerUseCase(this._repository, this._validationService);

  final CustomerRepository _repository;
  final CustomerValidationService _validationService;

  @override
  Future<Result<Customer>> call(UpdateParams<CustomerInput> params) async {
    final validation = _validationService.validateForSave(params.input);
    return validation.when(
      success: (CustomerInput input) {
        return _repository.updateCustomer(params.id, input);
      },
      failure: (failure) async => Failure<Customer>(failure),
    );
  }
}

class DeleteCustomerUseCase implements DeleteUseCase {
  const DeleteCustomerUseCase(this._repository);

  final CustomerRepository _repository;

  @override
  Future<Result<void>> call(String params) {
    return _repository.softDeleteCustomer(params);
  }
}

class RefreshCustomersUseCase implements RefreshUseCase {
  const RefreshCustomersUseCase();

  @override
  Future<Result<void>> call() async {
    return const Success<void>(null);
  }
}
