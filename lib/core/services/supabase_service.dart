import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../errors/app_failure.dart';
import '../result/result.dart';
import 'app_logger.dart';

class SupabaseService {
  SupabaseService._();

  static final SupabaseService instance = SupabaseService._();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  static Future<void> initialize(AppConfig config) {
    return instance.connect(config);
  }

  Future<void> connect(AppConfig config) async {
    if (_isInitialized) {
      appLog.debug('Supabase already initialized');
      return;
    }

    if (!config.hasSupabaseCredentials) {
      appLog.warning(
        'Supabase credentials are not configured. '
        'Add SUPABASE_URL and SUPABASE_ANON_KEY to .env.',
      );
      return;
    }

    await Supabase.initialize(
      url: config.supabaseUrl,
      publishableKey: config.supabaseAnonKey,
    );
    _isInitialized = true;
    appLog.info('Supabase initialized');
  }

  Future<Result<void>> healthCheck() async {
    if (!_isInitialized) {
      return const Failure<void>(
        DatabaseFailure(message: 'Supabase is not initialized.'),
      );
    }

    try {
      await client.from('business_settings').select('id').limit(1);
      return const Success<void>(null);
    } catch (error, stackTrace) {
      appLog.error(
        'Supabase health check failed',
        error: error,
        stackTrace: stackTrace,
      );
      return Failure<void>(
        DatabaseFailure(
          message: 'Unable to connect to Supabase.',
          technicalMessage: error.toString(),
        ),
      );
    }
  }

  void initializeRealtime() {
    if (!_isInitialized) {
      appLog.warning('Realtime initialization skipped before Supabase connect');
      return;
    }
    appLog.debug('Supabase realtime foundation ready');
  }

  static SupabaseClient get client => Supabase.instance.client;
}
