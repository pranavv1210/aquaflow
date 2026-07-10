class WaterPoint {
  const WaterPoint({
    required this.id,
    required this.waterPointName,
    required this.createdAt,
    required this.updatedAt,
    this.locationId,
    this.notes,
  });

  final String id;
  final String waterPointName;
  final String? locationId;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
}