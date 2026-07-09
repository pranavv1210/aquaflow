import '../constants/app_constants.dart';

class AppConfig {
  const AppConfig({
    required this.appName,
    required this.appHeader,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
  });

  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      appName: AppConstants.appName,
      appHeader: AppConstants.appHeader,
      supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
      supabaseAnonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
    );
  }

  final String appName;
  final String appHeader;
  final String supabaseUrl;
  final String supabaseAnonKey;

  bool get hasSupabaseCredentials =>
      supabaseUrl.trim().isNotEmpty && supabaseAnonKey.trim().isNotEmpty;
}
