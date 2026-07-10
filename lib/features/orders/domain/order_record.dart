import 'package:equatable/equatable.dart';

class OrderRecord extends Equatable {
  const OrderRecord({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.orderTime,
    required this.customerId,
    required this.customerName,
    required this.locationId,
    required this.locationName,
    required this.waterPointId,
    required this.waterPointName,
    required this.vehicleId,
    required this.vehicleName,
    required this.driverId,
    required this.driverName,
    required this.loadCount,
    required this.amount,
    required this.paidAmount,
    required this.paymentStatus,
    required this.deliveryStatus,
    required this.createdAt,
    required this.updatedAt,
    this.customerPhone,
    this.remarks,
  });

  final String id;
  final String orderNumber;
  final DateTime orderDate;
  final String orderTime;
  final String customerId;
  final String customerName;
  final String? customerPhone;
  final String locationId;
  final String locationName;
  final String waterPointId;
  final String waterPointName;
  final String vehicleId;
  final String vehicleName;
  final String driverId;
  final String driverName;
  final int loadCount;
  final num amount;
  final num paidAmount;
  final String paymentStatus;
  final String deliveryStatus;
  final String? remarks;
  final DateTime createdAt;
  final DateTime updatedAt;

  num get pendingAmount => amount - paidAmount;

  @override
  List<Object?> get props => <Object?>[
    id,
    orderNumber,
    orderDate,
    orderTime,
    customerId,
    customerName,
    customerPhone,
    locationId,
    locationName,
    waterPointId,
    waterPointName,
    vehicleId,
    vehicleName,
    driverId,
    driverName,
    loadCount,
    amount,
    paidAmount,
    paymentStatus,
    deliveryStatus,
    remarks,
    createdAt,
    updatedAt,
  ];
}
