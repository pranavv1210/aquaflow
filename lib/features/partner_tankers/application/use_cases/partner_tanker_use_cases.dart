import '../../../../core/application/use_case.dart';
import '../../../../core/models/partner_tanker.dart';
import '../../../../core/result/result.dart';
import '../../domain/partner_tanker_input.dart';
import '../../domain/repositories/partner_tanker_repository.dart';
import '../partner_tanker_validation_service.dart';

class GetPartnerTankersUseCase implements GetListUseCase<PartnerTanker> {
  const GetPartnerTankersUseCase(this._repository);
  final PartnerTankerRepository _repository;
  @override Future<Result<List<PartnerTanker>>> call() => _repository.getPartnerTankers();
}

class GetPartnerTankerUseCase implements GetByIdUseCase<PartnerTanker> {
  const GetPartnerTankerUseCase(this._repository);
  final PartnerTankerRepository _repository;
  @override Future<Result<PartnerTanker>> call(String params) => _repository.getPartnerTankerById(params);
}

class SearchPartnerTankersUseCase implements SearchUseCase<PartnerTanker> {
  const SearchPartnerTankersUseCase(this._repository);
  final PartnerTankerRepository _repository;
  @override Future<Result<List<PartnerTanker>>> call(String params) => _repository.searchPartnerTankers(params);
}

class CreatePartnerTankerUseCase implements CreateUseCase<PartnerTanker, PartnerTankerInput> {
  const CreatePartnerTankerUseCase(this._repository, this._validationService);
  final PartnerTankerRepository _repository;
  final PartnerTankerValidationService _validationService;
  @override Future<Result<PartnerTanker>> call(PartnerTankerInput params) async {
    final validation = _validationService.validateForSave(params);
    return validation.when(success: _repository.createPartnerTanker, failure: (f) async => Failure<PartnerTanker>(f));
  }
}

class UpdatePartnerTankerUseCase implements UpdateUseCase<PartnerTanker, PartnerTankerInput> {
  const UpdatePartnerTankerUseCase(this._repository, this._validationService);
  final PartnerTankerRepository _repository;
  final PartnerTankerValidationService _validationService;
  @override Future<Result<PartnerTanker>> call(UpdateParams<PartnerTankerInput> params) async {
    final validation = _validationService.validateForSave(params.input);
    return validation.when(success: (i) => _repository.updatePartnerTanker(params.id, i), failure: (f) async => Failure<PartnerTanker>(f));
  }
}

class DeletePartnerTankerUseCase implements DeleteUseCase {
  const DeletePartnerTankerUseCase(this._repository);
  final PartnerTankerRepository _repository;
  @override Future<Result<void>> call(String params) => _repository.softDeletePartnerTanker(params);
}

class RefreshPartnerTankersUseCase implements RefreshUseCase {
  const RefreshPartnerTankersUseCase();
  @override Future<Result<void>> call() async => const Success<void>(null);
}
