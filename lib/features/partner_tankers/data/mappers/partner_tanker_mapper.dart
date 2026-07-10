import '../../../../core/models/partner_tanker.dart';
import '../../../../core/models/value_objects.dart';
import '../dto/partner_tanker_dto.dart';

class PartnerTankerMapper {
  const PartnerTankerMapper._();

  static PartnerTanker toDomain(PartnerTankerDto dto) {
    return PartnerTanker(
      id: dto.id,
      ownerName: dto.ownerName,
      phone: dto.phone == null ? null : PhoneNumber(dto.phone!),
      vehicleName: dto.vehicleName,
      registrationNumber: dto.registrationNumber,
      notes: dto.notes,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  static List<PartnerTanker> toDomainList(List<PartnerTankerDto> dtos) {
    return dtos.map(toDomain).toList(growable: false);
  }
}
