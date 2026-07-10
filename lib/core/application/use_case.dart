import '../result/result.dart';

abstract interface class UseCase<TOutput, TParams> {
  Future<Result<TOutput>> call(TParams params);
}

abstract interface class NoParamsUseCase<TOutput> {
  Future<Result<TOutput>> call();
}

class NoParams {
  const NoParams();
}

abstract interface class CreateUseCase<TOutput, TInput>
    implements UseCase<TOutput, TInput> {}

abstract interface class UpdateUseCase<TOutput, TInput>
    implements UseCase<TOutput, UpdateParams<TInput>> {}

abstract interface class DeleteUseCase implements UseCase<void, String> {}

abstract interface class SearchUseCase<TOutput>
    implements UseCase<List<TOutput>, String> {}

abstract interface class GetByIdUseCase<TOutput>
    implements UseCase<TOutput, String> {}

abstract interface class GetListUseCase<TOutput>
    implements NoParamsUseCase<List<TOutput>> {}

abstract interface class RefreshUseCase implements NoParamsUseCase<void> {}

class UpdateParams<TInput> {
  const UpdateParams({required this.id, required this.input});

  final String id;
  final TInput input;
}
