import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/navigation_providers.dart';
import '../../../core/models/driver.dart';
import '../../../core/shared/masters/base_master_form.dart';
import '../../../core/shared/masters/master_dialogs.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/error_state_widget.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../application/driver_providers.dart';
import '../domain/driver_input.dart';
import 'widgets/driver_form_fields.dart';
import 'widgets/driver_list_skeleton.dart';

class DriverFormPage extends ConsumerStatefulWidget {
  const DriverFormPage({super.key, this.driverId});

  final String? driverId;

  @override
  ConsumerState<DriverFormPage> createState() => _DriverFormPageState();
}

class _DriverFormPageState extends ConsumerState<DriverFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isSaving = false;
  bool _didPopulate = false;

  bool get _isEditing => widget.driverId != null;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _statusController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEditing) {
      return _buildForm();
    }

    final driver = ref.watch(selectedDriverProvider(widget.driverId!));
    return driver.when(
      loading:
          () => const AppScreen(
            children: <Widget>[
              PageHeader(title: 'Edit Driver', subtitle: 'Loading...'),
              DriverListSkeleton(),
            ],
          ),
      error: (Object error, StackTrace stackTrace) {
        return AppScreen(
          children: <Widget>[
            const PageHeader(title: 'Edit Driver', subtitle: 'Error'),
            ErrorStateWidget(
              title: 'Unable to load driver',
              message: error.toString(),
              onRetry:
                  () => ref.invalidate(
                    selectedDriverProvider(widget.driverId!),
                  ),
            ),
          ],
        );
      },
      data: (Driver driver) {
        _populateOnce(driver);
        return _buildForm();
      },
    );
  }

  Widget _buildForm() {
    return BaseMasterForm(
      formKey: _formKey,
      title: _isEditing ? 'Edit Driver' : 'Add Driver',
      subtitle: _isEditing ? 'Update driver details' : 'Create driver',
      saveLabel: _isEditing ? 'Update Driver' : 'Save Driver',
      isSaving: _isSaving,
      onSave: _save,
      onCancel: _confirmCancel,
      children: <Widget>[
        DriverFormFields(
          nameController: _nameController,
          phoneController: _phoneController,
          statusController: _statusController,
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
        _statusController.text.trim().isNotEmpty ||
        _notesController.text.trim().isNotEmpty;
  }

  void _populateOnce(Driver driver) {
    if (_didPopulate) {
      return;
    }
    _nameController.text = driver.driverName;
    _phoneController.text = driver.phone?.value ?? '';
    _statusController.text = driver.status.name;
    _notesController.text = driver.notes ?? '';
    _didPopulate = true;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSaving = true);
    final input = DriverInput(
      driverName: _nameController.text,
      phone: _phoneController.text,
      status: _statusController.text,
      notes: _notesController.text,
    );

    await saveDriverProviders(
      ref,
      driverId: widget.driverId,
      input: input,
      onSuccess: (Driver saved) {
        if (!mounted) {
          return;
        }
        MasterDialogs.showSaved(
          context,
          _isEditing ? 'Driver updated' : 'Driver added',
        );
        _leaveForm(savedDriverId: saved.id);
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

  void _leaveForm({String? savedDriverId}) {
    final navigation = ref.read(navigationServiceProvider);
    if (_isEditing) {
      navigation.goToDriverProfile(
        context,
        savedDriverId ?? widget.driverId!,
      );
      return;
    }
    navigation.goToDrivers(context);
  }
}