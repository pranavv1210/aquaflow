import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/application/navigation_providers.dart';
import '../../../core/models/location.dart';
import '../../../core/shared/masters/base_master_form.dart';
import '../../../core/shared/masters/master_dialogs.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/error_state_widget.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../application/location_providers.dart';
import '../domain/location_input.dart';
import 'widgets/location_form_fields.dart';
import 'widgets/location_list_skeleton.dart';

class LocationFormPage extends ConsumerStatefulWidget {
  const LocationFormPage({super.key, this.locationId});
  final String? locationId;
  @override
  ConsumerState<LocationFormPage> createState() => _LocationFormPageState();
}

class _LocationFormPageState extends ConsumerState<LocationFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isSaving = false, _didPopulate = false;
  bool get _isEditing => widget.locationId != null;

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEditing) return _buildForm();
    final location = ref.watch(selectedLocationProvider(widget.locationId!));
    return switch (location) {
      AsyncData<Location>(:final value) => () {
        _populateOnce(value);
        return _buildForm();
      }(),
      AsyncError<Location>(:final error) => AppScreen(
        children: [
          const PageHeader(title: 'Edit Location', subtitle: 'Error'),
          ErrorStateWidget(
            title: 'Unable to load location',
            message: error.toString(),
            onRetry:
                () => ref.invalidate(
                  selectedLocationProvider(widget.locationId!),
                ),
          ),
        ],
      ),
      _ => const AppScreen(
        children: [
          PageHeader(title: 'Edit Location', subtitle: 'Loading...'),
          LocationListSkeleton(),
        ],
      ),
    };
  }

  Widget _buildForm() => BaseMasterForm(
    formKey: _formKey,
    title: _isEditing ? 'Edit Location' : 'Add Location',
    subtitle: _isEditing ? 'Update location details' : 'Create location',
    saveLabel: _isEditing ? 'Update Location' : 'Save Location',
    isSaving: _isSaving,
    onSave: _save,
    onCancel: _confirmCancel,
    children: [
      LocationFormFields(
        nameController: _nameController,
        notesController: _notesController,
      ),
    ],
  );

  Future<void> _confirmCancel() async {
    if (_hasChanges) {
      final discard = await MasterDialogs.confirmDiscard(context);
      if (!discard) return;
    }
    _leaveForm();
  }

  bool get _hasChanges =>
      _nameController.text.trim().isNotEmpty ||
      _notesController.text.trim().isNotEmpty;

  void _populateOnce(Location loc) {
    if (_didPopulate) return;
    _nameController.text = loc.locationName;
    _notesController.text = loc.notes ?? '';
    _didPopulate = true;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    final input = LocationInput(
      locationName: _nameController.text,
      notes: _notesController.text,
    );
    await saveLocationProviders(
      ref,
      locationId: widget.locationId,
      input: input,
      onSuccess: (Location saved) {
        if (!mounted) return;
        MasterDialogs.showSaved(
          context,
          _isEditing ? 'Location updated' : 'Location added',
        );
        _leaveForm(savedLocationId: saved.id);
      },
      onFailure: (msg) {
        if (mounted) MasterDialogs.showError(context, msg);
      },
    );
    if (mounted) setState(() => _isSaving = false);
  }

  void _leaveForm({String? savedLocationId}) {
    final nav = ref.read(navigationServiceProvider);
    if (_isEditing) {
      nav.goToLocationProfile(context, savedLocationId ?? widget.locationId!);
      return;
    }
    nav.goToLocations(context);
  }
}
