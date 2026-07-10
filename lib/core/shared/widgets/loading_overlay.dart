import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/loading_overlay_controller.dart';
import '../../theme/app_colors.dart';

class LoadingOverlay extends ConsumerWidget {
  const LoadingOverlay({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingOverlayProvider);

    return Stack(
      children: <Widget>[
        child,
        if (isLoading)
          Semantics(
            label: 'Loading',
            liveRegion: true,
            child: ColoredBox(
              color: AppColors.ink900.withValues(alpha: 0.22),
              child: const Center(
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
