import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/models/location.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../../../core/result/result.dart';
import '../../../../core/shared/masters/master_validators.dart';
import '../../domain/location_input.dart';
import '../../domain/repositories/location_repository.dart';
import '../dto/location_dto.dart';
import '../mappers/location_mapper.dart';

class SupabaseLocationRepository extends BaseRepository
    implements LocationRepository {
  SupabaseLocationRepository(this._client);
  final SupabaseClient _client;
  static const String _table = 'locations';

  @override
  Future<Result<List<Location>>> getLocations() async {
    final result = await guard<List<LocationDto>>('Load locations', () async {
      final response = await _client
          .from(_table).select().eq('is_active', true).order('name', ascending: true);
      return _mapList(response);
    }, fallbackMessage: 'Unable to load locations.');
    return _mapListResult(result);
  }

  @override
  Future<Result<Location>> getLocationById(String id) async {
    final result = await guard<LocationDto>('Load location', () async {
      final response = await _client.from(_table).select().eq('id', id).maybeSingle();
      if (response == null) throw const DatabaseFailure(message: 'Location not found.');
      return LocationDto.fromJson(response);
    }, fallbackMessage: 'Unable to load location.');
    return _mapResult(result);
  }

  @override
  Future<Result<Location>> createLocation(LocationInput input) async {
    final unique = await _ensureNameIsUnique(input.locationName);
    if (unique case Failure<void> failure) return Failure<Location>(failure.failure);
    final result = await guard<LocationDto>('Create location', () async {
      final response = await _client.from(_table).insert(_inputToJson(input)).select().single();
      return LocationDto.fromJson(response);
    }, fallbackMessage: 'Unable to save location.');
    return _mapResult(result);
  }

  @override
  Future<Result<Location>> updateLocation(String id, LocationInput input) async {
    final unique = await _ensureNameIsUnique(input.locationName, excludeId: id);
    if (unique case Failure<void> failure) return Failure<Location>(failure.failure);
    final result = await guard<LocationDto>('Update location', () async {
      final response = await _client.from(_table).update(_inputToJson(input)).eq('id', id).select().single();
      return LocationDto.fromJson(response);
    }, fallbackMessage: 'Unable to save location.');
    return _mapResult(result);
  }

  @override
  Future<Result<void>> softDeleteLocation(String id) {
    return guard<void>('Deactivate location', () async {
      await _client.from(_table).update(<String, dynamic>{'is_active': false}).eq('id', id);
    }, fallbackMessage: 'Unable to delete location.');
  }

  @override
  Future<Result<List<Location>>> searchLocations(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return getLocations();
    final result = await guard<List<LocationDto>>('Search locations', () async {
      final escaped = _escapeSearchTerm(trimmed);
      final response = await _client
          .from(_table).select().eq('is_active', true)
          .ilike('name', '%$escaped%')
          .order('name', ascending: true);
      return _mapList(response);
    }, fallbackMessage: 'Unable to search locations.');
    return _mapListResult(result);
  }

  Future<Result<void>> _ensureNameIsUnique(String name, {String? excludeId}) {
    return guard<void>('Validate unique location name', () async {
      final response = await _client
          .from(_table).select('id, name').eq('is_active', true).ilike('name', name);
      final duplicates = _mapRawList(response).where((row) => row['id'] != excludeId);
      if (duplicates.isNotEmpty) {
        throw const ValidationFailure(message: 'An active location with this name already exists.');
      }
    }, fallbackMessage: 'Unable to validate location name.');
  }

  Map<String, dynamic> _inputToJson(LocationInput input) {
    return <String, dynamic>{
      'name': input.locationName,
      'notes': MasterValidators.blankToNull(input.notes),
      'is_active': true,
    };
  }

  Result<Location> _mapResult(Result<LocationDto> result) {
    return result.when(
      success: (LocationDto dto) => Success<Location>(LocationMapper.toDomain(dto)),
      failure: Failure<Location>.new,
    );
  }

  Result<List<Location>> _mapListResult(Result<List<LocationDto>> result) {
    return result.when(
      success: (List<LocationDto> dtos) => Success<List<Location>>(LocationMapper.toDomainList(dtos)),
      failure: Failure<List<Location>>.new,
    );
  }

  List<LocationDto> _mapList(dynamic response) {
    return _mapRawList(response).map(LocationDto.fromJson).toList(growable: false);
  }

  List<Map<String, dynamic>> _mapRawList(dynamic response) {
    return (response as List<dynamic>).cast<Map<String, dynamic>>().toList(growable: false);
  }

  String _escapeSearchTerm(String value) {
    return value.replaceAll('%', r'\%').replaceAll('_', r'\_');
  }
}
