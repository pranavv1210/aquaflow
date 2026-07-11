import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/helpers/app_formatters.dart';
import '../../core/router/app_routes.dart';
import '../../core/services/snackbar_service.dart';
import '../../core/shared/widgets/app_screen.dart';
import '../../core/shared/widgets/aqua_filter_chip.dart';
import '../../core/shared/widgets/aquaflow_fab.dart';
import '../../core/shared/widgets/empty_state_widget.dart';
import '../../core/shared/widgets/error_state_widget.dart';
import '../../core/shared/widgets/order_card.dart';
import '../../core/shared/widgets/page_header.dart';
import '../../core/shared/widgets/search_field.dart';
import '../../core/shared/widgets/skeleton_loader.dart';
import '../../core/shared/widgets/timed_loading_view.dart';
import '../../core/theme/app_spacing.dart';
import '../analytics/application/analytics_providers.dart';
import 'application/order_providers.dart';
import 'domain/order_input.dart';
import 'domain/order_record.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  int _selectedFilter = 0;

  static const List<String> _filters = <String>[
    'All',
    'Unpaid',
    'Delivered',
    'Paid',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(orderRealtimeProvider, (
      _,
      AsyncValue<List<Map<String, dynamic>>> next,
    ) {
      if (next.hasValue) {
        _invalidateCurrentList();
      }
    });

    final orders =
        _query.trim().isEmpty
            ? ref.watch(orderListProvider)
            : ref.watch(orderSearchProvider(_query));

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: AquaFlowFab(
        tooltip: 'New order',
        onPressed: () => context.go(AppRoutes.newOrder),
      ),
      body: orders.when(
        loading: _buildLoading,
        error:
            (Object error, StackTrace stackTrace) => AppScreen(
              onRefresh: _refresh,
              children: <Widget>[
                _buildHeader(context),
                _buildSearch(),
                ErrorStateWidget(
                  title: 'Unable to load orders',
                  message: error.toString(),
                  onRetry: _invalidateCurrentList,
                ),
              ],
            ),
        data: (List<OrderRecord> items) {
          final filtered = _applyFilter(items);
          return AppScreen(
            onRefresh: _refresh,
            children: <Widget>[
              _buildHeader(context),
              _buildSearch(),
              _buildFilters(),
              if (filtered.isEmpty)
                EmptyStateWidget(
                  title:
                      _query.trim().isEmpty
                          ? 'No Orders Yet'
                          : 'No Orders Found',
                  message:
                      _query.trim().isEmpty
                          ? 'Create the first tanker delivery order.'
                          : 'Try a different customer, phone, or location.',
                  icon: Icons.receipt_long_outlined,
                )
              else
                ...filtered.map(_buildOrderCard),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return const PageHeader(
      title: 'Orders',
      subtitle: 'Search and manage tanker deliveries',
    );
  }

  Widget _buildSearch() {
    return SearchField(
      label: 'Search orders',
      controller: _searchController,
      onChanged: (String value) {
        setState(() => _query = value);
      },
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return AquaFilterChip(
            label: _filters[index],
            selected: index == _selectedFilter,
            onSelected: (_) => setState(() => _selectedFilter = index),
          );
        },
        separatorBuilder:
            (BuildContext context, int index) =>
                const SizedBox(width: AppSpacing.xs),
        itemCount: _filters.length,
      ),
    );
  }

  Widget _buildLoading() {
    return AppScreen(
      children: <Widget>[
        const PageHeader(title: 'Orders', subtitle: 'Loading...'),
        const SearchField(label: 'Search orders'),
        const AquaFilterChipBar(
          labels: <String>['All', 'Unpaid', 'Delivered', 'Paid'],
        ),
        TimedLoadingView(
          onRetry: _invalidateCurrentList,
          loading: const Column(
            children: <Widget>[
              SkeletonLoader(height: 156),
              SizedBox(height: AppSpacing.md),
              SkeletonLoader(height: 156),
              SizedBox(height: AppSpacing.md),
              SkeletonLoader(height: 156),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(OrderRecord order) {
    return OrderCard(
      orderNumber: order.orderNumber,
      customerName: order.customerName,
      locationName: order.locationName,
      vehicleName: order.vehicleName,
      driverName: order.driverName,
      amount: AppFormatters.currency(order.amount),
      paidAmount: AppFormatters.currency(order.paidAmount),
      pendingAmount: AppFormatters.currency(order.pendingAmount),
      loadCount: order.loadCount.toString(),
      paymentStatus: _statusLabel(order.paymentStatus),
      deliveryStatus: _statusLabel(order.deliveryStatus),
      date: AppFormatters.date(order.orderDate),
      onTogglePayment: () => _togglePayment(order),
      onToggleDelivery: () => _toggleDelivery(order),
      onTap: () => context.go(AppRoutes.orderDetailsPath(order.id)),
    );
  }

  List<OrderRecord> _applyFilter(List<OrderRecord> orders) {
    return switch (_selectedFilter) {
      1 => orders
          .where((OrderRecord order) => order.paymentStatus == 'unpaid')
          .toList(growable: false),
      2 => orders
          .where((OrderRecord order) => order.deliveryStatus == 'delivered')
          .toList(growable: false),
      3 => orders
          .where((OrderRecord order) => order.paymentStatus == 'paid')
          .toList(growable: false),
      _ => orders,
    };
  }

  Future<void> _refresh() async {
    _invalidateCurrentList();
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }

  void _invalidateCurrentList() {
    if (_query.trim().isEmpty) {
      ref.invalidate(orderListProvider);
    } else {
      ref.invalidate(orderSearchProvider(_query));
    }
  }

  Future<void> _togglePayment(OrderRecord order) async {
    final paid = order.paymentStatus == 'paid';
    await _saveQuickStatus(
      order,
      paidAmount: paid ? 0 : order.amount,
      paymentStatus: paid ? 'unpaid' : 'paid',
      successMessage: paid ? 'Order marked unpaid' : 'Order marked paid',
    );
  }

  Future<void> _toggleDelivery(OrderRecord order) async {
    final delivered = order.deliveryStatus == 'delivered';
    await _saveQuickStatus(
      order,
      deliveryStatus: delivered ? 'order_received' : 'delivered',
      successMessage:
          delivered ? 'Delivery reopened' : 'Delivery marked delivered',
    );
  }

  Future<void> _saveQuickStatus(
    OrderRecord order, {
    num? paidAmount,
    String? paymentStatus,
    String? deliveryStatus,
    required String successMessage,
  }) async {
    await saveOrder(
      ref,
      orderId: order.id,
      input: _inputFromRecord(
        order,
        paidAmount: paidAmount,
        paymentStatus: paymentStatus,
        deliveryStatus: deliveryStatus,
      ),
      onSuccess: (_) {
        _invalidateCurrentList();
        invalidateBusinessMetrics(ref);
        SnackbarService.success(successMessage);
      },
      onFailure: SnackbarService.error,
    );
  }

  OrderInput _inputFromRecord(
    OrderRecord order, {
    num? paidAmount,
    String? paymentStatus,
    String? deliveryStatus,
  }) {
    return OrderInput(
      orderDate: order.orderDate,
      orderTime: _orderTime(order),
      customerId: order.customerId,
      locationId: order.locationId,
      waterPointId: order.waterPointId,
      vehicleId: order.vehicleId,
      driverId: order.driverId,
      loadCount: order.loadCount,
      amount: order.amount,
      paidAmount: paidAmount ?? order.paidAmount,
      paymentStatus: paymentStatus ?? order.paymentStatus,
      deliveryStatus: deliveryStatus ?? order.deliveryStatus,
      remarks: order.remarks,
    );
  }

  DateTime _orderTime(OrderRecord order) {
    final parts = order.orderTime.split(':');
    final hour = int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? 0;
    final minute = int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0;
    return DateTime(
      order.orderDate.year,
      order.orderDate.month,
      order.orderDate.day,
      hour,
      minute,
    );
  }

  String _statusLabel(String value) {
    return value
        .split('_')
        .where((String part) => part.isNotEmpty)
        .map((String part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }
}
