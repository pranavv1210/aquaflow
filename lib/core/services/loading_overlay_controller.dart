import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadingOverlayProvider = NotifierProvider<LoadingOverlayController, bool>(
  LoadingOverlayController.new,
);

class LoadingOverlayController extends Notifier<bool> {
  @override
  bool build() => false;

  void show() => state = true;

  void hide() => state = false;

  Future<T> during<T>(Future<T> Function() action) async {
    show();
    try {
      return await action();
    } finally {
      hide();
    }
  }
}
