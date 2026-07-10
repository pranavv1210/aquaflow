import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/use_case.dart';
import '../../../core/models/vehicle.dart';
import '../../../core/services/supabase_providers.dart';
import '../../../core/shared/masters/master_providers.dart';
import '../data/repositories/supabase_vehicle_repository.dart';
import '../domain/vehicle_input.dart';
import '../domain/repositories/vehicle_repository.dart';
import 'vehicle_validation_service.dart';
import 'use_cases/vehicle_use_cases.dart';

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseVehicleRepository(client);
});

final vehicleValidationServiceProvider = Provider<VehicleValidationService>((
  ref,
) {
  return const VehicleValidationService();
});

final getVehiclesUseCaseProvider = Provider<GetVehiclesUseCase>((ref) {
  return GetVehiclesUseCase(ref.watch(vehicleRepositoryProvider));
});

final getVehicleUseCaseProvider = Provider<GetVehicleUseCase>((ref) {
  return GetVehicleUseCase(ref.watch(vehicleRepositoryProvider));
});

final searchVehiclesUseCaseProvider = Provider<SearchVehiclesUseCase>((ref) {
  return SearchVehiclesUseCase(ref.watch(vehicleRepositoryProvider));
});

final createVehicleUseCaseProvider = Provider<CreateVehicleUseCase>((ref) {
  return CreateVehicleUseCase(
    ref.watch(vehicleRepositoryProvider),
    ref.watch(vehicleValidationServiceProvider),
  );
});

final updateVehicleUseCaseProvider = Provider<UpdateVehicleUseCase>((ref) {
  return UpdateVehicleUseCase(
    ref.watch(vehicleRepositoryProvider),
    ref.watch(vehicleValidationServiceProvider),
  );
});

final deleteVehicleUseCaseProvider = Provider<DeleteVehicleUseCase>((ref) {
  return DeleteVehicleUseCase(ref.watch(vehicleRepositoryProvider));
});

final refreshVehiclesUseCaseProvider = Provider<RefreshVehiclesUseCase>((ref) {
  return const RefreshVehiclesUseCase();
});

final vehicleListProvider =
    createMasterListProvider<Vehicle, GetVehiclesUseCase>(
      repositoryProvider: getVehiclesUseCaseProvider,
      load: (GetVehiclesUseCase useCase) => useCase(),
    );

final vehicleSearchProvider =
    createMasterSearchProvider<Vehicle, SearchVehiclesUseCase>(
      repositoryProvider: searchVehiclesUseCaseProvider,
      search: (SearchVehiclesUseCase useCase, String query) => useCase(query),
    );

final selectedVehicleProvider =
    createSelectedMasterProvider<Vehicle, GetVehicleUseCase>(
      repositoryProvider: getVehicleUseCaseProvider,
      load: (GetVehicleUseCase useCase, String vehicleId) => useCase(vehicleId),
    );

final vehicleRealtimeProvider =
    StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
      return ref
          .watch(realtimeServiceProvider)
          .tableStream(table: 'vehicles', primaryKey: <String>['id']);
    });

Future<void> refreshVehicleProviders(WidgetRef ref) async {
  await ref.read(refreshVehiclesUseCaseProvider)();
  ref.invalidate(vehicleListProvider);
}

Future<void> saveVehicleProviders(
  WidgetRef ref, {
  required String? vehicleId,
  required VehicleInput input,
  required void Function(Vehicle vehicle) onSuccess,
  required void Function(String message) onFailure,
}) async {
  final result =
      vehicleId == null
          ? await ref.read(createVehicleUseCaseProvider)(input)
          : await ref.read(updateVehicleUseCaseProvider)(
            UpdateParams<VehicleInput>(id: vehicleId, input: input),
          );
  result.when(
    success: (Vehicle vehicle) {
      ref.invalidate(vehicleListProvider);
      ref.invalidate(selectedVehicleProvider(vehicle.id));
      onSuccess(vehicle);
    },
    failure: (failure) => onFailure(failure.message),
  );
}
