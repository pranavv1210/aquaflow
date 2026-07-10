import '../../../../core/models/driver.dart';
import '../../../../core/result/result.dart';
import '../driver_input.dart';

abstract interface class DriverRepository {
  Future<Result<List<Driver>>> getDrivers();

  Future<Result<Driver>> getDriverById(String id);

  Future<Result<Driver>> createDriver(DriverInput input);

  Future<Result<Driver>> updateDriver(String id, DriverInput input);

  Future<Result<void>> softDeleteDriver(String id);

  Future<Result<List<Driver>>> searchDrivers(String query);
}