import '../../../../core/models/vehicle.dart';
import '../../../../core/models/domain_enums.dart';
import '../dto/vehicle_dto.dart';

class VehicleMapper {
  const VehicleMapper._();

  static Vehicle toDomain(VehicleDto dto) {
    return Vehicle(
      id: dto.id,
      vehicleName: dto.vehicleName,
      registrationNumber: dto.registrationNumber,
      vehicleType: _parseVehicleType(dto.vehicleType),
      status: _parseStatus(dto.status),
      notes: dto.notes,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  static List<Vehicle> toDomainList(List<VehicleDto> dtos) {
    return dtos.map(toDomain).toList(growable: false);
  }

  static VehicleType _parseVehicleType(String type) {
    switch (type.toLowerCase()) {
      case 'canter':
        return VehicleType.canter;
      case 'partner':
        return VehicleType.partner;
      default:
        return VehicleType.tractor;
    }
  }

  static VehicleStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'busy':
        return VehicleStatus.busy;
      case 'inactive':
        return VehicleStatus.inactive;
      default:
        return VehicleStatus.available;
    }
  }

  static String typeToDb(VehicleType type) => type.name;
  static String statusToDb(VehicleStatus status) => status.name;
}