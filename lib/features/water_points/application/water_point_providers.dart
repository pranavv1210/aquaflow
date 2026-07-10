import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/application/use_case.dart';
import '../../../core/models/water_point.dart';
import '../../../core/services/supabase_providers.dart';
import '../../../core/shared/masters/master_providers.dart';
import '../data/repositories/supabase_water_point_repository.dart';
import '../domain/water_point_input.dart';
import '../domain/repositories/water_point_repository.dart';
import 'water_point_validation_service.dart';
import 'use_cases/water_point_use_cases.dart';

final waterPointRepositoryProvider = Provider<WaterPointRepository>((ref) {
  return SupabaseWaterPointRepository(ref.watch(supabaseClientProvider));
});

final waterPointValidationServiceProvider = Provider<WaterPointValidationService>((ref) => const WaterPointValidationService());

final getWaterPointsUseCaseProvider = Provider<GetWaterPointsUseCase>((ref) => GetWaterPointsUseCase(ref.watch(waterPointRepositoryProvider)));
final getWaterPointUseCaseProvider = Provider<GetWaterPointUseCase>((ref) => GetWaterPointUseCase(ref.watch(waterPointRepositoryProvider)));
final searchWaterPointsUseCaseProvider = Provider<SearchWaterPointsUseCase>((ref) => SearchWaterPointsUseCase(ref.watch(waterPointRepositoryProvider)));
final createWaterPointUseCaseProvider = Provider<CreateWaterPointUseCase>((ref) => CreateWaterPointUseCase(ref.watch(waterPointRepositoryProvider), ref.watch(waterPointValidationServiceProvider)));
final updateWaterPointUseCaseProvider = Provider<UpdateWaterPointUseCase>((ref) => UpdateWaterPointUseCase(ref.watch(waterPointRepositoryProvider), ref.watch(waterPointValidationServiceProvider)));
final deleteWaterPointUseCaseProvider = Provider<DeleteWaterPointUseCase>((ref) => DeleteWaterPointUseCase(ref.watch(waterPointRepositoryProvider)));
final refreshWaterPointsUseCaseProvider = Provider<RefreshWaterPointsUseCase>((ref) => const RefreshWaterPointsUseCase());

final waterPointListProvider = createMasterListProvider<WaterPoint, GetWaterPointsUseCase>(repositoryProvider: getWaterPointsUseCaseProvider, load: (u) => u());
final waterPointSearchProvider = createMasterSearchProvider<WaterPoint, SearchWaterPointsUseCase>(repositoryProvider: searchWaterPointsUseCaseProvider, search: (u, q) => u(q));
final selectedWaterPointProvider = createSelectedMasterProvider<WaterPoint, GetWaterPointUseCase>(repositoryProvider: getWaterPointUseCaseProvider, load: (u, id) => u(id));

Future<void> refreshWaterPointProviders(WidgetRef ref) async {
  await ref.read(refreshWaterPointsUseCaseProvider)();
  ref.invalidate(waterPointListProvider);
}

Future<void> saveWaterPointProviders(WidgetRef ref, {required String? waterPointId, required WaterPointInput input, required void Function(WaterPoint) onSuccess, required void Function(String) onFailure}) async {
  final result = waterPointId == null ? await ref.read(createWaterPointUseCaseProvider)(input) : await ref.read(updateWaterPointUseCaseProvider)(UpdateParams<WaterPointInput>(id: waterPointId, input: input));
  result.when(success: (wp) { ref.invalidate(waterPointListProvider); ref.invalidate(selectedWaterPointProvider(wp.id)); onSuccess(wp); }, failure: (f) => onFailure(f.message));
}
