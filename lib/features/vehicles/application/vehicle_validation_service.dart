import '../../../core/application/application_service.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/result/result.dart';
import '../domain/vehicle_input.dart';

class VehicleValidationService extends ApplicationService {
  const VehicleValidationService();

  Result<VehicleInput> validateForSave(VehicleInput input) {
    final normalized = input.trimmed();
    if (normalized.vehicleName.isEmpty) {
      return const Failure<VehicleInput>(
        ValidationFailure(message: 'Vehicle name is required.'),
      );
    }
    if (normalized.registrationNumber.isEmpty) {
      return const Failure<VehicleInput>(
        ValidationFailure(message: 'Registration number is required.'),
      );
    }
    if (normalized.vehicleType.isEmpty) {
      return const Failure<VehicleInput>(
        ValidationFailure(message: 'Vehicle type is required.'),
      );
    }
    if (normalized.status.isEmpty) {
      return const Failure<VehicleInput>(
        ValidationFailure(message: 'Status is required.'),
      );
    }
    return Success<VehicleInput>(normalized);
  }
}
