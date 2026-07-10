import '../../../core/application/application_service.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/result/result.dart';
import '../domain/order_input.dart';

class OrderValidationService extends ApplicationService {
  const OrderValidationService();

  Result<OrderInput> validateForSave(OrderInput input) {
    if (input.customerId.trim().isEmpty) {
      return const Failure<OrderInput>(
        ValidationFailure(message: 'Customer is required.'),
      );
    }
    if (input.locationId.trim().isEmpty) {
      return const Failure<OrderInput>(
        ValidationFailure(message: 'Location is required.'),
      );
    }
    if (input.waterPointId.trim().isEmpty) {
      return const Failure<OrderInput>(
        ValidationFailure(message: 'Water point is required.'),
      );
    }
    if (input.vehicleId.trim().isEmpty) {
      return const Failure<OrderInput>(
        ValidationFailure(message: 'Vehicle is required.'),
      );
    }
    if (input.driverId.trim().isEmpty) {
      return const Failure<OrderInput>(
        ValidationFailure(message: 'Driver is required.'),
      );
    }
    if (input.loadCount < 0) {
      return const Failure<OrderInput>(
        ValidationFailure(message: 'Load count must be 0 or greater.'),
      );
    }
    if (input.amount <= 0) {
      return const Failure<OrderInput>(
        ValidationFailure(message: 'Amount must be greater than 0.'),
      );
    }
    if (input.paidAmount < 0 || input.paidAmount > input.amount) {
      return const Failure<OrderInput>(
        ValidationFailure(message: 'Paid amount cannot exceed amount.'),
      );
    }
    return Success<OrderInput>(input);
  }
}
