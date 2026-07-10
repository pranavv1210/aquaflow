import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

final internetStatusProvider = StreamProvider<InternetStatus>((ref) {
  return InternetConnection().onStatusChange;
});

final isOnlineProvider = Provider<bool>((ref) {
  final status = ref.watch(internetStatusProvider);
  return status.maybeWhen(
    data: (InternetStatus value) => value == InternetStatus.connected,
    orElse: () => true,
  );
});
