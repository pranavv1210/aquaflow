import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/snackbar_service.dart';
import '../../../core/shared/widgets/app_buttons.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/app_text_field.dart';
import '../../../core/shared/widgets/error_state_widget.dart';
import '../../../core/shared/widgets/glass_card.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/section_title.dart';
import '../../../core/shared/widgets/skeleton_loader.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/settings_providers.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  final _ownerAddressController = TextEditingController();

  String? _loadedSignature;
  bool _isSaving = false;

  @override
  void dispose() {
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    _ownerAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(businessProfileSettingsProvider);
    final version = ref.watch(appVersionLabelProvider);

    if (profile.isLoading || version.isLoading) {
      return const AppScreen(
        children: <Widget>[
          PageHeader(title: 'Settings', subtitle: 'Loading...'),
          SkeletonLoader(height: 220),
          SkeletonLoader(height: 120),
        ],
      );
    }

    final error = profile.error ?? version.error;
    if (error != null) {
      return AppScreen(
        children: <Widget>[
          const PageHeader(title: 'Settings', subtitle: 'App configuration'),
          ErrorStateWidget(
            title: 'Unable to load settings',
            message: error.toString(),
            onRetry: () {
              ref.invalidate(businessProfileSettingsProvider);
              ref.invalidate(appVersionLabelProvider);
            },
          ),
        ],
      );
    }

    final settings = profile.value!;
    _syncControllers(settings);

    return AppScreen(
      children: <Widget>[
        const PageHeader(title: 'Settings', subtitle: 'Business profile'),
        const SectionTitle(title: 'Business'),
        Form(
          key: _formKey,
          child: GlassCard(
            child: Column(
              children: <Widget>[
                AppTextField(
                  label: 'Business Name',
                  controller: _businessNameController,
                  prefixIcon: Icons.storefront_outlined,
                  textInputAction: TextInputAction.next,
                  validator:
                      (String? value) =>
                          (value?.trim().isEmpty ?? true)
                              ? 'Business name is required'
                              : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Owner Name',
                  controller: _ownerNameController,
                  prefixIcon: Icons.person_outline_rounded,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Owner Phone',
                  controller: _ownerPhoneController,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Owner Address',
                  controller: _ownerAddressController,
                  prefixIcon: Icons.location_on_outlined,
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: 'Save Settings',
                  icon: Icons.check_rounded,
                  isLoading: _isSaving,
                  onPressed: _isSaving ? null : () => _save(settings),
                ),
              ],
            ),
          ),
        ),
        const SectionTitle(title: 'About'),
        GlassCard(
          child: Column(
            children: <Widget>[
              const _SettingRow(
                icon: Icons.info_outline_rounded,
                label: 'App',
                value: 'AquaFlow',
              ),
              const SizedBox(height: AppSpacing.sm),
              _SettingRow(
                icon: Icons.tag_outlined,
                label: 'Version',
                value: version.value ?? '--',
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _syncControllers(BusinessProfileSettings settings) {
    final signature = settings.toJson().toString();
    if (_loadedSignature == signature) {
      return;
    }
    _loadedSignature = signature;
    _businessNameController.text = settings.businessName;
    _ownerNameController.text = settings.ownerName;
    _ownerPhoneController.text = settings.ownerPhone;
    _ownerAddressController.text = settings.ownerAddress;
  }

  Future<void> _save(BusinessProfileSettings current) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _isSaving = true);
    try {
      await ref.read(saveBusinessProfileSettingsProvider)(
        current.copyWith(
          businessName: _businessNameController.text,
          ownerName: _ownerNameController.text,
          ownerPhone: _ownerPhoneController.text,
          ownerAddress: _ownerAddressController.text,
        ),
      );
      if (mounted) {
        SnackbarService.success('Settings saved');
      }
    } catch (_) {
      if (mounted) {
        SnackbarService.error('Unable to save settings');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(label)),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
