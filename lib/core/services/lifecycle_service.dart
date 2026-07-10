import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final lifecycleServiceProvider = Provider<LifecycleService>((ref) {
  final service = LifecycleService();
  ref.onDispose(service.dispose);
  return service;
});

final appLifecycleStateProvider = StreamProvider<AppLifecycleState>((ref) {
  return ref.watch(lifecycleServiceProvider).states;
});

class LifecycleService with WidgetsBindingObserver {
  LifecycleService() {
    WidgetsBinding.instance.addObserver(this);
  }

  final StreamController<AppLifecycleState> _controller =
      StreamController<AppLifecycleState>.broadcast();

  Stream<AppLifecycleState> get states => _controller.stream;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _controller.add(state);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.close();
  }
}
