import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/use_case.dart';
import '../../../core/services/supabase_providers.dart';
import '../data/repositories/supabase_order_repository.dart';
import '../domain/order_input.dart';
import '../domain/order_record.dart';
import '../domain/repositories/order_repository.dart';
import 'order_validation_service.dart';
import 'use_cases/order_use_cases.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return SupabaseOrderRepository(ref.watch(supabaseClientProvider));
});

final orderValidationServiceProvider = Provider<OrderValidationService>((ref) {
  return const OrderValidationService();
});

final getOrdersUseCaseProvider = Provider<GetOrdersUseCase>((ref) {
  return GetOrdersUseCase(ref.watch(orderRepositoryProvider));
});

final getOrderUseCaseProvider = Provider<GetOrderUseCase>((ref) {
  return GetOrderUseCase(ref.watch(orderRepositoryProvider));
});

final searchOrdersUseCaseProvider = Provider<SearchOrdersUseCase>((ref) {
  return SearchOrdersUseCase(ref.watch(orderRepositoryProvider));
});

final createOrderUseCaseProvider = Provider<CreateOrderUseCase>((ref) {
  return CreateOrderUseCase(
    ref.watch(orderRepositoryProvider),
    ref.watch(orderValidationServiceProvider),
  );
});

final updateOrderUseCaseProvider = Provider<UpdateOrderUseCase>((ref) {
  return UpdateOrderUseCase(
    ref.watch(orderRepositoryProvider),
    ref.watch(orderValidationServiceProvider),
  );
});

final deleteOrderUseCaseProvider = Provider<DeleteOrderUseCase>((ref) {
  return DeleteOrderUseCase(ref.watch(orderRepositoryProvider));
});

final orderListProvider = FutureProvider.autoDispose<List<OrderRecord>>((
  ref,
) async {
  final result = await ref.watch(getOrdersUseCaseProvider)();
  return result.getOrThrow();
});

final orderSearchProvider = FutureProvider.autoDispose
    .family<List<OrderRecord>, String>((ref, query) async {
      final result = await ref.watch(searchOrdersUseCaseProvider)(query);
      return result.getOrThrow();
    });

final selectedOrderProvider = FutureProvider.autoDispose
    .family<OrderRecord, String>((ref, orderId) async {
      final result = await ref.watch(getOrderUseCaseProvider)(orderId);
      return result.getOrThrow();
    });

final orderRealtimeProvider =
    StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
      return ref
          .watch(realtimeServiceProvider)
          .tableStream(table: 'orders', primaryKey: <String>['id']);
    });

Future<void> saveOrder(
  WidgetRef ref, {
  required String? orderId,
  required OrderInput input,
  required void Function(OrderRecord order) onSuccess,
  required void Function(String message) onFailure,
}) async {
  final result =
      orderId == null
          ? await ref.read(createOrderUseCaseProvider)(input)
          : await ref.read(updateOrderUseCaseProvider)(
            UpdateParams<OrderInput>(id: orderId, input: input),
          );

  result.when(
    success: (OrderRecord order) {
      ref.invalidate(orderListProvider);
      ref.invalidate(selectedOrderProvider(order.id));
      onSuccess(order);
    },
    failure: (failure) => onFailure(failure.message),
  );
}
