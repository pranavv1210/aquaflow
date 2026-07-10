import '../../../../core/models/customer.dart';
import '../../../../core/result/result.dart';
import '../customer_input.dart';

abstract interface class CustomerRepository {
  Future<Result<List<Customer>>> getCustomers();

  Future<Result<Customer>> getCustomerById(String id);

  Future<Result<Customer>> createCustomer(CustomerInput input);

  Future<Result<Customer>> updateCustomer(String id, CustomerInput input);

  Future<Result<void>> softDeleteCustomer(String id);

  Future<Result<List<Customer>>> searchCustomers(String query);

  Future<Result<List<Customer>>> getCustomersByLocation(String locationId);
}
