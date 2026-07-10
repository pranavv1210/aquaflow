import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/models/customer.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../../../core/result/result.dart';
import '../../../../core/shared/masters/master_validators.dart';
import '../../domain/customer_input.dart';
import '../../domain/repositories/customer_repository.dart';
import '../dto/customer_dto.dart';
import '../mappers/customer_mapper.dart';

class SupabaseCustomerRepository extends BaseRepository
    implements CustomerRepository {
  SupabaseCustomerRepository(this._client);

  final SupabaseClient _client;

  static const String _table = 'customers';

  @override
  Future<Result<List<Customer>>> getCustomers() async {
    final result = await guard<List<CustomerDto>>('Load customers', () async {
      final response = await _client
          .from(_table)
          .select()
          .eq('is_active', true)
          .order('display_name', ascending: true);
      return _mapList(response);
    }, fallbackMessage: 'Unable to load customers.');
    return _mapListResult(result);
  }

  @override
  Future<Result<Customer>> getCustomerById(String id) async {
    final result = await guard<CustomerDto>('Load customer', () async {
      final response =
          await _client.from(_table).select().eq('id', id).maybeSingle();
      if (response == null) {
        throw const DatabaseFailure(message: 'Customer not found.');
      }
      return CustomerDto.fromJson(response);
    }, fallbackMessage: 'Unable to load customer.');
    return _mapResult(result);
  }

  @override
  Future<Result<Customer>> createCustomer(CustomerInput input) async {
    final unique = await _ensureNameIsUnique(input.displayName);
    if (unique case Failure<void> failure) {
      return Failure<Customer>(failure.failure);
    }

    final result = await guard<CustomerDto>('Create customer', () async {
      final response =
          await _client
              .from(_table)
              .insert(_inputToJson(input))
              .select()
              .single();
      return CustomerDto.fromJson(response);
    }, fallbackMessage: 'Unable to save customer.');
    return _mapResult(result);
  }

  @override
  Future<Result<Customer>> updateCustomer(
    String id,
    CustomerInput input,
  ) async {
    final unique = await _ensureNameIsUnique(input.displayName, excludeId: id);
    if (unique case Failure<void> failure) {
      return Failure<Customer>(failure.failure);
    }

    final result = await guard<CustomerDto>('Update customer', () async {
      final response =
          await _client
              .from(_table)
              .update(_inputToJson(input))
              .eq('id', id)
              .select()
              .single();
      return CustomerDto.fromJson(response);
    }, fallbackMessage: 'Unable to save customer.');
    return _mapResult(result);
  }

  @override
  Future<Result<void>> softDeleteCustomer(String id) {
    return guard<void>('Deactivate customer', () async {
      await _client
          .from(_table)
          .update(<String, dynamic>{'is_active': false})
          .eq('id', id);
    }, fallbackMessage: 'Unable to delete customer.');
  }

  @override
  Future<Result<List<Customer>>> searchCustomers(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return getCustomers();
    }

    final result = await guard<List<CustomerDto>>('Search customers', () async {
      final escaped = _escapeSearchTerm(trimmed);
      final response = await _client
          .from(_table)
          .select()
          .eq('is_active', true)
          .or('display_name.ilike.%$escaped%,phone.ilike.%$escaped%')
          .order('display_name', ascending: true);
      return _mapList(response);
    }, fallbackMessage: 'Unable to search customers.');
    return _mapListResult(result);
  }

  @override
  Future<Result<List<Customer>>> getCustomersByLocation(
    String locationId,
  ) async {
    final result = await guard<List<CustomerDto>>(
      'Load customers by location',
      () async {
        final response = await _client
            .from(_table)
            .select()
            .eq('is_active', true)
            .eq('default_location_id', locationId)
            .order('display_name', ascending: true);
        return _mapList(response);
      },
      fallbackMessage: 'Unable to load customers.',
    );
    return _mapListResult(result);
  }

  Future<Result<void>> _ensureNameIsUnique(
    String displayName, {
    String? excludeId,
  }) {
    return guard<void>(
      'Validate unique customer name',
      () async {
        final response = await _client
            .from(_table)
            .select('id, display_name')
            .eq('is_active', true)
            .ilike('display_name', displayName);

        final duplicates = _mapRawList(response).where((
          Map<String, dynamic> row,
        ) {
          return row['id'] != excludeId;
        });

        if (duplicates.isNotEmpty) {
          throw const ValidationFailure(
            message: 'An active customer with this name already exists.',
          );
        }
      },
      fallbackMessage: 'Unable to validate customer name.',
    );
  }

  Map<String, dynamic> _inputToJson(CustomerInput input) {
    return <String, dynamic>{
      'display_name': input.displayName,
      'phone': MasterValidators.blankToNull(input.phone),
      'default_location_id': MasterValidators.blankToNull(
        input.defaultLocationId,
      ),
      'address': MasterValidators.blankToNull(input.address),
      'notes': MasterValidators.blankToNull(input.notes),
      'is_active': true,
    };
  }

  Result<Customer> _mapResult(Result<CustomerDto> result) {
    return result.when(
      success: (CustomerDto dto) {
        return Success<Customer>(CustomerMapper.toDomain(dto));
      },
      failure: Failure<Customer>.new,
    );
  }

  Result<List<Customer>> _mapListResult(Result<List<CustomerDto>> result) {
    return result.when(
      success: (List<CustomerDto> dtos) {
        return Success<List<Customer>>(CustomerMapper.toDomainList(dtos));
      },
      failure: Failure<List<Customer>>.new,
    );
  }

  List<CustomerDto> _mapList(dynamic response) {
    return _mapRawList(
      response,
    ).map(CustomerDto.fromJson).toList(growable: false);
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
