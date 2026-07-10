import 'package:flutter/material.dart';

import '../../services/snackbar_service.dart';
import '../widgets/confirmation_dialog.dart';

class MasterDialogs {
  const MasterDialogs._();

  static Future<bool> confirmDelete(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return ConfirmationDialog.show(
      context,
      title: title,
      message: message,
      confirmLabel: 'Delete',
      isDestructive: true,
    );
  }

  static Future<bool> confirmDiscard(BuildContext context) {
    return ConfirmationDialog.show(
      context,
      title: 'Discard Changes?',
      message: 'Unsaved changes will be lost.',
      confirmLabel: 'Discard',
      isDestructive: true,
    );
  }

  static void showSaved(BuildContext context, String message) {
    SnackbarService.success(message);
  }

  static void showError(BuildContext context, String message) {
    SnackbarService.error(message);
  }
}
