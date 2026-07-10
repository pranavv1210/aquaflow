import 'package:aquaflow/core/errors/app_failure.dart';
import 'package:aquaflow/core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Success returns the contained value', () {
    const result = Success<int>(42);

    expect(result.isSuccess, isTrue);
    expect(result.getOrThrow(), 42);
  });

  test('Failure throws the contained failure when unwrapped', () {
    const failure = ValidationFailure(message: 'Name is required.');
    const result = Failure<int>(failure);

    expect(result.isFailure, isTrue);
    expect(result.getOrThrow, throwsA(failure));
  });
}
