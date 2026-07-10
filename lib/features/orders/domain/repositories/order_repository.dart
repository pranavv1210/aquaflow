import '../../../../core/result/result.dart';
import '../order_input.dart';
import '../order_record.dart';

abstract interface class OrderRepository {
  Future<Result<List<OrderRecord>>> getOrders();

  Future<Result<OrderRecord>> getOrderById(String id);

  Future<Result<OrderRecord>> createOrder(OrderInput input);

  Future<Result<OrderRecord>> updateOrder(String id, OrderInput input);

  Future<Result<void>> softDeleteOrder(String id);

  Future<Result<List<OrderRecord>>> searchOrders(String query);
}
