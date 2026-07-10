import '../../../../core/models/water_point.dart';
import '../../../../core/result/result.dart';
import '../water_point_input.dart';

abstract interface class WaterPointRepository {
  Future<Result<List<WaterPoint>>> getWaterPoints();
  Future<Result<WaterPoint>> getWaterPointById(String id);
  Future<Result<WaterPoint>> createWaterPoint(WaterPointInput input);
  Future<Result<WaterPoint>> updateWaterPoint(String id, WaterPointInput input);
  Future<Result<void>> softDeleteWaterPoint(String id);
  Future<Result<List<WaterPoint>>> searchWaterPoints(String query);
}
