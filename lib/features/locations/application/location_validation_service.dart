import '../../../core/application/application_service.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/result/result.dart';
import '../domain/location_input.dart';

class LocationValidationService extends ApplicationService {
  const LocationValidationService();

  Result<LocationInput> validateForSave(LocationInput input) {
    final normalized = input.trimmed();
    if (normalized.locationName.isEmpty) {
      return const Failure<LocationInput>(
        ValidationFailure(message: 'Location name is required.'),
      );
    }
    return Success<LocationInput>(normalized);
  }
}
