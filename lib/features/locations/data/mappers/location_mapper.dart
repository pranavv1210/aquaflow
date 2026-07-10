import '../../../../core/models/location.dart';
import '../dto/location_dto.dart';

class LocationMapper {
  const LocationMapper._();

  static Location toDomain(LocationDto dto) {
    return Location(
      id: dto.id,
      locationName: dto.locationName,
      notes: dto.notes,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  static List<Location> toDomainList(List<LocationDto> dtos) {
    return dtos.map(toDomain).toList(growable: false);
  }
}