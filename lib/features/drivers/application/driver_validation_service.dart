import '../../../core/application/application_service.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/result/result.dart';
import '../domain/driver_input.dart';

class DriverValidationService extends ApplicationService {
  const DriverValidationService();

  Result<DriverInput> validateForSave(DriverInput input) {
    final normalized = input.trimmed();
    if (normalized.driverName.isEmpty) {
      return const Failure<DriverInput>(
        ValidationFailure(message: 'Driver name is required.'),
      );
    }
    if (normalized.status.isEmpty) {
      return const Failure<DriverInput>(
        ValidationFailure(message: 'Status is required.'),
      );
    }
    return Success<DriverInput>(normalized);
  }
}