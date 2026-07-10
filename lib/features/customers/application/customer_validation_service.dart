import '../../../core/application/application_service.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/result/result.dart';
import '../domain/customer_input.dart';

class CustomerValidationService extends ApplicationService {
  const CustomerValidationService();

  Result<CustomerInput> validateForSave(CustomerInput input) {
    final normalized = input.trimmed();
    if (normalized.displayName.isEmpty) {
      return const Failure<CustomerInput>(
        ValidationFailure(message: 'Customer name is required.'),
      );
    }
    return Success<CustomerInput>(normalized);
  }
}
