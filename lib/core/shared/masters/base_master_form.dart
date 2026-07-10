import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/connectivity_providers.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_screen.dart';
import '../widgets/page_header.dart';

class BaseMasterForm extends ConsumerWidget {
  const BaseMasterForm({
    required this.formKey,
    required this.title,
    required this.subtitle,
    required this.children,
    required this.onSave,
    required this.onCancel,
    super.key,
    this.isSaving = false,
    this.saveLabel = 'Save',
  });

  final GlobalKey<FormState> formKey;
  final String title;
  final String subtitle;
  final List<Widget> children;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final bool isSaving;
  final String saveLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    return Form(
      key: formKey,
      child: PopScope(
        canPop: !isSaving,
        child: AppScreen(
          children: <Widget>[
            PageHeader(title: title, subtitle: subtitle),
            ...children,
            PrimaryButton(
              label: isOnline ? saveLabel : 'Offline',
              icon: Icons.check_rounded,
              isLoading: isSaving,
              onPressed: isOnline ? onSave : null,
            ),
            SecondaryButton(
              label: 'Cancel',
              icon: Icons.close_rounded,
              onPressed: isSaving ? null : onCancel,
            ),
          ],
        ),
      ),
    );
  }
}
