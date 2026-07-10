import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'supabase_service.dart';

enum AppConnectionState { online, offline }

final appConnectionProvider = StreamProvider<AppConnectionState>((ref) async* {
  final controller = StreamController<AppConnectionState>();
  Timer? timer;
  AppConnectionState? lastEmitted;

  Future<void> check() async {
    final state = await _resolveConnectionState();
    if (lastEmitted != state && !controller.isClosed) {
      lastEmitted = state;
      controller.add(state);
    }
  }

  timer = Timer.periodic(const Duration(seconds: 8), (_) => check());
  unawaited(check());

  final connectivitySubscription = Connectivity().onConnectivityChanged.listen(
    (_) => check(),
  );

  ref.onDispose(() {
    timer?.cancel();
    connectivitySubscription.cancel();
    controller.close();
  });

  yield* controller.stream;
});

final isOnlineProvider = Provider<bool>((ref) {
  final status = ref.watch(appConnectionProvider);
  return status.maybeWhen(
    data: (AppConnectionState value) => value == AppConnectionState.online,
    orElse: () => true,
  );
});

Future<AppConnectionState> _resolveConnectionState() async {
  final connectivity = await Connectivity().checkConnectivity();
  if (connectivity.every((result) => result == ConnectivityResult.none)) {
    return AppConnectionState.offline;
  }

  final hasInternet = await InternetConnection().hasInternetAccess;
  if (!hasInternet) {
    return AppConnectionState.offline;
  }

  if (!SupabaseService.instance.isInitialized) {
    return AppConnectionState.offline;
  }

  final health = await SupabaseService.instance.healthCheck();
  return health.isSuccess
      ? AppConnectionState.online
      : AppConnectionState.offline;
}
