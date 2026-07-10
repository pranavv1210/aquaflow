import '../../../../core/application/use_case.dart';
import '../../../../core/models/vehicle.dart';
import '../../../../core/result/result.dart';
import '../../domain/vehicle_input.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../vehicle_validation_service.dart';

class GetVehiclesUseCase implements GetListUseCase<Vehicle> {
  const GetVehiclesUseCase(this._repository);
  final VehicleRepository _repository;
  @override
  Future<Result<List<Vehicle>>> call() => _repository.getVehicles();
}

class GetVehicleUseCase implements GetByIdUseCase<Vehicle> {
  const GetVehicleUseCase(this._repository);
  final VehicleRepository _repository;
  @override
  Future<Result<Vehicle>> call(String params) => _repository.getVehicleById(params);
}

class SearchVehiclesUseCase implements SearchUseCase<Vehicle> {
  const SearchVehiclesUseCase(this._repository);
  final VehicleRepository _repository;
  @override
  Future<Result<List<Vehicle>>> call(String params) => _repository.searchVehicles(params);
}

class CreateVehicleUseCase implements CreateUseCase<Vehicle, VehicleInput> {
  const CreateVehicleUseCase(this._repository, this._validationService);
  final VehicleRepository _repository;
  final VehicleValidationService _validationService;
  @override
  Future<Result<Vehicle>> call(VehicleInput params) async {
    final validation = _validationService.validateForSave(params);
    return validation.when(
      success: _repository.createVehicle,
      failure: (failure) async => Failure<Vehicle>(failure),
    );
  }
}

class UpdateVehicleUseCase implements UpdateUseCase<Vehicle, VehicleInput> {
  const UpdateVehicleUseCase(this._repository, this._validationService);
  final VehicleRepository _repository;
  final VehicleValidationService _validationService;
  @override
  Future<Result<Vehicle>> call(UpdateParams<VehicleInput> params) async {
    final validation = _validationService.validateForSave(params.input);
    return validation.when(
      success: (VehicleInput input) => _repository.updateVehicle(params.id, input),
      failure: (failure) async => Failure<Vehicle>(failure),
    );
  }
}

class DeleteVehicleUseCase implements DeleteUseCase {
  const DeleteVehicleUseCase(this._repository);
  final VehicleRepository _repository;
  @override
  Future<Result<void>> call(String params) => _repository.softDeleteVehicle(params);
}

class RefreshVehiclesUseCase implements RefreshUseCase {
  const RefreshVehiclesUseCase();
  @override
  Future<Result<void>> call() async => const Success<void>(null);
}
