import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/connectivity_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class NetworkBanner extends ConsumerStatefulWidget {
  const NetworkBanner({super.key});

  @override
  ConsumerState<NetworkBanner> createState() => _NetworkBannerState();
}

class _NetworkBannerState extends ConsumerState<NetworkBanner> {
  bool _wasOffline = false;

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(isOnlineProvider);

    if (!isOnline) {
      _wasOffline = true;
      return const _Banner(
        label: 'Offline',
        backgroundColor: AppColors.softRed,
        icon: Icons.wifi_off_rounded,
      );
    }

    if (_wasOffline) {
      return _Banner(
        label: 'Back Online',
        backgroundColor: AppColors.emeraldGreen,
        icon: Icons.wifi_rounded,
        onVisible: () {
          Future<void>.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() => _wasOffline = false);
            }
          });
        },
      );
    }

    return const SizedBox.shrink();
  }
}

class _Banner extends StatefulWidget {
  const _Banner({
    required this.label,
    required this.backgroundColor,
    required this.icon,
    this.onVisible,
  });

  final String label;
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback? onVisible;

  @override
  State<_Banner> createState() => _BannerState();
}

class _BannerState extends State<_Banner> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.onVisible?.call(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.label,
      liveRegion: true,
      child: Material(
        color: widget.backgroundColor,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(widget.icon, color: Colors.white, size: 18),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
