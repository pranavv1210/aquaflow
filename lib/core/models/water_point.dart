class WaterPoint {
  const WaterPoint({
    required this.id,
    required this.waterPointName,
    this.locationId,
    this.notes,
  });

  final String id;
  final String waterPointName;
  final String? locationId;
  final String? notes;
}
