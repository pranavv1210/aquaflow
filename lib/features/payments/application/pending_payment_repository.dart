import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/repositories/base_repository.dart';
import '../../../core/result/result.dart';

class PendingPaymentRepository extends BaseRepository {
  PendingPaymentRepository(this._client);

  final SupabaseClient _client;

  Future<Result<void>> recordPayment({
    required String orderId,
    required num currentPaidAmount,
    required num totalAmount,
    required num receivedAmount,
  }) {
    return guard<void>('Record order payment', () async {
      final nextPaid = currentPaidAmount + receivedAmount;
      final cappedPaid = nextPaid > totalAmount ? totalAmount : nextPaid;
      final status =
          cappedPaid >= totalAmount
              ? 'paid'
              : cappedPaid > 0
              ? 'partial'
              : 'unpaid';
      await _client
          .from('orders')
          .update(<String, dynamic>{
            'paid_amount': cappedPaid,
            'payment_status': status,
          })
          .eq('id', orderId);
    }, fallbackMessage: 'Unable to update payment.');
  }
}
