import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/models/partner_tanker.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../../../core/result/result.dart';
import '../../../../core/shared/masters/master_validators.dart';
import '../../domain/partner_tanker_input.dart';
import '../../domain/repositories/partner_tanker_repository.dart';
import '../dto/partner_tanker_dto.dart';
import '../mappers/partner_tanker_mapper.dart';

class SupabasePartnerTankerRepository extends BaseRepository
    implements PartnerTankerRepository {
  SupabasePartnerTankerRepository(this._client);
  final SupabaseClient _client;
  static const String _table = 'partner_tankers';

  @override
  Future<Result<List<PartnerTanker>>> getPartnerTankers() async {
    final result = await guard<List<PartnerTankerDto>>(
      'Load partner tankers',
      () async {
        final response = await _client
            .from(_table)
            .select()
            .eq('is_active', true)
            .order('owner_name', ascending: true);
        return _mapList(response);
      },
      fallbackMessage: 'Unable to load partner tankers.',
    );
    return _mapListResult(result);
  }

  @override
  Future<Result<PartnerTanker>> getPartnerTankerById(String id) async {
    final result = await guard<PartnerTankerDto>(
      'Load partner tanker',
      () async {
        final response =
            await _client.from(_table).select().eq('id', id).maybeSingle();
        if (response == null) {
          throw const DatabaseFailure(message: 'Partner tanker not found.');
        }
        return PartnerTankerDto.fromJson(response);
      },
      fallbackMessage: 'Unable to load partner tanker.',
    );
    return _mapResult(result);
  }

  @override
  Future<Result<PartnerTanker>> createPartnerTanker(
    PartnerTankerInput input,
  ) async {
    final unique = await _ensureRegistrationIsUnique(input.registrationNumber);
    if (unique case Failure<void> failure) {
      return Failure<PartnerTanker>(failure.failure);
    }
    final result = await guard<PartnerTankerDto>(
      'Create partner tanker',
      () async {
        final response =
            await _client
                .from(_table)
                .insert(_inputToJson(input))
                .select()
                .single();
        return PartnerTankerDto.fromJson(response);
      },
      fallbackMessage: 'Unable to save partner tanker.',
    );
    return _mapResult(result);
  }

  @override
  Future<Result<PartnerTanker>> updatePartnerTanker(
    String id,
    PartnerTankerInput input,
  ) async {
    final unique = await _ensureRegistrationIsUnique(
      input.registrationNumber,
      excludeId: id,
    );
    if (unique case Failure<void> failure) {
      return Failure<PartnerTanker>(failure.failure);
    }
    final result = await guard<PartnerTankerDto>(
      'Update partner tanker',
      () async {
        final response =
            await _client
                .from(_table)
                .update(_inputToJson(input))
                .eq('id', id)
                .select()
                .single();
        return PartnerTankerDto.fromJson(response);
      },
      fallbackMessage: 'Unable to save partner tanker.',
    );
    return _mapResult(result);
  }

  @override
  Future<Result<void>> softDeletePartnerTanker(String id) {
    return guard<void>(
      'Deactivate partner tanker',
      () async {
        await _client
            .from(_table)
            .update(<String, dynamic>{'is_active': false})
            .eq('id', id);
      },
      fallbackMessage: 'Unable to delete partner tanker.',
    );
  }

  @override
  Future<Result<List<PartnerTanker>>> searchPartnerTankers(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return getPartnerTankers();
    }
    final result = await guard<List<PartnerTankerDto>>(
      'Search partner tankers',
      () async {
        final escaped = _escapeSearchTerm(trimmed);
        final response = await _client
            .from(_table)
            .select()
            .eq('is_active', true)
            .or(
              'owner_name.ilike.%$escaped%,vehicle_name.ilike.%$escaped%,phone.ilike.%$escaped%,registration_number.ilike.%$escaped%',
            )
            .order('owner_name', ascending: true);
        return _mapList(response);
      },
      fallbackMessage: 'Unable to search partner tankers.',
    );
    return _mapListResult(result);
  }

  Future<Result<void>> _ensureRegistrationIsUnique(
    String reg, {
    String? excludeId,
  }) {
    return guard<void>(
      'Validate unique registration',
      () async {
        final response = await _client
            .from(_table)
            .select('id, registration_number')
            .eq('is_active', true)
            .ilike('registration_number', reg);
        final duplicates = _mapRawList(
          response,
        ).where((row) => row['id'] != excludeId);
        if (duplicates.isNotEmpty) {
          throw const ValidationFailure(
            message:
                'A partner tanker with this registration number already exists.',
          );
        }
      },
      fallbackMessage: 'Unable to validate registration number.',
    );
  }

  Map<String, dynamic> _inputToJson(PartnerTankerInput input) =>
      <String, dynamic>{
        'owner_name': input.ownerName,
        'vehicle_name': input.vehicleName,
        'registration_number': input.registrationNumber,
        'phone': MasterValidators.blankToNull(input.phone),
        'notes': MasterValidators.blankToNull(input.notes),
        'is_active': true,
      };

  Result<PartnerTanker> _mapResult(Result<PartnerTankerDto> r) => r.when(
    success: (d) => Success<PartnerTanker>(PartnerTankerMapper.toDomain(d)),
    failure: Failure<PartnerTanker>.new,
  );
  Result<List<PartnerTanker>> _mapListResult(
    Result<List<PartnerTankerDto>> r,
  ) => r.when(
    success:
        (d) =>
            Success<List<PartnerTanker>>(PartnerTankerMapper.toDomainList(d)),
    failure: Failure<List<PartnerTanker>>.new,
  );
  List<PartnerTankerDto> _mapList(dynamic r) =>
      _mapRawList(r).map(PartnerTankerDto.fromJson).toList(growable: false);
  List<Map<String, dynamic>> _mapRawList(dynamic r) =>
      (r as List<dynamic>).cast<Map<String, dynamic>>().toList(growable: false);
  String _escapeSearchTerm(String v) =>
      v.replaceAll('%', r'\%').replaceAll('_', r'\_');
}
