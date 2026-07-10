import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_logger.dart';

class RealtimeService {
  const RealtimeService(this._client);

  final SupabaseClient _client;

  Stream<List<Map<String, dynamic>>> tableStream({
    required String table,
    required List<String> primaryKey,
  }) {
    appLog.debug('Opening realtime stream for $table');
    return _client
        .from(table)
        .stream(primaryKey: primaryKey)
        .map(
          (List<Map<String, dynamic>> rows) =>
              rows.map(Map<String, dynamic>.from).toList(growable: false),
        );
  }
}
