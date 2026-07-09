import 'domain_enums.dart';
import 'value_objects.dart';

class Order {
  const Order({
    required this.id,
    required this.date,
    required this.time,
    required this.customerId,
    required this.locationId,
    required this.waterPointId,
    required this.loadCount,
    required this.amount,
    required this.paymentStatus,
    required this.deliveryStatus,
    required this.createdAt,
    required this.updatedAt,
    this.vehicleId,
    this.driverId,
    this.partnerId,
    this.remarks,
  });

  final String id;
  final BusinessDate date;
  final BusinessTime time;
  final String customerId;
  final String locationId;
  final String waterPointId;
  final String? vehicleId;
  final String? driverId;
  final String? partnerId;
  final int loadCount;
  final Money amount;
  final PaymentStatus paymentStatus;
  final DeliveryStatus deliveryStatus;
  final String? remarks;
  final DateTime createdAt;
  final DateTime updatedAt;
}
