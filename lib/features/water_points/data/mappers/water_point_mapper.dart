import '../../../../core/models/water_point.dart';
import '../dto/water_point_dto.dart';

class WaterPointMapper {
  const WaterPointMapper._();

  static WaterPoint toDomain(WaterPointDto dto) {
    return WaterPoint(
      id: dto.id,
      waterPointName: dto.waterPointName,
      locationId: dto.locationId,
      notes: dto.notes,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  static List<WaterPoint> toDomainList(List<WaterPointDto> dtos) {
    return dtos.map(toDomain).toList(growable: false);
  }
}
