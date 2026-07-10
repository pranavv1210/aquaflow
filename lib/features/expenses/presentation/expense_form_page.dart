import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/navigation_providers.dart';
import '../../../core/models/driver.dart';
import '../../../core/models/expense_category.dart';
import '../../../core/models/vehicle.dart';
import '../../../core/shared/masters/master_dialogs.dart';
import '../../../core/shared/widgets/app_buttons.dart';
import '../../../core/shared/widgets/app_date_picker.dart';
import '../../../core/shared/widgets/app_dropdown.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/app_text_field.dart';
import '../../../core/shared/widgets/error_state_widget.dart';
import '../../../core/shared/widgets/form_section.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/skeleton_loader.dart';
import '../../../core/theme/app_spacing.dart';
import '../../drivers/application/driver_providers.dart';
import '../../expense_categories/application/expense_category_providers.dart';
import '../../vehicles/application/vehicle_providers.dart';
import '../application/expense_providers.dart';
import '../domain/expense_input.dart';
import '../domain/expense_record.dart';

class ExpenseFormPage extends ConsumerStatefulWidget {
  const ExpenseFormPage({super.key, this.expenseId});

  final String? expenseId;

  @override
  ConsumerState<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends ConsumerState<ExpenseFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  DateTime _expenseDate = DateTime.now();
  ExpenseCategory? _selectedCategory;
  Vehicle? _selectedVehicle;
  Driver? _selectedDriver;
  bool _isSaving = false;
  bool _didPopulate = false;

  bool get _isEditing => widget.expenseId != null;

  @override
  void dispose() {
    _amountController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(expenseCategoryListProvider);
    final vehicles = ref.watch(vehicleListProvider);
    final drivers = ref.watch(driverListProvider);
    final editingExpense =
        _isEditing
            ? ref.watch(selectedExpenseProvider(widget.expenseId!))
            : null;

    final loading =
        categories.isLoading ||
        vehicles.isLoading ||
        drivers.isLoading ||
        (editingExpense?.isLoading ?? false);
    final error =
        categories.error ??
        vehicles.error ??
        drivers.error ??
        editingExpense?.error;

    if (loading) {
      return AppScreen(
        children: <Widget>[
          PageHeader(
            title: _isEditing ? 'Edit Expense' : 'Add Expense',
            subtitle: 'Loading...',
          ),
          const SkeletonLoader(height: 180),
          const SkeletonLoader(height: 180),
        ],
      );
    }

    if (error != null) {
      return AppScreen(
        children: <Widget>[
          PageHeader(
            title: _isEditing ? 'Edit Expense' : 'Add Expense',
            subtitle: 'Error',
          ),
          ErrorStateWidget(
            title: 'Unable to load expense form',
            message: error.toString(),
            onRetry: _invalidateFormProviders,
          ),
        ],
      );
    }

    final categoryItems = categories.value ?? const <ExpenseCategory>[];
    final vehicleItems = vehicles.value ?? const <Vehicle>[];
    final driverItems = drivers.value ?? const <Driver>[];

    if (editingExpense?.hasValue ?? false) {
      _populateOnce(
        editingExpense!.value!,
        categories: categoryItems,
        vehicles: vehicleItems,
        drivers: driverItems,
      );
    }

    return Form(
      key: _formKey,
      child: AppScreen(
        children: <Widget>[
          PageHeader(
            title: _isEditing ? 'Edit Expense' : 'Add Expense',
            subtitle: _isEditing ? 'Update expense details' : 'Create expense',
          ),
          FormSection(
            title: 'Expense',
            children: <Widget>[
              AppDatePicker(
                label: 'Expense Date',
                selectedDate: _expenseDate,
                onChanged:
                    (DateTime value) => setState(() => _expenseDate = value),
              ),
              AppDropdown<ExpenseCategory>(
                label: 'Expense Category',
                value: _selectedCategory,
                items: categoryItems,
                itemLabel: (ExpenseCategory item) => item.categoryName,
                onChanged:
                    (ExpenseCategory? value) =>
                        setState(() => _selectedCategory = value),
              ),
              AppTextField(
                label: 'Amount',
                controller: _amountController,
                prefixIcon: Icons.currency_rupee_rounded,
                keyboardType: TextInputType.number,
                validator: _validateAmount,
              ),
              AppTextField(
                label: 'Remarks',
                controller: _remarksController,
                maxLines: 3,
              ),
            ],
          ),
          FormSection(
            title: 'Optional Links',
            children: <Widget>[
              _OptionalDropdown<Vehicle>(
                label: 'Vehicle',
                value: _selectedVehicle,
                items: vehicleItems,
                itemLabel:
                    (Vehicle item) =>
                        '${item.vehicleName} (${item.registrationNumber})',
                onChanged:
                    (Vehicle? value) =>
                        setState(() => _selectedVehicle = value),
              ),
              _OptionalDropdown<Driver>(
                label: 'Driver',
                value: _selectedDriver,
                items: driverItems,
                itemLabel: (Driver item) => item.driverName,
                onChanged:
                    (Driver? value) => setState(() => _selectedDriver = value),
              ),
            ],
          ),
          PrimaryButton(
            label: _isEditing ? 'Update Expense' : 'Save Expense',
            icon: Icons.check_rounded,
            isLoading: _isSaving,
            onPressed: _save,
          ),
          SecondaryButton(
            label: 'Cancel',
            icon: Icons.close_rounded,
            onPressed: _isSaving ? null : _leaveForm,
          ),
        ],
      ),
    );
  }

