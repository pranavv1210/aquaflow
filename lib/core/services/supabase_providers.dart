import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'realtime_service.dart';
import 'supabase_service.dart';

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService.instance;
});

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return SupabaseService.client;
});

final supabaseHealthProvider = FutureProvider<void>((ref) async {
  final result = await ref.watch(supabaseServiceProvider).healthCheck();
  return result.getOrThrow();
});

final realtimeServiceProvider = Provider<RealtimeService>((ref) {
  return RealtimeService(ref.watch(supabaseClientProvider));
});
