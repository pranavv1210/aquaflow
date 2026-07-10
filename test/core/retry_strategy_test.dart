import 'package:aquaflow/core/utils/retry_strategy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('RetryStrategy retries until operation succeeds', () async {
    var attempts = 0;
    const retry = RetryStrategy(maxAttempts: 3, initialDelay: Duration.zero);

    final value = await retry.run<int>(() async {
      attempts += 1;
      if (attempts < 2) {
        throw StateError('try again');
      }
      return 7;
    });

    expect(value, 7);
    expect(attempts, 2);
  });
}
