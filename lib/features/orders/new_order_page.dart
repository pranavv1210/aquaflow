import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/helpers/app_formatters.dart';
import '../../core/models/customer.dart';
import '../../core/models/domain_enums.dart';
import '../../core/models/driver.dart';
import '../../core/models/location.dart';
import '../../core/models/vehicle.dart';
import '../../core/models/water_point.dart';
import '../../core/router/app_routes.dart';
import '../../core/services/connectivity_providers.dart';
import '../../core/shared/masters/master_dialogs.dart';
import '../../core/shared/widgets/app_buttons.dart';
import '../../core/shared/widgets/app_date_picker.dart';
import '../../core/shared/widgets/app_dropdown.dart';
import '../../core/shared/widgets/app_screen.dart';
import '../../core/shared/widgets/app_text_field.dart';
import '../../core/shared/widgets/error_state_widget.dart';
import '../../core/shared/widgets/form_section.dart';
import '../../core/shared/widgets/page_header.dart';
import '../../core/shared/widgets/skeleton_loader.dart';
import '../customers/application/customer_providers.dart';
import '../drivers/application/driver_providers.dart';
import '../locations/application/location_providers.dart';
import '../vehicles/application/vehicle_providers.dart';
import '../water_points/application/water_point_providers.dart';
import 'application/order_providers.dart';
import 'domain/order_input.dart';
import 'domain/order_record.dart';

class NewOrderPage extends ConsumerStatefulWidget {
  const NewOrderPage({super.key, this.orderId});

  final String? orderId;

  @override
  ConsumerState<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends ConsumerState<NewOrderPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _loadCountController = TextEditingController(
    text: '1',
  );
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _paidAmountController = TextEditingController(
    text: '0',
  );
  final TextEditingController _remarksController = TextEditingController();

  DateTime _orderDate = DateTime.now();
  DateTime _orderTime = DateTime.now();
  Customer? _selectedCustomer;
  Location? _selectedLocation;
  WaterPoint? _selectedWaterPoint;
  Vehicle? _selectedVehicle;
  Driver? _selectedDriver;
  String _paymentStatus = 'unpaid';
  String _deliveryStatus = 'order_received';
  bool _isSaving = false;
  bool _didPopulate = false;

  bool get _isEditing => widget.orderId != null;

  @override
  void dispose() {
    _loadCountController.dispose();
    _amountController.dispose();
    _paidAmountController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customerListProvider);
    final locations = ref.watch(locationListProvider);
    final waterPoints = ref.watch(waterPointListProvider);
    final vehicles = ref.watch(vehicleListProvider);
    final drivers = ref.watch(driverListProvider);
    final isOnline = ref.watch(isOnlineProvider);
    final editingOrder =
        _isEditing ? ref.watch(selectedOrderProvider(widget.orderId!)) : null;

    final loading =
        customers.isLoading ||
        locations.isLoading ||
        waterPoints.isLoading ||
        vehicles.isLoading ||
        drivers.isLoading ||
        (editingOrder?.isLoading ?? false);
    final error =
        customers.error ??
        locations.error ??
        waterPoints.error ??
        vehicles.error ??
        drivers.error ??
        editingOrder?.error;

    if (loading) {
      return AppScreen(
        children: <Widget>[
          PageHeader(
            title: _isEditing ? 'Edit Order' : 'New Order',
            subtitle: 'Loading...',
          ),
          const SkeletonLoader(height: 180),
          const SkeletonLoader(height: 220),
          const SkeletonLoader(height: 180),
        ],
      );
    }

    if (error != null) {
      return AppScreen(
        children: <Widget>[
          PageHeader(
            title: _isEditing ? 'Edit Order' : 'New Order',
            subtitle: 'Error',
          ),
          ErrorStateWidget(
            title: 'Unable to load order form',
            message: error.toString(),
            onRetry: _invalidateFormProviders,
          ),
        ],
      );
    }

    final customerItems = customers.value ?? const <Customer>[];
    final locationItems = locations.value ?? const <Location>[];
    final waterPointItems = waterPoints.value ?? const <WaterPoint>[];
    final vehicleItems = (vehicles.value ?? const <Vehicle>[])
        .where((Vehicle vehicle) => vehicle.status != VehicleStatus.inactive)
        .toList(growable: false);
    final driverItems = (drivers.value ?? const <Driver>[])
        .where((Driver driver) => driver.status != DriverStatus.inactive)
        .toList(growable: false);

