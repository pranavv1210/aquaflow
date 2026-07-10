import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/use_case.dart';
import '../../../core/models/driver.dart';
import '../../../core/services/supabase_providers.dart';
import '../../../core/shared/masters/master_providers.dart';
import '../data/repositories/supabase_driver_repository.dart';
import '../domain/driver_input.dart';
import '../domain/repositories/driver_repository.dart';
import 'driver_validation_service.dart';
import 'use_cases/driver_use_cases.dart';

final driverRepositoryProvider = Provider<DriverRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseDriverRepository(client);
});

final driverValidationServiceProvider = Provider<DriverValidationService>((
  ref,
) {
  return const DriverValidationService();
});

final getDriversUseCaseProvider = Provider<GetDriversUseCase>((ref) {
  return GetDriversUseCase(ref.watch(driverRepositoryProvider));
});

final getDriverUseCaseProvider = Provider<GetDriverUseCase>((ref) {
  return GetDriverUseCase(ref.watch(driverRepositoryProvider));
});

final searchDriversUseCaseProvider = Provider<SearchDriversUseCase>((ref) {
  return SearchDriversUseCase(ref.watch(driverRepositoryProvider));
});

final createDriverUseCaseProvider = Provider<CreateDriverUseCase>((ref) {
  return CreateDriverUseCase(
    ref.watch(driverRepositoryProvider),
    ref.watch(driverValidationServiceProvider),
  );
});

final updateDriverUseCaseProvider = Provider<UpdateDriverUseCase>((ref) {
  return UpdateDriverUseCase(
    ref.watch(driverRepositoryProvider),
    ref.watch(driverValidationServiceProvider),
  );
});

final deleteDriverUseCaseProvider = Provider<DeleteDriverUseCase>((ref) {
  return DeleteDriverUseCase(ref.watch(driverRepositoryProvider));
});

final refreshDriversUseCaseProvider = Provider<RefreshDriversUseCase>((ref) {
  return const RefreshDriversUseCase();
});

final driverListProvider = createMasterListProvider<Driver, GetDriversUseCase>(
  repositoryProvider: getDriversUseCaseProvider,
  load: (GetDriversUseCase useCase) => useCase(),
);

final driverSearchProvider =
    createMasterSearchProvider<Driver, SearchDriversUseCase>(
      repositoryProvider: searchDriversUseCaseProvider,
      search: (SearchDriversUseCase useCase, String query) {
        return useCase(query);
      },
    );

final selectedDriverProvider =
    createSelectedMasterProvider<Driver, GetDriverUseCase>(
      repositoryProvider: getDriverUseCaseProvider,
      load: (GetDriverUseCase useCase, String driverId) {
        return useCase(driverId);
      },
    );

final driverRealtimeProvider =
    StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
      return ref
          .watch(realtimeServiceProvider)
          .tableStream(table: 'drivers', primaryKey: <String>['id']);
    });

Future<void> refreshDriverProviders(WidgetRef ref) async {
  await ref.read(refreshDriversUseCaseProvider)();
  ref.invalidate(driverListProvider);
}

Future<void> saveDriverProviders(
  WidgetRef ref, {
  required String? driverId,
  required DriverInput input,
  required void Function(Driver driver) onSuccess,
  required void Function(String message) onFailure,
}) async {
  final result =
      driverId == null
          ? await ref.read(createDriverUseCaseProvider)(input)
          : await ref.read(updateDriverUseCaseProvider)(
            UpdateParams<DriverInput>(id: driverId, input: input),
          );

  result.when(
    success: (Driver driver) {
      ref.invalidate(driverListProvider);
      ref.invalidate(selectedDriverProvider(driver.id));
      onSuccess(driver);
    },
    failure: (failure) => onFailure(failure.message),
  );
}
