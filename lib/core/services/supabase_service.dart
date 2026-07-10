import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import 'app_logger.dart';

class SupabaseService {
  const SupabaseService._();

  static Future<void> initialize(AppConfig config) async {
    if (!config.hasSupabaseCredentials) {
      appLogger.w(
        'Supabase credentials are not configured. '
        'Add SUPABASE_URL and SUPABASE_ANON_KEY to .env.',
      );
      return;
    }

    await Supabase.initialize(
      url: config.supabaseUrl,
      publishableKey: config.supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
