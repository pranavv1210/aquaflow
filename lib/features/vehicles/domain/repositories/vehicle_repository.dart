import '../../../../core/models/vehicle.dart';
import '../../../../core/result/result.dart';
import '../vehicle_input.dart';

abstract interface class VehicleRepository {
  Future<Result<List<Vehicle>>> getVehicles();

  Future<Result<Vehicle>> getVehicleById(String id);

  Future<Result<Vehicle>> createVehicle(VehicleInput input);

  Future<Result<Vehicle>> updateVehicle(String id, VehicleInput input);

  Future<Result<void>> softDeleteVehicle(String id);

  Future<Result<List<Vehicle>>> searchVehicles(String query);
}