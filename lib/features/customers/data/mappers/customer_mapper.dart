import '../../../../core/models/customer.dart';
import '../../../../core/models/value_objects.dart';
import '../dto/customer_dto.dart';

class CustomerMapper {
  const CustomerMapper._();

  static Customer toDomain(CustomerDto dto) {
    return Customer(
      id: dto.id,
      displayName: dto.displayName,
      phoneNumber: dto.phone == null ? null : PhoneNumber(dto.phone!),
      defaultLocationId: dto.defaultLocationId,
      address: dto.address,
      notes: dto.notes,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  static List<Customer> toDomainList(List<CustomerDto> dtos) {
    return dtos.map(toDomain).toList(growable: false);
  }
}
