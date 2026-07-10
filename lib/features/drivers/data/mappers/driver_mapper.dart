import '../../../../core/models/driver.dart';
import '../../../../core/models/domain_enums.dart';
import '../../../../core/models/value_objects.dart';
import '../dto/driver_dto.dart';

class DriverMapper {
  const DriverMapper._();

  static Driver toDomain(DriverDto dto) {
    return Driver(
      id: dto.id,
      driverName: dto.driverName,
      phone: dto.phone == null ? null : PhoneNumber(dto.phone!),
      status: _parseStatus(dto.status),
      notes: dto.notes,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  static List<Driver> toDomainList(List<DriverDto> dtos) {
    return dtos.map(toDomain).toList(growable: false);
  }

  static DriverStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'busy':
        return DriverStatus.busy;
      case 'inactive':
        return DriverStatus.inactive;
      default:
        return DriverStatus.available;
    }
  }

  static String statusToDb(DriverStatus status) {
    return status.name;
  }
}