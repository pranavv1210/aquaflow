import '../../../../core/repositories/supabase_repository.dart';
import '../../../../core/result/result.dart';
import '../../domain/repositories/order_repository.dart';

class SupabaseOrderRepository extends SupabaseRepository
    implements OrderRepository {
  SupabaseOrderRepository(super.client);

  static const String _table = 'orders';

  @override
  Future<Result<List<Map<String, dynamic>>>> getOrders() {
    return guard<List<Map<String, dynamic>>>('Load orders', () async {
      final response = await client
          .from(_table)
          .select()
          .eq('is_deleted', false)
          .order('order_date', ascending: false);
      return _rows(response);
    });
  }

  @override
  Future<Result<Map<String, dynamic>>> getOrderById(String id) {
    return selectRowById(_table, id);
  }

  @override
  Future<Result<Map<String, dynamic>>> createOrder(Map<String, dynamic> input) {
    return insertRow(_table, input);
  }

  @override
  Future<Result<Map<String, dynamic>>> updateOrder(
    String id,
    Map<String, dynamic> input,
  ) {
    return updateRow(_table, id, input);
  }

  @override
  Future<Result<void>> softDeleteOrder(String id) {
    return softDeleteRow(_table, id, column: 'is_deleted');
  }

  @override
  Future<Result<List<Map<String, dynamic>>>> searchOrders(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return getOrders();
    }

    return guard<List<Map<String, dynamic>>>('Search orders', () async {
      final escaped = trimmed.replaceAll('%', r'\%').replaceAll('_', r'\_');
      final response = await client
          .from(_table)
          .select()
          .eq('is_deleted', false)
          .ilike('order_number', '%$escaped%')
          .order('order_date', ascending: false);
      return _rows(response);
    });
  }

  List<Map<String, dynamic>> _rows(dynamic response) {
    return (response as List<dynamic>).cast<Map<String, dynamic>>().toList(
      growable: false,
    );
  }
}
