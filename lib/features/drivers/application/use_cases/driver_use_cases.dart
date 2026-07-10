import '../../../../core/application/use_case.dart';
import '../../../../core/models/driver.dart';
import '../../../../core/result/result.dart';
import '../../domain/driver_input.dart';
import '../../domain/repositories/driver_repository.dart';
import '../driver_validation_service.dart';

class GetDriversUseCase implements GetListUseCase<Driver> {
  const GetDriversUseCase(this._repository);

  final DriverRepository _repository;

  @override
  Future<Result<List<Driver>>> call() {
    return _repository.getDrivers();
  }
}

class GetDriverUseCase implements GetByIdUseCase<Driver> {
  const GetDriverUseCase(this._repository);

  final DriverRepository _repository;

  @override
  Future<Result<Driver>> call(String params) {
    return _repository.getDriverById(params);
  }
}

class SearchDriversUseCase implements SearchUseCase<Driver> {
  const SearchDriversUseCase(this._repository);

  final DriverRepository _repository;

  @override
  Future<Result<List<Driver>>> call(String params) {
    return _repository.searchDrivers(params);
  }
}

class CreateDriverUseCase implements CreateUseCase<Driver, DriverInput> {
  const CreateDriverUseCase(this._repository, this._validationService);

  final DriverRepository _repository;
  final DriverValidationService _validationService;

  @override
  Future<Result<Driver>> call(DriverInput params) async {
    final validation = _validationService.validateForSave(params);
    return validation.when(
      success: _repository.createDriver,
      failure: (failure) async => Failure<Driver>(failure),
    );
  }
}

class UpdateDriverUseCase implements UpdateUseCase<Driver, DriverInput> {
  const UpdateDriverUseCase(this._repository, this._validationService);

  final DriverRepository _repository;
  final DriverValidationService _validationService;

  @override
  Future<Result<Driver>> call(UpdateParams<DriverInput> params) async {
    final validation = _validationService.validateForSave(params.input);
    return validation.when(
      success: (DriverInput input) {
        return _repository.updateDriver(params.id, input);
      },
      failure: (failure) async => Failure<Driver>(failure),
    );
  }
}

class DeleteDriverUseCase implements DeleteUseCase {
  const DeleteDriverUseCase(this._repository);

  final DriverRepository _repository;

  @override
  Future<Result<void>> call(String params) {
    return _repository.softDeleteDriver(params);
  }
}

class RefreshDriversUseCase implements RefreshUseCase {
  const RefreshDriversUseCase();

  @override
  Future<Result<void>> call() async {
    return const Success<void>(null);
  }
}