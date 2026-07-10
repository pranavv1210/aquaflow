class SerializationHelpers {
  const SerializationHelpers._();

  static String? stringOrNull(Map<String, dynamic> json, String key) {
    final value = json[key];
    return value is String ? value : null;
  }

  static DateTime dateTime(Map<String, dynamic> json, String key) {
    return DateTime.parse(json[key] as String).toLocal();
  }

  static String? blankToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
