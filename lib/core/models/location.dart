class Location {
  const Location({
    required this.id,
    required this.locationName,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
  });

  final String id;
  final String locationName;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
}