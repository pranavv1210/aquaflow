import 'package:flutter/material.dart';

import 'empty_state_widget.dart';
import 'error_state_widget.dart';
import 'loading_widget.dart';

enum UiContentState { loading, empty, error, populated }

class UiStateSwitcher extends StatelessWidget {
  const UiStateSwitcher({
    required this.state,
    required this.populated,
    super.key,
    this.loadingMessage = 'Loading...',
    this.emptyTitle = 'No Data',
    this.emptyMessage,
    this.emptyIcon = Icons.inbox_outlined,
    this.errorTitle = 'Something went wrong',
    this.errorMessage,
    this.onRetry,
  });

  final UiContentState state;
  final Widget populated;
  final String loadingMessage;
  final String emptyTitle;
  final String? emptyMessage;
  final IconData emptyIcon;
  final String errorTitle;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      UiContentState.loading => LoadingWidget(message: loadingMessage),
      UiContentState.empty => EmptyStateWidget(
        title: emptyTitle,
        message: emptyMessage,
        icon: emptyIcon,
      ),
      UiContentState.error => ErrorStateWidget(
        title: errorTitle,
        message: errorMessage,
        onRetry: onRetry,
      ),
      UiContentState.populated => populated,
    };
  }
}
