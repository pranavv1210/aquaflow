import 'dart:async';

class RetryStrategy {
  const RetryStrategy({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(milliseconds: 250),
    this.backoffFactor = 2,
    this.shouldRetry,
  }) : assert(maxAttempts > 0),
       assert(backoffFactor >= 1);

  final int maxAttempts;
  final Duration initialDelay;
  final int backoffFactor;
  final bool Function(Object error)? shouldRetry;

  Future<T> run<T>(Future<T> Function() operation) async {
    var attempt = 0;
    var delay = initialDelay;

    while (true) {
      attempt += 1;
      try {
        return await operation();
      } catch (error) {
        final canRetry = shouldRetry?.call(error) ?? true;
        if (!canRetry || attempt >= maxAttempts) {
          rethrow;
        }
        await Future<void>.delayed(delay);
        delay *= backoffFactor;
      }
    }
  }
}
