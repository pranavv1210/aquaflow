import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/application/navigation_providers.dart';
import '../../../core/models/partner_tanker.dart';
import '../../../core/shared/masters/base_master_form.dart';
import '../../../core/shared/masters/master_dialogs.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/error_state_widget.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../application/partner_tanker_providers.dart';
import '../domain/partner_tanker_input.dart';
import 'widgets/partner_tanker_form_fields.dart';
import 'widgets/partner_tanker_list_skeleton.dart';

class PartnerTankerFormPage extends ConsumerStatefulWidget {
  const PartnerTankerFormPage({super.key, this.partnerTankerId});
  final String? partnerTankerId;
  @override
  ConsumerState<PartnerTankerFormPage> createState() =>
      _PartnerTankerFormPageState();
}

class _PartnerTankerFormPageState extends ConsumerState<PartnerTankerFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ownerController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _registrationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isSaving = false, _didPopulate = false;
  bool get _isEditing => widget.partnerTankerId != null;

  @override
  void dispose() {
    _ownerController.dispose();
    _vehicleController.dispose();
    _registrationController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEditing) return _buildForm();
    final pt = ref.watch(
      selectedPartnerTankerProvider(widget.partnerTankerId!),
    );
    return pt.when(
      loading:
          () => const AppScreen(
            children: [
              PageHeader(title: 'Edit Partner Tanker', subtitle: 'Loading...'),
              PartnerTankerListSkeleton(),
            ],
          ),
      error:
          (e, s) => AppScreen(
            children: [
              const PageHeader(title: 'Edit Partner Tanker', subtitle: 'Error'),
              ErrorStateWidget(
                title: 'Unable to load partner tanker',
                message: e.toString(),
                onRetry:
                    () => ref.invalidate(
                      selectedPartnerTankerProvider(widget.partnerTankerId!),
                    ),
              ),
            ],
          ),
      data: (PartnerTanker p) {
        _populateOnce(p);
        return _buildForm();
      },
    );
  }

  Widget _buildForm() => BaseMasterForm(
    formKey: _formKey,
    title: _isEditing ? 'Edit Partner Tanker' : 'Add Partner Tanker',
    subtitle:
        _isEditing ? 'Update partner tanker details' : 'Create partner tanker',
    saveLabel: _isEditing ? 'Update Partner Tanker' : 'Save Partner Tanker',
    isSaving: _isSaving,
    onSave: _save,
    onCancel: _confirmCancel,
    children: [
      PartnerTankerFormFields(
        ownerController: _ownerController,
        vehicleController: _vehicleController,
        registrationController: _registrationController,
        phoneController: _phoneController,
        notesController: _notesController,
      ),
    ],
  );

  Future<void> _confirmCancel() async {
    if (_hasChanges) {
      final d = await MasterDialogs.confirmDiscard(context);
      if (!d) return;
    }
    _leaveForm();
  }

  bool get _hasChanges =>
      _ownerController.text.trim().isNotEmpty ||
      _vehicleController.text.trim().isNotEmpty ||
      _registrationController.text.trim().isNotEmpty ||
      _phoneController.text.trim().isNotEmpty ||
      _notesController.text.trim().isNotEmpty;
  void _populateOnce(PartnerTanker p) {
    if (_didPopulate) return;
    _ownerController.text = p.ownerName;
    _vehicleController.text = p.vehicleName;
    _registrationController.text = p.registrationNumber;
    _phoneController.text = p.phone?.value ?? '';
    _notesController.text = p.notes ?? '';
    _didPopulate = true;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    final input = PartnerTankerInput(
      ownerName: _ownerController.text,
      vehicleName: _vehicleController.text,
      registrationNumber: _registrationController.text,
      phone: _phoneController.text,
      notes: _notesController.text,
    );
    await savePartnerTankerProviders(
      ref,
      partnerTankerId: widget.partnerTankerId,
      input: input,
      onSuccess: (PartnerTanker saved) {
        if (!mounted) return;
        MasterDialogs.showSaved(
          context,
          _isEditing ? 'Partner tanker updated' : 'Partner tanker added',
        );
        _leaveForm(savedPartnerTankerId: saved.id);
      },
      onFailure: (msg) {
        if (mounted) MasterDialogs.showError(context, msg);
      },
    );
    if (mounted) setState(() => _isSaving = false);
  }

  void _leaveForm({String? savedPartnerTankerId}) {
    final nav = ref.read(navigationServiceProvider);
    if (_isEditing) {
      nav.goToPartnerTankerProfile(
        context,
        savedPartnerTankerId ?? widget.partnerTankerId!,
      );
      return;
    }
    nav.goToPartnerTankers(context);
  }
}
