import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/navigation_providers.dart';
import '../../../core/models/vehicle.dart';
import '../../../core/shared/masters/base_master_form.dart';
import '../../../core/shared/masters/master_dialogs.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/error_state_widget.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../application/vehicle_providers.dart';
import '../domain/vehicle_input.dart';
import 'widgets/vehicle_form_fields.dart';
import 'widgets/vehicle_list_skeleton.dart';

class VehicleFormPage extends ConsumerStatefulWidget {
  const VehicleFormPage({super.key, this.vehicleId});
  final String? vehicleId;

  @override
  ConsumerState<VehicleFormPage> createState() => _VehicleFormPageState();
}

class _VehicleFormPageState extends ConsumerState<VehicleFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _registrationController = TextEditingController();
  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isSaving = false;
  bool _didPopulate = false;

  bool get _isEditing => widget.vehicleId != null;

  @override
  void dispose() {
    _nameController.dispose();
    _registrationController.dispose();
    _vehicleTypeController.dispose();
    _statusController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEditing && _statusController.text.isEmpty) {
      _statusController.text = 'available';
    }

    if (!_isEditing) {
      return _buildForm();
    }

    final vehicle = ref.watch(selectedVehicleProvider(widget.vehicleId!));
    return vehicle.when(
      loading:
          () => const AppScreen(
            children: <Widget>[
              PageHeader(title: 'Edit Vehicle', subtitle: 'Loading...'),
              VehicleListSkeleton(),
            ],
          ),
      error: (Object error, StackTrace stackTrace) {
        return AppScreen(
          children: <Widget>[
            const PageHeader(title: 'Edit Vehicle', subtitle: 'Error'),
            ErrorStateWidget(
              title: 'Unable to load vehicle',
              message: error.toString(),
              onRetry:
                  () => ref.invalidate(
                    selectedVehicleProvider(widget.vehicleId!),
                  ),
            ),
          ],
        );
      },
      data: (Vehicle vehicle) {
        _populateOnce(vehicle);
        return _buildForm();
      },
    );
  }

  Widget _buildForm() {
    return BaseMasterForm(
      formKey: _formKey,
      title: _isEditing ? 'Edit Vehicle' : 'Add Vehicle',
      subtitle: _isEditing ? 'Update vehicle details' : 'Create vehicle',
      saveLabel: _isEditing ? 'Update Vehicle' : 'Save Vehicle',
      isSaving: _isSaving,
      onSave: _save,
      onCancel: _confirmCancel,
      children: <Widget>[
        VehicleFormFields(
          nameController: _nameController,
          registrationController: _registrationController,
          vehicleTypeController: _vehicleTypeController,
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

  bool get _hasChanges =>
      _nameController.text.trim().isNotEmpty ||
      _registrationController.text.trim().isNotEmpty ||
      _vehicleTypeController.text.trim().isNotEmpty ||
      _statusController.text.trim().isNotEmpty ||
      _notesController.text.trim().isNotEmpty;

  void _populateOnce(Vehicle vehicle) {
    if (_didPopulate) {
      return;
    }
    _nameController.text = vehicle.vehicleName;
    _registrationController.text = vehicle.registrationNumber;
    _vehicleTypeController.text = vehicle.vehicleType.name;
    _statusController.text = vehicle.status.name;
    _notesController.text = vehicle.notes ?? '';
    _didPopulate = true;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _isSaving = true);
    final input = VehicleInput(
      vehicleName: _nameController.text,
      registrationNumber: _registrationController.text,
      vehicleType: _vehicleTypeController.text,
      status: _statusController.text,
      notes: _notesController.text,
    );

    await saveVehicleProviders(
      ref,
      vehicleId: widget.vehicleId,
      input: input,
      onSuccess: (Vehicle saved) {
        if (!mounted) {
          return;
        }
        MasterDialogs.showSaved(
          context,
          _isEditing ? 'Vehicle updated' : 'Vehicle added',
        );
        _leaveForm(savedVehicleId: saved.id);
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

  void _leaveForm({String? savedVehicleId}) {
    final navigation = ref.read(navigationServiceProvider);
    if (_isEditing) {
      navigation.goToVehicleDetails(
        context,
        savedVehicleId ?? widget.vehicleId!,
      );
      return;
    }
    navigation.goToVehicles(context);
  }
}