    if (editingOrder?.hasValue ?? false) {
      _populateOnce(
        editingOrder!.value!,
        customers: customerItems,
        locations: locationItems,
        waterPoints: waterPointItems,
        vehicles: vehicleItems,
        drivers: driverItems,
      );
    }

    final filteredWaterPoints =
        _selectedLocation == null
            ? waterPointItems
            : waterPointItems
                .where(
                  (WaterPoint point) =>
                      point.locationId == null ||
                      point.locationId == _selectedLocation!.id,
                )
                .toList(growable: false);

    return Form(
      key: _formKey,
      child: AppScreen(
        children: <Widget>[
          PageHeader(
            title: _isEditing ? 'Edit Order' : 'New Order',
            subtitle: _isEditing ? 'Update tanker delivery' : 'Create order',
          ),
          FormSection(
            title: 'Customer',
            children: <Widget>[
              _SearchableField<Customer>(
                label: 'Customer',
                value: _selectedCustomer,
                items: customerItems,
                itemLabel: (Customer item) => item.displayName,
                onChanged: (Customer? customer) {
                  setState(() {
                    _selectedCustomer = customer;
                    _selectedWaterPoint = null;
                    _selectedLocation = _findLocation(
                      locationItems,
                      customer?.defaultLocationId,
                    );
                  });
                },
                validator:
                    (_) =>
                        _selectedCustomer == null
                            ? 'Customer is required'
                            : null,
              ),
              _SearchableField<Location>(
                label: 'Location',
                value: _selectedLocation,
                items: locationItems,
                itemLabel: (Location item) => item.locationName,
                onChanged: (Location? location) {
                  setState(() {
                    _selectedLocation = location;
                    _selectedWaterPoint = null;
                  });
                },
                validator:
                    (_) =>
                        _selectedLocation == null
                            ? 'Location is required'
                            : null,
              ),
              _SearchableField<WaterPoint>(
                label: 'Water Point',
                value: _selectedWaterPoint,
                items: filteredWaterPoints,
                itemLabel: (WaterPoint item) => item.waterPointName,
                onChanged:
                    (WaterPoint? waterPoint) =>
                        setState(() => _selectedWaterPoint = waterPoint),
                validator:
                    (_) =>
                        _selectedWaterPoint == null
                            ? 'Water point is required'
                            : null,
              ),
            ],
          ),
          FormSection(
            title: 'Delivery',
            children: <Widget>[
              AppDatePicker(
                label: 'Order Date',
                selectedDate: _orderDate,
                onChanged: (DateTime value) {
                  setState(() => _orderDate = value);
                },
              ),
              AppTextField(
                label: 'Order Time',
                readOnly: true,
                prefixIcon: Icons.schedule_rounded,
                controller: TextEditingController(
                  text: AppFormatters.time(_orderTime),
                ),
                onTap: _pickTime,
              ),
              _SearchableField<Vehicle>(
                label: 'Vehicle',
                value: _selectedVehicle,
                items: vehicleItems,
                itemLabel:
                    (Vehicle item) =>
                        '${item.vehicleName} (${item.registrationNumber})',
                onChanged:
                    (Vehicle? vehicle) =>
                        setState(() => _selectedVehicle = vehicle),
                validator:
                    (_) =>
                        _selectedVehicle == null ? 'Vehicle is required' : null,
              ),
              _SearchableField<Driver>(
                label: 'Driver',
                value: _selectedDriver,
                items: driverItems,
                itemLabel: (Driver item) => item.driverName,
                onChanged:
                    (Driver? driver) =>
                        setState(() => _selectedDriver = driver),
                validator:
                    (_) =>
                        _selectedDriver == null ? 'Driver is required' : null,
              ),
            ],
          ),
          FormSection(
            title: 'Billing',
            children: <Widget>[
              AppTextField(
                label: 'Load Count',
                controller: _loadCountController,
                keyboardType: TextInputType.number,
                validator: _validateLoadCount,
              ),
              AppTextField(
                label: 'Amount',
                controller: _amountController,
                prefixIcon: Icons.currency_rupee_rounded,
                keyboardType: TextInputType.number,
                validator: _validateAmount,
              ),
              AppTextField(
                label: 'Paid Amount',
                controller: _paidAmountController,
                prefixIcon: Icons.currency_rupee_rounded,
                keyboardType: TextInputType.number,
                validator: _validatePaidAmount,
              ),
              AppDropdown<String>(
                label: 'Payment Status',
                value: _paymentStatus,
                items: const <String>['unpaid', 'partial', 'paid'],
                itemLabel: _statusLabel,
                onChanged:
                    (String? value) =>
                        setState(() => _paymentStatus = value ?? 'unpaid'),
              ),
              AppDropdown<String>(
                label: 'Delivery Status',
                value: _deliveryStatus,
                items: const <String>[
                  'order_received',
                  'assigned',
                  'on_the_way',
                  'delivered',
                ],
                itemLabel: _statusLabel,
                onChanged:
                    (String? value) => setState(
                      () => _deliveryStatus = value ?? 'order_received',
                    ),
              ),
              AppTextField(
                label: 'Remarks',
                controller: _remarksController,
                maxLines: 3,
              ),
            ],
          ),
          PrimaryButton(
            label:
                isOnline
                    ? _isEditing
                        ? 'Update Order'
                        : 'Save Order'
                    : 'Offline',
            icon: Icons.check_rounded,
            isLoading: _isSaving,
            onPressed: isOnline ? _save : null,
          ),
          SecondaryButton(
            label: 'Cancel',
            icon: Icons.close_rounded,
            onPressed: _isSaving ? null : _cancel,
          ),
        ],
      ),
    );
  }

  void _populateOnce(
    OrderRecord order, {
    required List<Customer> customers,
    required List<Location> locations,
    required List<WaterPoint> waterPoints,
    required List<Vehicle> vehicles,
    required List<Driver> drivers,
  }) {
    if (_didPopulate) {
      return;
    }
    _orderDate = order.orderDate;
    _orderTime = _parseOrderTime(order.orderTime);
    _selectedCustomer = _findById(
      customers,
      order.customerId,
      (Customer item) => item.id,
    );
    _selectedLocation = _findById(
      locations,
      order.locationId,
      (Location item) => item.id,
    );
    _selectedWaterPoint = _findById(
      waterPoints,
      order.waterPointId,
      (WaterPoint item) => item.id,
    );
    _selectedVehicle = _findById(
      vehicles,
      order.vehicleId,
      (Vehicle item) => item.id,
    );
    _selectedDriver = _findById(
      drivers,
      order.driverId,
      (Driver item) => item.id,
    );
    _loadCountController.text = order.loadCount.toString();
    _amountController.text = order.amount.toString();
    _paidAmountController.text = order.paidAmount.toString();
    _paymentStatus = order.paymentStatus;
    _deliveryStatus = order.deliveryStatus;
    _remarksController.text = order.remarks ?? '';
    _didPopulate = true;
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_orderTime),
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _orderTime = DateTime(
        _orderDate.year,
        _orderDate.month,
        _orderDate.day,
        picked.hour,
        picked.minute,
      );
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _isSaving = true);
    final amount = num.parse(_amountController.text.trim());
    final paidAmount = num.parse(_paidAmountController.text.trim());
    final input = OrderInput(
      orderDate: _orderDate,
      orderTime: _orderTime,
      customerId: _selectedCustomer!.id,
      locationId: _selectedLocation!.id,
      waterPointId: _selectedWaterPoint!.id,
      vehicleId: _selectedVehicle!.id,
      driverId: _selectedDriver!.id,
      loadCount: int.parse(_loadCountController.text.trim()),
      amount: amount,
      paidAmount: paidAmount,
      paymentStatus: _paymentStatusFor(amount: amount, paidAmount: paidAmount),
      deliveryStatus: _deliveryStatus,
      remarks: _remarksController.text,
    );

    await saveOrder(
      ref,
      orderId: widget.orderId,
      input: input,
      onSuccess: (OrderRecord order) {
        if (!mounted) {
          return;
        }
        MasterDialogs.showSaved(
          context,
          _isEditing ? 'Order updated' : 'Order added',
        );
        context.go(AppRoutes.orderDetailsPath(order.id));
      },
      onFailure: (String message) {
        if (mounted) {
          MasterDialogs.showError(context, message);
        }
      },
    );
    if (mounted) {
      setState(() => _isSaving = false);
    }
  }

  void _cancel() {
    if (_isEditing) {
      context.go(AppRoutes.orderDetailsPath(widget.orderId!));
      return;
    }
    context.go(AppRoutes.orders);
  }

  void _invalidateFormProviders() {
    ref.invalidate(customerListProvider);
    ref.invalidate(locationListProvider);
    ref.invalidate(waterPointListProvider);
    ref.invalidate(vehicleListProvider);
    ref.invalidate(driverListProvider);
    if (_isEditing) {
      ref.invalidate(selectedOrderProvider(widget.orderId!));
    }
  }

  Location? _findLocation(List<Location> locations, String? id) {
    if (id == null || id.isEmpty) {
      return null;
    }
    return _findById(locations, id, (Location item) => item.id);
  }

  T? _findById<T>(List<T> items, String id, String Function(T item) idOf) {
    for (final item in items) {
      if (idOf(item) == id) {
        return item;
      }
    }
    return null;
  }

  DateTime _parseOrderTime(String value) {
    final parts = value.split(':');
    final hour = int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? 0;
    final minute = int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0;
    return DateTime(
      _orderDate.year,
      _orderDate.month,
      _orderDate.day,
      hour,
      minute,
    );
  }

  String? _validateLoadCount(String? value) {
    final parsed = int.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed < 0) {
      return 'Load count must be 0 or greater';
    }
    return null;
  }

  String? _validateAmount(String? value) {
    final parsed = num.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed <= 0) {
      return 'Amount must be greater than 0';
    }
    return null;
  }

  String? _validatePaidAmount(String? value) {
    final parsed = num.tryParse(value?.trim() ?? '');
    final amount = num.tryParse(_amountController.text.trim()) ?? 0;
    if (parsed == null || parsed < 0) {
      return 'Paid amount cannot be negative';
    }
    if (parsed > amount) {
      return 'Paid amount cannot exceed amount';
    }
    return null;
  }

  String _statusLabel(String value) {
    return value
        .split('_')
        .where((String part) => part.isNotEmpty)
        .map((String part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  String _paymentStatusFor({required num amount, required num paidAmount}) {
    if (paidAmount >= amount) {
      return 'paid';
    }
    if (paidAmount > 0) {
      return 'partial';
    }
    return _paymentStatus;
  }
}

class _SearchableField<T> extends StatelessWidget {
  const _SearchableField({
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.validator,
  });

  final String label;
  final T? value;
  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T?> onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      readOnly: true,
      prefixIcon: Icons.search_rounded,
      controller: TextEditingController(
        text: value == null ? '' : itemLabel(value as T),
      ),
      validator: validator,
      onTap: () async {
        final selected = await showSearch<T?>(
          context: context,
          delegate: _PickerSearchDelegate<T>(
            title: label,
            items: items,
            itemLabel: itemLabel,
          ),
        );
        if (selected != null) {
          onChanged(selected);
        }
      },
    );
  }
}

class _PickerSearchDelegate<T> extends SearchDelegate<T?> {
  _PickerSearchDelegate({
    required this.title,
    required this.items,
    required this.itemLabel,
  });

  final String title;
  final List<T> items;
  final String Function(T item) itemLabel;

  @override
  String get searchFieldLabel => 'Search $title';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.close_rounded),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildItems(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildItems(context);
  }

  Widget _buildItems(BuildContext context) {
    final normalized = query.trim().toLowerCase();
    final filtered =
        normalized.isEmpty
            ? items
            : items
                .where(
                  (T item) =>
                      itemLabel(item).toLowerCase().contains(normalized),
                )
                .toList(growable: false);

    if (filtered.isEmpty) {
      return const Center(child: Text('No Data'));
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (BuildContext context, int index) {
        final item = filtered[index];
        return ListTile(
          title: Text(itemLabel(item)),
          onTap: () => close(context, item),
        );
      },
    );
  }
}
