import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/models/water_point.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../../../core/result/result.dart';
import '../../../../core/shared/masters/master_validators.dart';
import '../../domain/water_point_input.dart';
import '../../domain/repositories/water_point_repository.dart';
import '../dto/water_point_dto.dart';
import '../mappers/water_point_mapper.dart';

class SupabaseWaterPointRepository extends BaseRepository implements WaterPointRepository {
  SupabaseWaterPointRepository(this._client);
  final SupabaseClient _client;
  static const String _table = 'water_points';

  @override
  Future<Result<List<WaterPoint>>> getWaterPoints() async {
    final result = await guard<List<WaterPointDto>>('Load water points', () async {
      final response = await _client.from(_table).select().eq('is_active', true).order('name', ascending: true);
      return _mapList(response);
    }, fallbackMessage: 'Unable to load water points.');
    return _mapListResult(result);
  }

  @override
  Future<Result<WaterPoint>> getWaterPointById(String id) async {
    final result = await guard<WaterPointDto>('Load water point', () async {
      final response = await _client.from(_table).select().eq('id', id).maybeSingle();
      if (response == null) throw const DatabaseFailure(message: 'Water point not found.');
      return WaterPointDto.fromJson(response);
    }, fallbackMessage: 'Unable to load water point.');
    return _mapResult(result);
  }

  @override
  Future<Result<WaterPoint>> createWaterPoint(WaterPointInput input) async {
    final unique = await _ensureNameIsUnique(input.waterPointName, locationId: input.locationId);
    if (unique case Failure<void> failure) return Failure<WaterPoint>(failure.failure);
    final result = await guard<WaterPointDto>('Create water point', () async {
      final response = await _client.from(_table).insert(_inputToJson(input)).select().single();
      return WaterPointDto.fromJson(response);
    }, fallbackMessage: 'Unable to save water point.');
    return _mapResult(result);
  }

  @override
  Future<Result<WaterPoint>> updateWaterPoint(String id, WaterPointInput input) async {
    final unique = await _ensureNameIsUnique(input.waterPointName, locationId: input.locationId, excludeId: id);
    if (unique case Failure<void> failure) return Failure<WaterPoint>(failure.failure);
    final result = await guard<WaterPointDto>('Update water point', () async {
      final response = await _client.from(_table).update(_inputToJson(input)).eq('id', id).select().single();
      return WaterPointDto.fromJson(response);
    }, fallbackMessage: 'Unable to save water point.');
    return _mapResult(result);
  }

  @override
  Future<Result<void>> softDeleteWaterPoint(String id) {
    return guard<void>('Deactivate water point', () async {
      await _client.from(_table).update(<String, dynamic>{'is_active': false}).eq('id', id);
    }, fallbackMessage: 'Unable to delete water point.');
  }

  @override
  Future<Result<List<WaterPoint>>> searchWaterPoints(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return getWaterPoints();
    final result = await guard<List<WaterPointDto>>('Search water points', () async {
      final escaped = _escapeSearchTerm(trimmed);
      final response = await _client.from(_table).select().eq('is_active', true)
          .ilike('name', '%$escaped%').order('name', ascending: true);
      return _mapList(response);
    }, fallbackMessage: 'Unable to search water points.');
    return _mapListResult(result);
  }

  Future<Result<void>> _ensureNameIsUnique(String name, {String? locationId, String? excludeId}) {
    return guard<void>('Validate unique water point name', () async {
      var query = _client.from(_table).select('id, name').eq('is_active', true).ilike('name', name);
      if (locationId != null) query = query.eq('location_id', locationId);
      final response = await query;
      final duplicates = _mapRawList(response).where((row) => row['id'] != excludeId);
      if (duplicates.isNotEmpty) {
        throw const ValidationFailure(message: 'A water point with this name already exists in this location.');
      }
    }, fallbackMessage: 'Unable to validate water point name.');
  }

  Map<String, dynamic> _inputToJson(WaterPointInput input) {
    return <String, dynamic>{
      'name': input.waterPointName,
      'location_id': MasterValidators.blankToNull(input.locationId),
      'notes': MasterValidators.blankToNull(input.notes),
      'is_active': true,
    };
  }

  Result<WaterPoint> _mapResult(Result<WaterPointDto> result) => result.when(success: (dto) => Success<WaterPoint>(WaterPointMapper.toDomain(dto)), failure: Failure<WaterPoint>.new);
  Result<List<WaterPoint>> _mapListResult(Result<List<WaterPointDto>> result) => result.when(success: (dtos) => Success<List<WaterPoint>>(WaterPointMapper.toDomainList(dtos)), failure: Failure<List<WaterPoint>>.new);
  List<WaterPointDto> _mapList(dynamic response) => _mapRawList(response).map(WaterPointDto.fromJson).toList(growable: false);
  List<Map<String, dynamic>> _mapRawList(dynamic response) => (response as List<dynamic>).cast<Map<String, dynamic>>().toList(growable: false);
  String _escapeSearchTerm(String value) => value.replaceAll('%', r'\%').replaceAll('_', r'\_');
}
