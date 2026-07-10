import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/error_state_widget.dart';
import '../../../core/shared/widgets/glass_card.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../../../core/shared/widgets/section_title.dart';
import '../../../core/shared/widgets/skeleton_loader.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/settings_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(businessProfileSettingsProvider);
    final version = ref.watch(appVersionLabelProvider);

    if (profile.isLoading || version.isLoading) {
      return const AppScreen(
        children: <Widget>[
          PageHeader(title: 'Settings', subtitle: 'Loading...'),
          SkeletonLoader(height: 180),
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
    return AppScreen(
      children: <Widget>[
        const PageHeader(title: 'Settings', subtitle: 'App configuration'),
        const SectionTitle(title: 'Business'),
        GlassCard(
          child: Column(
            children: <Widget>[
              _SettingRow(
                icon: Icons.storefront_outlined,
                label: 'Business Name',
                value: settings.businessName,
              ),
              const SizedBox(height: AppSpacing.sm),
              _SettingRow(
                icon: Icons.person_outline_rounded,
                label: 'Owner Name',
                value: _fallback(settings.ownerName),
              ),
              const SizedBox(height: AppSpacing.sm),
              _SettingRow(
                icon: Icons.phone_outlined,
                label: 'Owner Phone',
                value: _fallback(settings.ownerPhone),
              ),
              const SizedBox(height: AppSpacing.sm),
              _SettingRow(
                icon: Icons.location_on_outlined,
                label: 'Owner Address',
                value: _fallback(settings.ownerAddress),
              ),
            ],
          ),
        ),
        const SectionTitle(title: 'Preferences'),
        GlassCard(
          child: Column(
            children: <Widget>[
              _SettingRow(
                icon: Icons.currency_rupee_rounded,
                label: 'Currency',
                value: settings.currency,
              ),
              const SizedBox(height: AppSpacing.sm),
              _SettingRow(
                icon: Icons.calendar_today_outlined,
                label: 'Date Format',
                value: settings.dateFormat,
              ),
              const SizedBox(height: AppSpacing.sm),
              _SettingRow(
                icon: Icons.schedule_rounded,
                label: 'Time Format',
                value: settings.timeFormat,
              ),
              const SizedBox(height: AppSpacing.sm),
              const _SettingRow(
                icon: Icons.brightness_auto_outlined,
                label: 'Theme',
                value: 'System',
              ),
            ],
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
              const _SettingRow(
                icon: Icons.water_drop_outlined,
                label: 'Header',
                value: 'Water Management System',
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

  String _fallback(String value) {
    return value.trim().isEmpty ? 'Not set' : value;
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
