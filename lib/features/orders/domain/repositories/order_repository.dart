import '../../../../core/result/result.dart';

abstract interface class OrderRepository {
  Future<Result<List<Map<String, dynamic>>>> getOrders();

  Future<Result<Map<String, dynamic>>> getOrderById(String id);

  Future<Result<Map<String, dynamic>>> createOrder(Map<String, dynamic> input);

  Future<Result<Map<String, dynamic>>> updateOrder(
    String id,
    Map<String, dynamic> input,
  );

  Future<Result<void>> softDeleteOrder(String id);

  Future<Result<List<Map<String, dynamic>>>> searchOrders(String query);
}
