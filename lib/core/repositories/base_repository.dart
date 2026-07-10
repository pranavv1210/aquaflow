import 'dart:async';

import '../errors/app_failure.dart';
import '../errors/exception_mapper.dart';
import '../result/result.dart';
import '../services/app_logger.dart';
import '../utils/memory_cache.dart';
import '../utils/retry_strategy.dart';

abstract class BaseRepository {
  BaseRepository({
    AppLogger? logger,
    RetryStrategy retryStrategy = const RetryStrategy(),
  }) : _logger = logger ?? appLog,
       _retryStrategy = retryStrategy;

  final AppLogger _logger;
  final RetryStrategy _retryStrategy;

  Future<Result<T>> guard<T>(
    String operationName,
    Future<T> Function() operation, {
    bool retry = false,
    String? fallbackMessage,
  }) async {
    try {
      _logger.debug(operationName);
      final future = retry ? _retryStrategy.run<T>(operation) : operation();
      final value = await future.timeout(const Duration(seconds: 15));
      return Success<T>(value);
    } on TimeoutException {
      const failure = NetworkFailure(
        message: 'Connection timed out. Please try again.',
      );
      _logger.warning('$operationName timed out');
      return Failure<T>(failure);
    } catch (error, stackTrace) {
      final failure = ExceptionMapper.toFailure(
        error,
        fallbackMessage: fallbackMessage ?? 'Unable to complete this action.',
      );
      _logger.error(
        '$operationName failed',
        error: failure.technicalMessage ?? failure.message,
        stackTrace: stackTrace,
      );
      return Failure<T>(failure);
    }
  }

  Future<Result<T>> cached<T>(
    String cacheKey,
    MemoryCache<T> cache,
    Future<T> Function() loader, {
    Duration? ttl,
    bool retry = false,
  }) async {
    final cachedValue = cache.get(cacheKey);
    if (cachedValue != null) {
      return Success<T>(cachedValue);
    }

    final result = await guard<T>('Load $cacheKey', loader, retry: retry);
    result.when(
      success: (T value) => cache.set(cacheKey, value, ttl: ttl),
      failure: (_) {},
    );
    return result;
  }
}
