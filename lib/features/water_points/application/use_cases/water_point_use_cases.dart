import '../../../../core/application/use_case.dart';
import '../../../../core/models/water_point.dart';
import '../../../../core/result/result.dart';
import '../../domain/water_point_input.dart';
import '../../domain/repositories/water_point_repository.dart';
import '../water_point_validation_service.dart';

class GetWaterPointsUseCase implements GetListUseCase<WaterPoint> {
  const GetWaterPointsUseCase(this._repository);
  final WaterPointRepository _repository;
  @override Future<Result<List<WaterPoint>>> call() => _repository.getWaterPoints();
}

class GetWaterPointUseCase implements GetByIdUseCase<WaterPoint> {
  const GetWaterPointUseCase(this._repository);
  final WaterPointRepository _repository;
  @override Future<Result<WaterPoint>> call(String params) => _repository.getWaterPointById(params);
}

class SearchWaterPointsUseCase implements SearchUseCase<WaterPoint> {
  const SearchWaterPointsUseCase(this._repository);
  final WaterPointRepository _repository;
  @override Future<Result<List<WaterPoint>>> call(String params) => _repository.searchWaterPoints(params);
}

class CreateWaterPointUseCase implements CreateUseCase<WaterPoint, WaterPointInput> {
  const CreateWaterPointUseCase(this._repository, this._validationService);
  final WaterPointRepository _repository;
  final WaterPointValidationService _validationService;
  @override Future<Result<WaterPoint>> call(WaterPointInput params) async {
    final validation = _validationService.validateForSave(params);
    return validation.when(success: _repository.createWaterPoint, failure: (f) async => Failure<WaterPoint>(f));
  }
}

class UpdateWaterPointUseCase implements UpdateUseCase<WaterPoint, WaterPointInput> {
  const UpdateWaterPointUseCase(this._repository, this._validationService);
  final WaterPointRepository _repository;
  final WaterPointValidationService _validationService;
  @override Future<Result<WaterPoint>> call(UpdateParams<WaterPointInput> params) async {
    final validation = _validationService.validateForSave(params.input);
    return validation.when(success: (input) => _repository.updateWaterPoint(params.id, input), failure: (f) async => Failure<WaterPoint>(f));
  }
}

class DeleteWaterPointUseCase implements DeleteUseCase {
  const DeleteWaterPointUseCase(this._repository);
  final WaterPointRepository _repository;
  @override Future<Result<void>> call(String params) => _repository.softDeleteWaterPoint(params);
}

class RefreshWaterPointsUseCase implements RefreshUseCase {
  const RefreshWaterPointsUseCase();
  @override Future<Result<void>> call() async => const Success<void>(null);
}
