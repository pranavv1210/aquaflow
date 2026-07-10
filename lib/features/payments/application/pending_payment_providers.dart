import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/supabase_providers.dart';
import '../../orders/application/order_providers.dart';
import '../../orders/domain/order_record.dart';
import 'pending_payment_repository.dart';

final pendingPaymentRepositoryProvider = Provider<PendingPaymentRepository>((
  ref,
) {
  return PendingPaymentRepository(ref.watch(supabaseClientProvider));
});

final pendingPaymentListProvider =
    FutureProvider.autoDispose<List<OrderRecord>>((ref) async {
      final orders = await ref.watch(orderListProvider.future);
      return _pending(orders);
    });

final pendingPaymentSearchProvider = FutureProvider.autoDispose
    .family<List<OrderRecord>, String>((ref, query) async {
      final orders = await ref.watch(orderListProvider.future);
      final normalized = query.trim().toLowerCase();
      final pending = _pending(orders);
      if (normalized.isEmpty) {
        return pending;
      }
      return pending
          .where((OrderRecord order) {
            return order.customerName.toLowerCase().contains(normalized) ||
                (order.customerPhone?.toLowerCase().contains(normalized) ??
                    false) ||
                order.locationName.toLowerCase().contains(normalized);
          })
          .toList(growable: false);
    });

List<OrderRecord> _pending(List<OrderRecord> orders) {
  final pending = orders
      .where((OrderRecord order) => order.pendingAmount > 0)
      .toList(growable: false);
  pending.sort(
    (OrderRecord a, OrderRecord b) => a.orderDate.compareTo(b.orderDate),
  );
  return pending;
}
