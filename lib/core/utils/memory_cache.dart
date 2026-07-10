class CacheEntry<T> {
  const CacheEntry({required this.value, required this.expiresAt});

  final T value;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

class MemoryCache<T> {
  MemoryCache({this.defaultTtl = const Duration(minutes: 5)});

  final Duration defaultTtl;
  final Map<String, CacheEntry<T>> _entries = <String, CacheEntry<T>>{};

  T? get(String key) {
    final entry = _entries[key];
    if (entry == null) {
      return null;
    }
    if (entry.isExpired) {
      _entries.remove(key);
      return null;
    }
    return entry.value;
  }

  void set(String key, T value, {Duration? ttl}) {
    _entries[key] = CacheEntry<T>(
      value: value,
      expiresAt: DateTime.now().add(ttl ?? defaultTtl),
    );
  }

  void invalidate(String key) {
    _entries.remove(key);
  }

  void clear() {
    _entries.clear();
  }
}
