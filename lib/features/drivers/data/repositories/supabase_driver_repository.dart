import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/models/driver.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../../../core/result/result.dart';
import '../../../../core/shared/masters/master_validators.dart';
import '../../domain/driver_input.dart';
import '../../domain/repositories/driver_repository.dart';
import '../dto/driver_dto.dart';
import '../mappers/driver_mapper.dart';

class SupabaseDriverRepository extends BaseRepository
    implements DriverRepository {
  SupabaseDriverRepository(this._client);

  final SupabaseClient _client;

  static const String _table = 'drivers';

  @override
  Future<Result<List<Driver>>> getDrivers() async {
    final result = await guard<List<DriverDto>>('Load drivers', () async {
      final response = await _client
          .from(_table)
          .select()
          .eq('is_active', true)
          .order('driver_name', ascending: true);
      return _mapList(response);
    }, fallbackMessage: 'Unable to load drivers.');
    return _mapListResult(result);
  }

  @override
  Future<Result<Driver>> getDriverById(String id) async {
    final result = await guard<DriverDto>('Load driver', () async {
      final response =
          await _client.from(_table).select().eq('id', id).maybeSingle();
      if (response == null) {
        throw const DatabaseFailure(message: 'Driver not found.');
      }
      return DriverDto.fromJson(response);
    }, fallbackMessage: 'Unable to load driver.');
    return _mapResult(result);
  }

  @override
  Future<Result<Driver>> createDriver(DriverInput input) async {
    final result = await guard<DriverDto>('Create driver', () async {
      final response =
          await _client
              .from(_table)
              .insert(_inputToJson(input))
              .select()
              .single();
      return DriverDto.fromJson(response);
    }, fallbackMessage: 'Unable to save driver.');
    return _mapResult(result);
  }

  @override
  Future<Result<Driver>> updateDriver(String id, DriverInput input) async {
    final result = await guard<DriverDto>('Update driver', () async {
      final response =
          await _client
              .from(_table)
              .update(_inputToJson(input))
              .eq('id', id)
              .select()
              .single();
      return DriverDto.fromJson(response);
    }, fallbackMessage: 'Unable to save driver.');
    return _mapResult(result);
  }

  @override
  Future<Result<void>> softDeleteDriver(String id) {
    return guard<void>('Deactivate driver', () async {
      await _client
          .from(_table)
          .update(<String, dynamic>{'is_active': false})
          .eq('id', id);
    }, fallbackMessage: 'Unable to delete driver.');
  }

  @override
  Future<Result<List<Driver>>> searchDrivers(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return getDrivers();
    }

    final result = await guard<List<DriverDto>>('Search drivers', () async {
      final escaped = _escapeSearchTerm(trimmed);
      final response = await _client
          .from(_table)
          .select()
          .eq('is_active', true)
          .or('driver_name.ilike.%$escaped%,phone.ilike.%$escaped%')
          .order('driver_name', ascending: true);
      return _mapList(response);
    }, fallbackMessage: 'Unable to search drivers.');
    return _mapListResult(result);
  }

  Map<String, dynamic> _inputToJson(DriverInput input) {
    return <String, dynamic>{
      'driver_name': input.driverName,
      'phone': MasterValidators.blankToNull(input.phone),
      'status': input.status,
      'notes': MasterValidators.blankToNull(input.notes),
      'is_active': true,
    };
  }

  Result<Driver> _mapResult(Result<DriverDto> result) {
    return result.when(
      success: (DriverDto dto) {
        return Success<Driver>(DriverMapper.toDomain(dto));
      },
      failure: Failure<Driver>.new,
    );
  }

  Result<List<Driver>> _mapListResult(Result<List<DriverDto>> result) {
    return result.when(
      success: (List<DriverDto> dtos) {
        return Success<List<Driver>>(DriverMapper.toDomainList(dtos));
      },
      failure: Failure<List<Driver>>.new,
    );
  }

  List<DriverDto> _mapList(dynamic response) {
    return _mapRawList(response)
        .map(DriverDto.fromJson)
        .toList(growable: false);
  }

  List<Map<String, dynamic>> _mapRawList(dynamic response) {
    return (response as List<dynamic>).cast<Map<String, dynamic>>().toList(
      growable: false,
    );
  }

  String _escapeSearchTerm(String value) {
    return value.replaceAll('%', r'\%').replaceAll('_', r'\_');
  }
}