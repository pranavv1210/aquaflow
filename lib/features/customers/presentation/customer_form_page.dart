import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/navigation_providers.dart';
import '../../../core/models/customer.dart';
import '../../../core/shared/masters/base_master_form.dart';
import '../../../core/shared/masters/master_dialogs.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/error_state_widget.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../application/customer_providers.dart';
import '../domain/customer_input.dart';
import 'widgets/customer_form_fields.dart';
import 'widgets/customer_list_skeleton.dart';

class CustomerFormPage extends ConsumerStatefulWidget {
  const CustomerFormPage({super.key, this.customerId});

  final String? customerId;

  @override
  ConsumerState<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends ConsumerState<CustomerFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isSaving = false;
  bool _didPopulate = false;

  bool get _isEditing => widget.customerId != null;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEditing) {
      return _buildForm();
    }

    final customer = ref.watch(selectedCustomerProvider(widget.customerId!));
    return customer.when(
      loading:
          () => const AppScreen(
            children: <Widget>[
              PageHeader(title: 'Edit Customer', subtitle: 'Loading...'),
              CustomerListSkeleton(),
            ],
          ),
      error: (Object error, StackTrace stackTrace) {
        return AppScreen(
          children: <Widget>[
            const PageHeader(title: 'Edit Customer', subtitle: 'Error'),
            ErrorStateWidget(
              title: 'Unable to load customer',
              message: error.toString(),
              onRetry:
                  () => ref.invalidate(
                    selectedCustomerProvider(widget.customerId!),
                  ),
            ),
          ],
        );
      },
      data: (Customer customer) {
        _populateOnce(customer);
        return _buildForm();
      },
    );
  }

  Widget _buildForm() {
    return BaseMasterForm(
      formKey: _formKey,
      title: _isEditing ? 'Edit Customer' : 'Add Customer',
      subtitle: _isEditing ? 'Update customer details' : 'Create customer',
      saveLabel: _isEditing ? 'Update Customer' : 'Save Customer',
      isSaving: _isSaving,
      onSave: _save,
      onCancel: _confirmCancel,
      children: <Widget>[
        CustomerFormFields(
          nameController: _nameController,
          phoneController: _phoneController,
          addressController: _addressController,
          locationController: _locationController,
          notesController: _notesController,
        ),
      ],
    );
  }

  Future<void> _confirmCancel() async {
    if (_hasChanges) {
      final discard = await MasterDialogs.confirmDiscard(context);
      if (!discard) {
        return;
      }
    }
    _leaveForm();
  }

  bool get _hasChanges {
    return _nameController.text.trim().isNotEmpty ||
        _phoneController.text.trim().isNotEmpty ||
        _addressController.text.trim().isNotEmpty ||
        _notesController.text.trim().isNotEmpty;
  }

  void _populateOnce(Customer customer) {
    if (_didPopulate) {
      return;
    }
    _nameController.text = customer.displayName;
    _phoneController.text = customer.phoneNumber?.value ?? '';
    _addressController.text = customer.address ?? '';
    _locationController.text = customer.defaultLocationId ?? '';
    _notesController.text = customer.notes ?? '';
    _didPopulate = true;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSaving = true);
    final input = CustomerInput(
      displayName: _nameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      notes: _notesController.text,
    );

    await saveCustomerProviders(
      ref,
      customerId: widget.customerId,
      input: input,
      onSuccess: (Customer saved) {
        if (!mounted) {
          return;
        }
        MasterDialogs.showSaved(
          context,
          _isEditing ? 'Customer updated' : 'Customer added',
        );
        _leaveForm(savedCustomerId: saved.id);
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

  void _leaveForm({String? savedCustomerId}) {
    final navigation = ref.read(navigationServiceProvider);
    if (_isEditing) {
      navigation.goToCustomerProfile(
        context,
        savedCustomerId ?? widget.customerId!,
      );
      return;
    }
    navigation.goToCustomers(context);
  }
}