  void _populateOnce(
    ExpenseRecord expense, {
    required List<ExpenseCategory> categories,
    required List<Vehicle> vehicles,
    required List<Driver> drivers,
  }) {
    if (_didPopulate) {
      return;
    }
    _expenseDate = expense.expenseDate;
    _selectedCategory = _findById(
      categories,
      expense.expenseCategoryId,
      (ExpenseCategory item) => item.id,
    );
    if (expense.vehicleId != null) {
      _selectedVehicle = _findById(
        vehicles,
        expense.vehicleId!,
        (Vehicle item) => item.id,
      );
    }
    if (expense.driverId != null) {
      _selectedDriver = _findById(
        drivers,
        expense.driverId!,
        (Driver item) => item.id,
      );
    }
    _amountController.text = expense.amount.toString();
    _remarksController.text = expense.remarks ?? '';
    _didPopulate = true;
  }

  Future<void> _save() async {
    if (_selectedCategory == null) {
      MasterDialogs.showError(context, 'Expense category is required.');
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _isSaving = true);
    final input = ExpenseInput(
      expenseDate: _expenseDate,
      expenseCategoryId: _selectedCategory!.id,
      amount: num.parse(_amountController.text.trim()),
      vehicleId: _selectedVehicle?.id,
      driverId: _selectedDriver?.id,
      remarks: _remarksController.text,
    );
    await saveExpenseProviders(
      ref,
      expenseId: widget.expenseId,
      input: input,
      onSuccess: (ExpenseRecord saved) {
        if (!mounted) {
          return;
        }
        MasterDialogs.showSaved(
          context,
          _isEditing ? 'Expense updated' : 'Expense added',
        );
        ref
            .read(navigationServiceProvider)
            .goToExpenseDetails(context, saved.id);
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

  String? _validateAmount(String? value) {
    final parsed = num.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed <= 0) {
      return 'Amount must be greater than 0';
    }
    return null;
  }

  T? _findById<T>(List<T> items, String id, String Function(T item) idOf) {
    for (final item in items) {
      if (idOf(item) == id) {
        return item;
      }
    }
    return null;
  }

  void _invalidateFormProviders() {
    ref.invalidate(expenseCategoryListProvider);
    ref.invalidate(vehicleListProvider);
    ref.invalidate(driverListProvider);
    if (_isEditing) {
      ref.invalidate(selectedExpenseProvider(widget.expenseId!));
    }
  }

  void _leaveForm() {
    final navigation = ref.read(navigationServiceProvider);
    if (_isEditing) {
      navigation.goToExpenseDetails(context, widget.expenseId!);
      return;
    }
    navigation.goToExpenses(context);
  }
}

class _OptionalDropdown<T> extends StatelessWidget {
  const _OptionalDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  final String label;
  final T? value;
  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: AppDropdown<T>(
            label: label,
            value: value,
            items: items,
            itemLabel: itemLabel,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        IconButton.filledTonal(
          tooltip: 'Clear $label',
          onPressed: value == null ? null : () => onChanged(null),
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }
}
