import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/helpers/app_formatters.dart';
import '../../../core/models/customer.dart';
import '../../../core/models/vehicle.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/shared/widgets/action_tile.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/aqua_filter_chip.dart';
import '../../../core/shared/widgets/empty_state_widget.dart';
import '../../../core/shared/widgets/error_state_widget.dart';
import '../../../core/shared/widgets/glass_card.dart';
import '../../../core/shared/widgets/order_card.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/search_field.dart';
import '../../../core/theme/app_spacing.dart';
import '../../customers/application/customer_providers.dart';
import '../../orders/application/order_providers.dart';
import '../../orders/domain/order_record.dart';
import '../../vehicles/application/vehicle_providers.dart';

class GlobalSearchPage extends ConsumerStatefulWidget {
  const GlobalSearchPage({super.key});

  @override
  ConsumerState<GlobalSearchPage> createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends ConsumerState<GlobalSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilter = 0;
  String _query = '';

  static const List<String> _filters = <String>[
    'All',
    'Orders',
    'Customers',
    'Vehicles',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trimmed = _query.trim();
    final orders =
        trimmed.isEmpty
            ? const AsyncValue<List<OrderRecord>>.data(<OrderRecord>[])
            : ref.watch(orderSearchProvider(trimmed));
    final customers =
        trimmed.isEmpty
            ? const AsyncValue<List<Customer>>.data(<Customer>[])
            : ref.watch(customerSearchProvider(trimmed));
    final vehicles =
        trimmed.isEmpty
            ? const AsyncValue<List<Vehicle>>.data(<Vehicle>[])
            : ref.watch(vehicleSearchProvider(trimmed));

    return AppScreen(
      children: <Widget>[
        const PageHeader(title: 'Global Search', subtitle: 'Search AquaFlow'),
        SearchField(
          label: 'Search orders, customers, vehicles',
          controller: _searchController,
          onChanged: (String value) {
            setState(() => _query = value);
          },
        ),
        AquaFilterChipBar(
          labels: _filters,
          selectedIndex: _selectedFilter,
          onSelected: (int index) => setState(() => _selectedFilter = index),
        ),
        if (trimmed.isEmpty)
          const EmptyStateWidget(
            title: 'Search Ready',
            message: 'Enter a customer, phone, order, vehicle, or location.',
            icon: Icons.search_rounded,
          )
        else
          _SearchResults(
            selectedFilter: _selectedFilter,
            orders: orders,
            customers: customers,
            vehicles: vehicles,
          ),
      ],
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.selectedFilter,
    required this.orders,
    required this.customers,
    required this.vehicles,
  });

  final int selectedFilter;
  final AsyncValue<List<OrderRecord>> orders;
  final AsyncValue<List<Customer>> customers;
  final AsyncValue<List<Vehicle>> vehicles;

  @override
  Widget build(BuildContext context) {
    final hasError =
        _shouldReadOrders && orders.hasError ||
        _shouldReadCustomers && customers.hasError ||
        _shouldReadVehicles && vehicles.hasError;
    if (hasError) {
      return const ErrorStateWidget(
        title: 'Search failed',
        message: 'Please check the data connection and try again.',
      );
    }
    final isLoading =
        _shouldReadOrders && orders.isLoading ||
        _shouldReadCustomers && customers.isLoading ||
        _shouldReadVehicles && vehicles.isLoading;
    if (isLoading) {
      return const GlassCard(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final results = <Object>[
      if (_shouldReadOrders) ..._ordersOrEmpty,
      if (_shouldReadCustomers) ..._customersOrEmpty,
      if (_shouldReadVehicles) ..._vehiclesOrEmpty,
    ];

    if (results.isEmpty) {
      return EmptyStateWidget(
        title: 'No ${_label(selectedFilter)} Results',
        message: 'No matching records were found.',
        icon: Icons.search_off_rounded,
      );
    }

    return Column(
      children: <Widget>[
        for (final item in results) ...<Widget>[
          _ResultItem(item: item),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }

  String _label(int index) {
    return switch (index) {
      1 => 'Order',
      2 => 'Customer',
      3 => 'Vehicle',
      _ => 'All',
    };
  }

  bool get _shouldReadOrders => selectedFilter == 0 || selectedFilter == 1;

  bool get _shouldReadCustomers => selectedFilter == 0 || selectedFilter == 2;

  bool get _shouldReadVehicles => selectedFilter == 0 || selectedFilter == 3;

  List<OrderRecord> get _ordersOrEmpty {
    return orders.maybeWhen(
      data: (List<OrderRecord> value) => value,
      orElse: () => const <OrderRecord>[],
    );
  }

  List<Customer> get _customersOrEmpty {
    return customers.maybeWhen(
      data: (List<Customer> value) => value,
      orElse: () => const <Customer>[],
    );
  }

  List<Vehicle> get _vehiclesOrEmpty {
    return vehicles.maybeWhen(
      data: (List<Vehicle> value) => value,
      orElse: () => const <Vehicle>[],
    );
  }
}

class _ResultItem extends StatelessWidget {
  const _ResultItem({required this.item});

  final Object item;

  @override
  Widget build(BuildContext context) {
    final value = item;
    if (value is OrderRecord) {
      return OrderCard(
        orderNumber: value.orderNumber,
        customerName: value.customerName,
        locationName: value.locationName,
        vehicleName: value.vehicleName,
        driverName: value.driverName,
        amount: AppFormatters.currency(value.amount),
        pendingAmount: AppFormatters.currency(value.pendingAmount),
        loadCount: value.loadCount.toString(),
        paymentStatus: _statusLabel(value.paymentStatus),
        deliveryStatus: _statusLabel(value.deliveryStatus),
        date: AppFormatters.date(value.orderDate),
        onTap: () => context.go(AppRoutes.orderDetailsPath(value.id)),
      );
    }
    if (value is Customer) {
      return GlassCard(
        child: ActionTile(
          title: value.displayName,
          subtitle: value.phoneNumber?.value ?? value.address ?? 'Customer',
          icon: Icons.person_outline_rounded,
          onTap: () => context.go(AppRoutes.customerProfilePath(value.id)),
        ),
      );
    }
    if (value is Vehicle) {
      return GlassCard(
        child: ActionTile(
          title: value.vehicleName,
          subtitle: value.registrationNumber,
          icon: Icons.local_shipping_outlined,
          onTap: () => context.go(AppRoutes.vehicleDetailsPath(value.id)),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  String _statusLabel(String value) {
    return value
        .split('_')
        .where((String part) => part.isNotEmpty)
        .map((String part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }
}
