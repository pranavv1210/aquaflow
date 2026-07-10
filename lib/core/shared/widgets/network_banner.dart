import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/connectivity_providers.dart';
import '../../services/snackbar_service.dart';

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
      orElse: () => _lastNotified ?? AppConnectionState.online,
    );
    _notifyTransition(state);
    return const SizedBox.shrink();
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
