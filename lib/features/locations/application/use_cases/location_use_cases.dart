import '../../../../core/application/use_case.dart';
import '../../../../core/models/location.dart';
import '../../../../core/result/result.dart';
import '../../domain/location_input.dart';
import '../../domain/repositories/location_repository.dart';
import '../location_validation_service.dart';

class GetLocationsUseCase implements GetListUseCase<Location> {
  const GetLocationsUseCase(this._repository);
  final LocationRepository _repository;
  @override
  Future<Result<List<Location>>> call() => _repository.getLocations();
}

class GetLocationUseCase implements GetByIdUseCase<Location> {
  const GetLocationUseCase(this._repository);
  final LocationRepository _repository;
  @override
  Future<Result<Location>> call(String params) => _repository.getLocationById(params);
}

class SearchLocationsUseCase implements SearchUseCase<Location> {
  const SearchLocationsUseCase(this._repository);
  final LocationRepository _repository;
  @override
  Future<Result<List<Location>>> call(String params) => _repository.searchLocations(params);
}

class CreateLocationUseCase implements CreateUseCase<Location, LocationInput> {
  const CreateLocationUseCase(this._repository, this._validationService);
  final LocationRepository _repository;
  final LocationValidationService _validationService;
  @override
  Future<Result<Location>> call(LocationInput params) async {
    final validation = _validationService.validateForSave(params);
    return validation.when(success: _repository.createLocation, failure: (f) async => Failure<Location>(f));
  }
}

class UpdateLocationUseCase implements UpdateUseCase<Location, LocationInput> {
  const UpdateLocationUseCase(this._repository, this._validationService);
  final LocationRepository _repository;
  final LocationValidationService _validationService;
  @override
  Future<Result<Location>> call(UpdateParams<LocationInput> params) async {
    final validation = _validationService.validateForSave(params.input);
    return validation.when(
      success: (input) => _repository.updateLocation(params.id, input),
      failure: (f) async => Failure<Location>(f),
    );
  }
}

class DeleteLocationUseCase implements DeleteUseCase {
  const DeleteLocationUseCase(this._repository);
  final LocationRepository _repository;
  @override
  Future<Result<void>> call(String params) => _repository.softDeleteLocation(params);
}

class RefreshLocationsUseCase implements RefreshUseCase {
  const RefreshLocationsUseCase();
  @override
  Future<Result<void>> call() async => const Success<void>(null);
}
