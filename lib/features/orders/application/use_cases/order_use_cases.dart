import '../../../../core/application/use_case.dart';
import '../../../../core/result/result.dart';
import '../../domain/order_input.dart';
import '../../domain/order_record.dart';
import '../../domain/repositories/order_repository.dart';
import '../order_validation_service.dart';

class GetOrdersUseCase implements GetListUseCase<OrderRecord> {
  const GetOrdersUseCase(this._repository);

  final OrderRepository _repository;

  @override
  Future<Result<List<OrderRecord>>> call() => _repository.getOrders();
}

class GetOrderUseCase implements GetByIdUseCase<OrderRecord> {
  const GetOrderUseCase(this._repository);

  final OrderRepository _repository;

  @override
  Future<Result<OrderRecord>> call(String params) {
    return _repository.getOrderById(params);
  }
}

class SearchOrdersUseCase implements SearchUseCase<OrderRecord> {
  const SearchOrdersUseCase(this._repository);

  final OrderRepository _repository;

  @override
  Future<Result<List<OrderRecord>>> call(String params) {
    return _repository.searchOrders(params);
  }
}

class CreateOrderUseCase implements CreateUseCase<OrderRecord, OrderInput> {
  const CreateOrderUseCase(this._repository, this._validationService);

  final OrderRepository _repository;
  final OrderValidationService _validationService;

  @override
  Future<Result<OrderRecord>> call(OrderInput params) async {
    final validation = _validationService.validateForSave(params);
    return validation.when(
      success: _repository.createOrder,
      failure: (failure) async => Failure<OrderRecord>(failure),
    );
  }
}

class UpdateOrderUseCase implements UpdateUseCase<OrderRecord, OrderInput> {
  const UpdateOrderUseCase(this._repository, this._validationService);

  final OrderRepository _repository;
  final OrderValidationService _validationService;

  @override
  Future<Result<OrderRecord>> call(UpdateParams<OrderInput> params) async {
    final validation = _validationService.validateForSave(params.input);
    return validation.when(
      success: (OrderInput input) => _repository.updateOrder(params.id, input),
      failure: (failure) async => Failure<OrderRecord>(failure),
    );
  }
}

class DeleteOrderUseCase implements DeleteUseCase {
  const DeleteOrderUseCase(this._repository);

  final OrderRepository _repository;

  @override
  Future<Result<void>> call(String params) {
    return _repository.softDeleteOrder(params);
  }
}
