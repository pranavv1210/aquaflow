import '../../../../core/errors/app_failure.dart';
import '../../../../core/repositories/supabase_repository.dart';
import '../../../../core/result/result.dart';
import '../../domain/order_input.dart';
import '../../domain/order_record.dart';
import '../../domain/repositories/order_repository.dart';

class SupabaseOrderRepository extends SupabaseRepository
    implements OrderRepository {
  SupabaseOrderRepository(super.client);

  static const String _table = 'orders';
  static const String _select = '''
    *,
    customers(id, display_name, phone),
    locations(id, name),
    water_points(id, name),
    vehicles(id, vehicle_name, registration_number),
    drivers(id, driver_name, phone)
  ''';

  @override
  Future<Result<List<OrderRecord>>> getOrders() {
    return guard<List<OrderRecord>>('Load orders', () async {
      final response = await client
          .from(_table)
          .select(_select)
          .eq('is_deleted', false)
          .order('order_date', ascending: false)
          .order('created_at', ascending: false);
      return _mapList(response);
    }, fallbackMessage: 'Unable to load orders.');
  }

  @override
  Future<Result<OrderRecord>> getOrderById(String id) {
    return guard<OrderRecord>('Load order', () async {
      final response =
          await client.from(_table).select(_select).eq('id', id).maybeSingle();
      if (response == null) {
        throw const DatabaseFailure(message: 'Order not found.');
      }
      return _mapRow(Map<String, dynamic>.from(response));
    }, fallbackMessage: 'Unable to load order.');
  }

  @override
  Future<Result<OrderRecord>> createOrder(OrderInput input) {
    return guard<OrderRecord>('Create order', () async {
      final response =
          await client
              .from(_table)
              .insert(_inputToJson(input))
              .select(_select)
              .single();
      return _mapRow(Map<String, dynamic>.from(response));
    }, fallbackMessage: 'Unable to save order.');
  }

  @override
  Future<Result<OrderRecord>> updateOrder(String id, OrderInput input) {
    return guard<OrderRecord>('Update order', () async {
      final response =
          await client
              .from(_table)
              .update(_inputToJson(input))
              .eq('id', id)
              .select(_select)
              .single();
      return _mapRow(Map<String, dynamic>.from(response));
    }, fallbackMessage: 'Unable to save order.');
  }

  @override
  Future<Result<void>> softDeleteOrder(String id) {
    return guard<void>('Delete order', () async {
      await client
          .from(_table)
          .update(<String, dynamic>{'is_deleted': true})
          .eq('id', id);
    }, fallbackMessage: 'Unable to delete order.');
  }

  @override
  Future<Result<List<OrderRecord>>> searchOrders(String query) async {
    final result = await getOrders();
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return result;
    }
    return result.when(
      success: (List<OrderRecord> orders) {
        return Success<List<OrderRecord>>(
          orders
              .where((OrderRecord order) {
                return order.customerName.toLowerCase().contains(normalized) ||
                    (order.customerPhone?.toLowerCase().contains(normalized) ??
                        false) ||
                    order.locationName.toLowerCase().contains(normalized);
              })
              .toList(growable: false),
        );
      },
      failure: Failure<List<OrderRecord>>.new,
    );
  }

  Map<String, dynamic> _inputToJson(OrderInput input) {
    return <String, dynamic>{
      'order_date': _dateToDb(input.orderDate),
      'order_time': _timeToDb(input.orderTime),
      'customer_id': input.customerId,
      'location_id': input.locationId,
      'water_point_id': input.waterPointId,
      'vehicle_id': input.vehicleId,
      'driver_id': input.driverId,
      'partner_tanker_id': null,
      'delivery_type': 'own_vehicle',
      'load_count': input.loadCount,
      'amount': input.amount,
      'paid_amount': input.paidAmount,
      'payment_status': input.paymentStatus,
      'delivery_status': input.deliveryStatus,
      'remarks': _blankToNull(input.remarks),
    };
  }

  List<OrderRecord> _mapList(dynamic response) {
    return (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(_mapRow)
        .toList(growable: false);
  }

  OrderRecord _mapRow(Map<String, dynamic> row) {
    final customer = _nested(row, 'customers');
    final location = _nested(row, 'locations');
    final waterPoint = _nested(row, 'water_points');
    final vehicle = _nested(row, 'vehicles');
    final driver = _nested(row, 'drivers');

    return OrderRecord(
      id: row['id'] as String,
      orderNumber: row['order_number'] as String? ?? '--',
      orderDate: DateTime.parse(row['order_date'] as String).toLocal(),
      orderTime: row['order_time'] as String? ?? '--',
      customerId: row['customer_id'] as String,
      customerName: customer['display_name'] as String? ?? '--',
      customerPhone: customer['phone'] as String?,
      locationId: row['location_id'] as String,
      locationName: location['name'] as String? ?? '--',
      waterPointId: row['water_point_id'] as String,
      waterPointName: waterPoint['name'] as String? ?? '--',
      vehicleId: row['vehicle_id'] as String? ?? '',
      vehicleName: vehicle['vehicle_name'] as String? ?? '--',
      driverId: row['driver_id'] as String? ?? '',
      driverName: driver['driver_name'] as String? ?? '--',
      loadCount: _intValue(row['load_count'], fallback: 1),
      amount: _numValue(row['amount']),
      paidAmount: _numValue(row['paid_amount']),
      paymentStatus: row['payment_status'] as String? ?? 'unpaid',
      deliveryStatus: row['delivery_status'] as String? ?? 'order_received',
      remarks: row['remarks'] as String?,
      createdAt: DateTime.parse(row['created_at'] as String).toLocal(),
      updatedAt: DateTime.parse(row['updated_at'] as String).toLocal(),
    );
  }

  Map<String, dynamic> _nested(Map<String, dynamic> row, String key) {
    final value = row[key];
    if (value is Map<String, dynamic>) {
      return value;
    }
    return const <String, dynamic>{};
  }

  int _intValue(dynamic value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  num _numValue(dynamic value) {
    if (value is num) {
      return value;
    }
    return num.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _dateToDb(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }

  String _timeToDb(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
