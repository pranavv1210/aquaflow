class DomainValidationRules {
  const DomainValidationRules._();

  static const String customerNameRequired = 'Customer name is required.';
  static const String orderDateRequired = 'Order date is required.';
  static const String orderTimeRequired = 'Order time is required.';
  static const String amountMustBePositive = 'Amount must be greater than 0.';
  static const String loadCountMinimum = 'Load count must be at least 1.';
  static const String vehicleOrPartnerRequired =
      'Select either an own vehicle or a partner tanker.';
  static const String vehicleOptionalWhenPartnerSelected =
      'Own vehicle is optional only when a partner tanker is selected.';
  static const String partnerOptionalWhenOwnVehicleSelected =
      'Partner tanker is optional only when an own vehicle is selected.';
  static const String phoneOptional = 'Phone number is optional.';
  static const String remarksOptional = 'Remarks are optional.';
}
