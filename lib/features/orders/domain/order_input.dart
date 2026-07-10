import 'package:equatable/equatable.dart';

class OrderInput extends Equatable {
  const OrderInput({
    required this.orderDate,
    required this.orderTime,
    required this.customerId,
    required this.locationId,
    required this.waterPointId,
    required this.vehicleId,
    required this.driverId,
    required this.loadCount,
    required this.amount,
    required this.paidAmount,
    required this.paymentStatus,
    required this.deliveryStatus,
    this.remarks,
  });

  final DateTime orderDate;
  final DateTime orderTime;
  final String customerId;
  final String locationId;
  final String waterPointId;
  final String vehicleId;
  final String driverId;
  final int loadCount;
  final num amount;
  final num paidAmount;
  final String paymentStatus;
  final String deliveryStatus;
  final String? remarks;

  OrderInput copyWith({
    DateTime? orderDate,
    DateTime? orderTime,
    String? customerId,
    String? locationId,
    String? waterPointId,
    String? vehicleId,
    String? driverId,
    int? loadCount,
    num? amount,
    num? paidAmount,
    String? paymentStatus,
    String? deliveryStatus,
    String? remarks,
  }) {
    return OrderInput(
      orderDate: orderDate ?? this.orderDate,
      orderTime: orderTime ?? this.orderTime,
      customerId: customerId ?? this.customerId,
      locationId: locationId ?? this.locationId,
      waterPointId: waterPointId ?? this.waterPointId,
      vehicleId: vehicleId ?? this.vehicleId,
      driverId: driverId ?? this.driverId,
      loadCount: loadCount ?? this.loadCount,
      amount: amount ?? this.amount,
      paidAmount: paidAmount ?? this.paidAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      remarks: remarks ?? this.remarks,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    orderDate,
    orderTime,
    customerId,
    locationId,
    waterPointId,
    vehicleId,
    driverId,
    loadCount,
    amount,
    paidAmount,
    paymentStatus,
    deliveryStatus,
    remarks,
  ];
}
