class MasterValidators {
  const MasterValidators._();

  static String? requiredText(
    String? value, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? optionalPhone(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    final valid = RegExp(r'^[0-9+\-\s()]{7,20}$').hasMatch(trimmed);
    if (!valid) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? positiveAmount(String? value) {
    final parsed = num.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed <= 0) {
      return 'Amount must be greater than 0';
    }
    return null;
  }

  static String normalizeText(String value) => value.trim();

  static String? blankToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
