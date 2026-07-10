import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/models/vehicle.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../../../core/result/result.dart';
import '../../../../core/shared/masters/master_validators.dart';
import '../../domain/vehicle_input.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../dto/vehicle_dto.dart';
import '../mappers/vehicle_mapper.dart';

class SupabaseVehicleRepository extends BaseRepository
    implements VehicleRepository {
  SupabaseVehicleRepository(this._client);

  final SupabaseClient _client;

  static const String _table = 'vehicles';

  @override
  Future<Result<List<Vehicle>>> getVehicles() async {
    final result = await guard<List<VehicleDto>>('Load vehicles', () async {
      final response = await _client
          .from(_table)
          .select()
          .eq('is_active', true)
          .order('vehicle_name', ascending: true);
      return _mapList(response);
    }, fallbackMessage: 'Unable to load vehicles.');
    return _mapListResult(result);
  }

  @override
  Future<Result<Vehicle>> getVehicleById(String id) async {
    final result = await guard<VehicleDto>('Load vehicle', () async {
      final response =
          await _client.from(_table).select().eq('id', id).maybeSingle();
      if (response == null) {
        throw const DatabaseFailure(message: 'Vehicle not found.');
      }
      return VehicleDto.fromJson(response);
    }, fallbackMessage: 'Unable to load vehicle.');
    return _mapResult(result);
  }

  @override
  Future<Result<Vehicle>> createVehicle(VehicleInput input) async {
    final unique =
        await _ensureRegistrationIsUnique(input.registrationNumber);
    if (unique case Failure<void> failure) {
      return Failure<Vehicle>(failure.failure);
    }
    final result = await guard<VehicleDto>('Create vehicle', () async {
      final response =
          await _client
              .from(_table)
              .insert(_inputToJson(input))
              .select()
              .single();
      return VehicleDto.fromJson(response);
    }, fallbackMessage: 'Unable to save vehicle.');
    return _mapResult(result);
  }

  @override
  Future<Result<Vehicle>> updateVehicle(String id, VehicleInput input) async {
    final unique = await _ensureRegistrationIsUnique(
      input.registrationNumber,
      excludeId: id,
    );
    if (unique case Failure<void> failure) {
      return Failure<Vehicle>(failure.failure);
    }
    final result = await guard<VehicleDto>('Update vehicle', () async {
      final response =
          await _client
              .from(_table)
              .update(_inputToJson(input))
              .eq('id', id)
              .select()
              .single();
      return VehicleDto.fromJson(response);
    }, fallbackMessage: 'Unable to save vehicle.');
    return _mapResult(result);
  }

  @override
  Future<Result<void>> softDeleteVehicle(String id) {
    return guard<void>('Deactivate vehicle', () async {
      await _client
          .from(_table)
          .update(<String, dynamic>{'is_active': false})
          .eq('id', id);
    }, fallbackMessage: 'Unable to delete vehicle.');
  }

  @override
  Future<Result<List<Vehicle>>> searchVehicles(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return getVehicles();
    }
    final result =
        await guard<List<VehicleDto>>('Search vehicles', () async {
      final escaped = _escapeSearchTerm(trimmed);
      final response = await _client
          .from(_table)
          .select()
          .eq('is_active', true)
          .or(
            'vehicle_name.ilike.%$escaped%,registration_number.ilike.%$escaped%',
          )
          .order('vehicle_name', ascending: true);
      return _mapList(response);
    }, fallbackMessage: 'Unable to search vehicles.');
    return _mapListResult(result);
  }

  Future<Result<void>> _ensureRegistrationIsUnique(
    String registrationNumber, {
    String? excludeId,
  }) {
    return guard<void>('Validate unique registration', () async {
      final response = await _client
          .from(_table)
          .select('id, registration_number')
          .eq('is_active', true)
          .ilike('registration_number', registrationNumber);
      final duplicates = _mapRawList(response).where((row) {
        return row['id'] != excludeId;
      });
      if (duplicates.isNotEmpty) {
        throw const ValidationFailure(
          message:
              'A vehicle with this registration number already exists.',
        );
      }
    }, fallbackMessage: 'Unable to validate registration number.');
  }

  Map<String, dynamic> _inputToJson(VehicleInput input) {
    return <String, dynamic>{
      'vehicle_name': input.vehicleName,
      'registration_number': input.registrationNumber,
      'vehicle_type': input.vehicleType,
      'status': input.status,
      'notes': MasterValidators.blankToNull(input.notes),
      'is_active': true,
    };
  }

  Result<Vehicle> _mapResult(Result<VehicleDto> result) {
    return result.when(
      success: (VehicleDto dto) =>
          Success<Vehicle>(VehicleMapper.toDomain(dto)),
      failure: Failure<Vehicle>.new,
    );
  }

  Result<List<Vehicle>> _mapListResult(Result<List<VehicleDto>> result) {
    return result.when(
      success: (List<VehicleDto> dtos) =>
          Success<List<Vehicle>>(VehicleMapper.toDomainList(dtos)),
      failure: Failure<List<Vehicle>>.new,
    );
  }

  List<VehicleDto> _mapList(dynamic response) {
    return _mapRawList(response)
        .map(VehicleDto.fromJson)
        .toList(growable: false);
  }

  List<Map<String, dynamic>> _mapRawList(dynamic response) {
    return (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .toList(growable: false);
  }

  String _escapeSearchTerm(String value) {
    return value.replaceAll('%', r'\%').replaceAll('_', r'\_');
  }
}