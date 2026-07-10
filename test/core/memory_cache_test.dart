import 'package:aquaflow/core/utils/memory_cache.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('MemoryCache returns values before TTL expiry', () {
    final cache = MemoryCache<String>();

    cache.set('customer-list', 'cached');

    expect(cache.get('customer-list'), 'cached');
  });

  test('MemoryCache invalidates values manually', () {
    final cache = MemoryCache<String>()..set('customer-list', 'cached');

    cache.invalidate('customer-list');

    expect(cache.get('customer-list'), isNull);
  });
}
