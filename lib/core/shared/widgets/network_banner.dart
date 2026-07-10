import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/connectivity_providers.dart';
import '../../services/snackbar_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_elevation.dart';
import '../../theme/app_glass.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

class NetworkBanner extends ConsumerStatefulWidget {
  const NetworkBanner({super.key});

  @override
  ConsumerState<NetworkBanner> createState() => _NetworkBannerState();
}

class _NetworkBannerState extends ConsumerState<NetworkBanner> {
  AppConnectionState? _lastNotified;

  @override
  Widget build(BuildContext context) {
    final connection = ref.watch(appConnectionProvider);
    final state = connection.maybeWhen(
      data: (AppConnectionState value) => value,
      orElse: () => AppConnectionState.online,
    );
    _notifyTransition(state);

    final isOnline = state == AppConnectionState.online;
    return Align(
      alignment: Alignment.topCenter,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: _StatusPill(
            label: isOnline ? 'ONLINE' : 'OFFLINE',
            icon: isOnline ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
            color: isOnline ? AppColors.emeraldGreen : AppColors.softRed,
          ),
        ),
      ),
    );
  }

  void _notifyTransition(AppConnectionState state) {
    if (_lastNotified == state) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _lastNotified == state) {
        return;
      }
      if (_lastNotified != null) {
        if (state == AppConnectionState.online) {
          SnackbarService.success('Back Online');
        } else {
          SnackbarService.warning('Internet Lost');
        }
      }
      _lastNotified = state;
    });
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      liveRegion: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppGlass.blur,
            sigmaY: AppGlass.blur,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.76),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: color.withValues(alpha: 0.28)),
              boxShadow: AppElevation.soft,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(icon, color: color, size: 15),
                  const SizedBox(width: AppSpacing.xxs),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
