import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/application/navigation_providers.dart';
import '../../../core/models/water_point.dart';
import '../../../core/shared/masters/base_master_form.dart';
import '../../../core/shared/masters/master_dialogs.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/error_state_widget.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../application/water_point_providers.dart';
import '../domain/water_point_input.dart';
import 'widgets/water_point_form_fields.dart';
import 'widgets/water_point_list_skeleton.dart';

class WaterPointFormPage extends ConsumerStatefulWidget {
  const WaterPointFormPage({super.key, this.waterPointId});
  final String? waterPointId;
  @override
  ConsumerState<WaterPointFormPage> createState() => _WaterPointFormPageState();
}

class _WaterPointFormPageState extends ConsumerState<WaterPointFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isSaving = false, _didPopulate = false;
  bool get _isEditing => widget.waterPointId != null;

  @override
  void dispose() { _nameController.dispose(); _locationController.dispose(); _notesController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    if (!_isEditing) return _buildForm();
    final wp = ref.watch(selectedWaterPointProvider(widget.waterPointId!));
    return wp.when(
      loading: () => const AppScreen(children: [PageHeader(title: 'Edit Water Point', subtitle: 'Loading...'), WaterPointListSkeleton()]),
      error: (e, s) => AppScreen(children: [const PageHeader(title: 'Edit Water Point', subtitle: 'Error'), ErrorStateWidget(title: 'Unable to load water point', message: e.toString(), onRetry: () => ref.invalidate(selectedWaterPointProvider(widget.waterPointId!)))]),
      data: (WaterPoint w) { _populateOnce(w); return _buildForm(); },
    );
  }

  Widget _buildForm() => BaseMasterForm(formKey: _formKey, title: _isEditing ? 'Edit Water Point' : 'Add Water Point', subtitle: _isEditing ? 'Update water point details' : 'Create water point', saveLabel: _isEditing ? 'Update Water Point' : 'Save Water Point', isSaving: _isSaving, onSave: _save, onCancel: _confirmCancel, children: [WaterPointFormFields(nameController: _nameController, locationController: _locationController, notesController: _notesController)]);

  Future<void> _confirmCancel() async { if (_hasChanges) { final d = await MasterDialogs.confirmDiscard(context); if (!d) return; } _leaveForm(); }
  bool get _hasChanges => _nameController.text.trim().isNotEmpty || _notesController.text.trim().isNotEmpty;
  void _populateOnce(WaterPoint w) { if (_didPopulate) return; _nameController.text = w.waterPointName; _locationController.text = w.locationId ?? ''; _notesController.text = w.notes ?? ''; _didPopulate = true; }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    final input = WaterPointInput(waterPointName: _nameController.text, locationId: _locationController.text, notes: _notesController.text);
    await saveWaterPointProviders(ref, waterPointId: widget.waterPointId, input: input,
      onSuccess: (WaterPoint saved) { if (!mounted) return; MasterDialogs.showSaved(context, _isEditing ? 'Water point updated' : 'Water point added'); _leaveForm(savedWaterPointId: saved.id); },
      onFailure: (msg) { if (mounted) MasterDialogs.showError(context, msg); },
    );
    if (mounted) setState(() => _isSaving = false);
  }

  void _leaveForm({String? savedWaterPointId}) {
    final nav = ref.read(navigationServiceProvider);
    if (_isEditing) { nav.goToWaterPointProfile(context, savedWaterPointId ?? widget.waterPointId!); return; }
    nav.goToWaterPoints(context);
  }
}
