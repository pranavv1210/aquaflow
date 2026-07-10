import 'package:flutter/services.dart';

import '../constants/app_constants.dart';

class AppConfig {
  const AppConfig({
    required this.appName,
    required this.appHeader,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
  });

  static Future<AppConfig> load() async {
    final env = await _loadEnvFile();
    return AppConfig(
      appName: AppConstants.appName,
      appHeader: AppConstants.appHeader,
      supabaseUrl:
          env['SUPABASE_URL'] ?? const String.fromEnvironment('SUPABASE_URL'),
      supabaseAnonKey:
          env['SUPABASE_ANON_KEY'] ??
          const String.fromEnvironment('SUPABASE_ANON_KEY'),
    );
  }

  final String appName;
  final String appHeader;
  final String supabaseUrl;
  final String supabaseAnonKey;

  bool get hasSupabaseCredentials =>
      supabaseUrl.trim().isNotEmpty && supabaseAnonKey.trim().isNotEmpty;

  static Future<Map<String, String>> _loadEnvFile() async {
    try {
      final content = await rootBundle.loadString('.env');
      return _parseEnv(content);
    } catch (_) {
      return const <String, String>{};
    }
  }

  static Map<String, String> _parseEnv(String content) {
    final values = <String, String>{};
    for (final rawLine in content.split('\n')) {
      final line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#')) {
        continue;
      }
      final separator = line.indexOf('=');
      if (separator <= 0) {
        continue;
      }
      final key = line.substring(0, separator).trim();
      final value = line.substring(separator + 1).trim();
      values[key] = value;
    }
    return values;
  }
}
