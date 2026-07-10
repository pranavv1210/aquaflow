import '../../../../core/models/location.dart';
import '../../../../core/result/result.dart';
import '../location_input.dart';

abstract interface class LocationRepository {
  Future<Result<List<Location>>> getLocations();
  Future<Result<Location>> getLocationById(String id);
  Future<Result<Location>> createLocation(LocationInput input);
  Future<Result<Location>> updateLocation(String id, LocationInput input);
  Future<Result<void>> softDeleteLocation(String id);
  Future<Result<List<Location>>> searchLocations(String query);
}
