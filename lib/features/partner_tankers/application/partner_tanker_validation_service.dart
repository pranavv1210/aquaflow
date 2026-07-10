import '../../../core/application/application_service.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/result/result.dart';
import '../domain/partner_tanker_input.dart';

class PartnerTankerValidationService extends ApplicationService {
  const PartnerTankerValidationService();

  Result<PartnerTankerInput> validateForSave(PartnerTankerInput input) {
    final normalized = input.trimmed();
    if (normalized.ownerName.isEmpty) return const Failure<PartnerTankerInput>(ValidationFailure(message: 'Owner name is required.'));
    if (normalized.vehicleName.isEmpty) return const Failure<PartnerTankerInput>(ValidationFailure(message: 'Vehicle name is required.'));
    if (normalized.registrationNumber.isEmpty) return const Failure<PartnerTankerInput>(ValidationFailure(message: 'Registration number is required.'));
    return Success<PartnerTankerInput>(normalized);
  }
}
