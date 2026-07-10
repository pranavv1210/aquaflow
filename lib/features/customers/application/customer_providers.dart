import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/use_case.dart';
import '../../../core/models/customer.dart';
import '../../../core/services/supabase_providers.dart';
import '../../../core/shared/masters/master_providers.dart';
import '../data/repositories/supabase_customer_repository.dart';
import '../domain/customer_input.dart';
import '../domain/repositories/customer_repository.dart';
import 'customer_validation_service.dart';
import 'use_cases/customer_use_cases.dart';

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseCustomerRepository(client);
});

final customerValidationServiceProvider = Provider<CustomerValidationService>((
  ref,
) {
  return const CustomerValidationService();
});

final getCustomersUseCaseProvider = Provider<GetCustomersUseCase>((ref) {
  return GetCustomersUseCase(ref.watch(customerRepositoryProvider));
});

final getCustomerUseCaseProvider = Provider<GetCustomerUseCase>((ref) {
  return GetCustomerUseCase(ref.watch(customerRepositoryProvider));
});

final searchCustomersUseCaseProvider = Provider<SearchCustomersUseCase>((ref) {
  return SearchCustomersUseCase(ref.watch(customerRepositoryProvider));
});

final createCustomerUseCaseProvider = Provider<CreateCustomerUseCase>((ref) {
  return CreateCustomerUseCase(
    ref.watch(customerRepositoryProvider),
    ref.watch(customerValidationServiceProvider),
  );
});

final updateCustomerUseCaseProvider = Provider<UpdateCustomerUseCase>((ref) {
  return UpdateCustomerUseCase(
    ref.watch(customerRepositoryProvider),
    ref.watch(customerValidationServiceProvider),
  );
});

final deleteCustomerUseCaseProvider = Provider<DeleteCustomerUseCase>((ref) {
  return DeleteCustomerUseCase(ref.watch(customerRepositoryProvider));
});

final refreshCustomersUseCaseProvider = Provider<RefreshCustomersUseCase>((
  ref,
) {
  return const RefreshCustomersUseCase();
});

final customerListProvider =
    createMasterListProvider<Customer, GetCustomersUseCase>(
      repositoryProvider: getCustomersUseCaseProvider,
      load: (GetCustomersUseCase useCase) => useCase(),
    );

final customerSearchProvider =
    createMasterSearchProvider<Customer, SearchCustomersUseCase>(
      repositoryProvider: searchCustomersUseCaseProvider,
      search: (SearchCustomersUseCase useCase, String query) {
        return useCase(query);
      },
    );

final selectedCustomerProvider =
    createSelectedMasterProvider<Customer, GetCustomerUseCase>(
      repositoryProvider: getCustomerUseCaseProvider,
      load: (GetCustomerUseCase useCase, String customerId) {
        return useCase(customerId);
      },
    );

final customersByLocationProvider = FutureProvider.autoDispose
    .family<List<Customer>, String>((ref, locationId) async {
      final result = await ref
          .watch(customerRepositoryProvider)
          .getCustomersByLocation(locationId);
      return result.getOrThrow();
    });

final customerRealtimeProvider =
    StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
      return ref
          .watch(realtimeServiceProvider)
          .tableStream(table: 'customers', primaryKey: <String>['id']);
    });

Future<void> refreshCustomerProviders(WidgetRef ref) async {
  await ref.read(refreshCustomersUseCaseProvider)();
  ref.invalidate(customerListProvider);
}

Future<void> saveCustomerProviders(
  WidgetRef ref, {
  required String? customerId,
  required CustomerInput input,
  required void Function(Customer customer) onSuccess,
  required void Function(String message) onFailure,
}) async {
  final result =
      customerId == null
          ? await ref.read(createCustomerUseCaseProvider)(input)
          : await ref.read(updateCustomerUseCaseProvider)(
            UpdateParams<CustomerInput>(id: customerId, input: input),
          );

  result.when(
    success: (Customer customer) {
      ref.invalidate(customerListProvider);
      ref.invalidate(selectedCustomerProvider(customer.id));
      onSuccess(customer);
    },
    failure: (failure) => onFailure(failure.message),
  );
}
