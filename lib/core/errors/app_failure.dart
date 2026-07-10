import 'package:equatable/equatable.dart';

sealed class AppFailure extends Equatable implements Exception {
  const AppFailure({required this.message, this.code, this.technicalMessage});

  final String message;
  final String? code;
  final String? technicalMessage;

  @override
  List<Object?> get props => <Object?>[message, code, technicalMessage];

  @override
  String toString() => message;
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure({
    super.message = 'Check your internet connection and try again.',
    super.code,
    super.technicalMessage,
  });
}

final class DatabaseFailure extends AppFailure {
  const DatabaseFailure({
    super.message = 'Unable to complete the database request.',
    super.code,
    super.technicalMessage,
  });
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.technicalMessage,
  });
}

final class PermissionFailure extends AppFailure {
  const PermissionFailure({
    super.message = 'You do not have permission to perform this action.',
    super.code,
    super.technicalMessage,
  });
}

final class AuthenticationFailure extends AppFailure {
  const AuthenticationFailure({
    super.message = 'Authentication failed. Please try again.',
    super.code,
    super.technicalMessage,
  });
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure({
    super.message = 'Something went wrong. Please try again.',
    super.code,
    super.technicalMessage,
  });
}
