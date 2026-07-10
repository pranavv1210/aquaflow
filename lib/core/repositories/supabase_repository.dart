import 'package:supabase_flutter/supabase_flutter.dart';

import '../result/result.dart';
import 'base_repository.dart';

abstract class SupabaseRepository extends BaseRepository {
  SupabaseRepository(this.client);

  final SupabaseClient client;

  Future<Result<List<Map<String, dynamic>>>> selectRows(
    String table, {
    String columns = '*',
  }) {
    return guard<List<Map<String, dynamic>>>('Select $table rows', () async {
      final response = await client.from(table).select(columns);
      return _rows(response);
    });
  }

  Future<Result<Map<String, dynamic>>> selectRowById(
    String table,
    String id, {
    String columns = '*',
  }) {
    return guard<Map<String, dynamic>>('Select $table row', () async {
      final response =
          await client.from(table).select(columns).eq('id', id).single();
      return Map<String, dynamic>.from(response);
    });
  }

  Future<Result<Map<String, dynamic>>> insertRow(
    String table,
    Map<String, dynamic> values,
  ) {
    return guard<Map<String, dynamic>>('Insert $table row', () async {
      final response =
          await client.from(table).insert(values).select().single();
      return Map<String, dynamic>.from(response);
    });
  }

  Future<Result<Map<String, dynamic>>> updateRow(
    String table,
    String id,
    Map<String, dynamic> values,
  ) {
    return guard<Map<String, dynamic>>('Update $table row', () async {
      final response =
          await client
              .from(table)
              .update(values)
              .eq('id', id)
              .select()
              .single();
      return Map<String, dynamic>.from(response);
    });
  }

  Future<Result<void>> softDeleteRow(
    String table,
    String id, {
    String column = 'is_active',
  }) {
    return guard<void>('Soft delete $table row', () async {
      await client
          .from(table)
          .update(<String, dynamic>{column: false})
          .eq('id', id);
    });
  }

  List<Map<String, dynamic>> _rows(dynamic response) {
    return (response as List<dynamic>).cast<Map<String, dynamic>>().toList(
      growable: false,
    );
  }
}
