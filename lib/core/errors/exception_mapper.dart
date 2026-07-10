import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_failure.dart';

class ExceptionMapper {
  const ExceptionMapper._();

  static AppFailure toFailure(
    Object error, {
    String fallbackMessage = 'Something went wrong. Please try again.',
  }) {
    if (error is AppFailure) {
      return error;
    }
    if (error is SocketException || error is TimeoutException) {
      return NetworkFailure(technicalMessage: error.toString());
    }
    if (error is PostgrestException) {
      return DatabaseFailure(
        message: _messageForPostgrest(error),
        code: error.code,
        technicalMessage: error.message,
      );
    }
    return UnknownFailure(
      message: fallbackMessage,
      technicalMessage: error.toString(),
    );
  }

  static String _messageForPostgrest(PostgrestException error) {
    if (error.code == '23505') {
      return 'This record already exists.';
    }
    if (error.code == '42501') {
      return 'You do not have permission to perform this action.';
    }
    return 'Unable to complete the database request.';
  }
}
