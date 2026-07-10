import '../../../core/application/application_service.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/result/result.dart';
import '../domain/water_point_input.dart';

class WaterPointValidationService extends ApplicationService {
  const WaterPointValidationService();

  Result<WaterPointInput> validateForSave(WaterPointInput input) {
    final normalized = input.trimmed();
    if (normalized.waterPointName.isEmpty) {
      return const Failure<WaterPointInput>(ValidationFailure(message: 'Water point name is required.'));
    }
    return Success<WaterPointInput>(normalized);
  }
}
