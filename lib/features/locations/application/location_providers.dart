import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/use_case.dart';
import '../../../core/models/location.dart';
import '../../../core/services/supabase_providers.dart';
import '../../../core/shared/masters/master_providers.dart';
import '../data/repositories/supabase_location_repository.dart';
import '../domain/location_input.dart';
import '../domain/repositories/location_repository.dart';
import 'location_validation_service.dart';
import 'use_cases/location_use_cases.dart';

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseLocationRepository(client);
});

final locationValidationServiceProvider = Provider<LocationValidationService>((ref) {
  return const LocationValidationService();
});

final getLocationsUseCaseProvider = Provider<GetLocationsUseCase>((ref) {
  return GetLocationsUseCase(ref.watch(locationRepositoryProvider));
});

final getLocationUseCaseProvider = Provider<GetLocationUseCase>((ref) {
  return GetLocationUseCase(ref.watch(locationRepositoryProvider));
});

final searchLocationsUseCaseProvider = Provider<SearchLocationsUseCase>((ref) {
  return SearchLocationsUseCase(ref.watch(locationRepositoryProvider));
});

final createLocationUseCaseProvider = Provider<CreateLocationUseCase>((ref) {
  return CreateLocationUseCase(ref.watch(locationRepositoryProvider), ref.watch(locationValidationServiceProvider));
});

final updateLocationUseCaseProvider = Provider<UpdateLocationUseCase>((ref) {
  return UpdateLocationUseCase(ref.watch(locationRepositoryProvider), ref.watch(locationValidationServiceProvider));
});

final deleteLocationUseCaseProvider = Provider<DeleteLocationUseCase>((ref) {
  return DeleteLocationUseCase(ref.watch(locationRepositoryProvider));
});

final refreshLocationsUseCaseProvider = Provider<RefreshLocationsUseCase>((ref) {
  return const RefreshLocationsUseCase();
});

final locationListProvider = createMasterListProvider<Location, GetLocationsUseCase>(
  repositoryProvider: getLocationsUseCaseProvider,
  load: (GetLocationsUseCase useCase) => useCase(),
);

final locationSearchProvider = createMasterSearchProvider<Location, SearchLocationsUseCase>(
  repositoryProvider: searchLocationsUseCaseProvider,
  search: (SearchLocationsUseCase useCase, String query) => useCase(query),
);

final selectedLocationProvider = createSelectedMasterProvider<Location, GetLocationUseCase>(
  repositoryProvider: getLocationUseCaseProvider,
  load: (GetLocationUseCase useCase, String id) => useCase(id),
);

Future<void> refreshLocationProviders(WidgetRef ref) async {
  await ref.read(refreshLocationsUseCaseProvider)();
  ref.invalidate(locationListProvider);
}

Future<void> saveLocationProviders(
  WidgetRef ref, {
  required String? locationId,
  required LocationInput input,
  required void Function(Location location) onSuccess,
  required void Function(String message) onFailure,
}) async {
  final result = locationId == null
      ? await ref.read(createLocationUseCaseProvider)(input)
      : await ref.read(updateLocationUseCaseProvider)(UpdateParams<LocationInput>(id: locationId, input: input));
  result.when(
    success: (Location location) {
      ref.invalidate(locationListProvider);
      ref.invalidate(selectedLocationProvider(location.id));
      onSuccess(location);
    },
    failure: (failure) => onFailure(failure.message),
  );
}
