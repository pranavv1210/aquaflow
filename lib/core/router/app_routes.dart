class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String home = '/home';
  static const String orders = '/orders';
  static const String newOrder = '/orders/new';
  static const String orderDetails = '/orders/details';
  static const String analytics = '/analytics';
  static const String masters = '/masters';
  static const String customers = '/customers';
  static const String customerProfile = '/customers/profile';
  static const String customerForm = '/customers/form';
  static const String drivers = '/drivers';
  static const String driverProfile = '/drivers/profile';
  static const String driverForm = '/drivers/form';
  static const String vehicles = '/vehicles';
  static const String vehicleDetails = '/vehicles/details';
  static const String vehicleForm = '/vehicles/form';
  static const String locations = '/locations';
  static const String locationProfile = '/locations/profile';
  static const String locationForm = '/locations/form';
  static const String waterPoints = '/water-points';
  static const String waterPointProfile = '/water-points/profile';
  static const String waterPointForm = '/water-points/form';
  static const String partnerTankers = '/partner-tankers';
  static const String partnerTankerProfile = '/partner-tankers/profile';
  static const String partnerTankerForm = '/partner-tankers/form';
  static const String expenseCategories = '/expense-categories';
  static const String expenseCategoryProfile = '/expense-categories/profile';
  static const String expenseCategoryForm = '/expense-categories/form';
  static const String expenses = '/expenses';
  static const String expenseDetails = '/expenses/details';
  static const String expenseForm = '/expenses/form';
  static const String partners = '/partners';
  static const String pendingPayments = '/payments/pending';
  static const String globalSearch = '/search';
  static const String settings = '/settings';
  static const String more = '/more';

  static String customerProfilePath(String customerId) {
    return '$customerProfile/$customerId';
  }

  static String editCustomerPath(String customerId) {
    return '$customerForm/$customerId';
  }

  static String driverProfilePath(String driverId) {
    return '$driverProfile/$driverId';
  }

  static String editDriverPath(String driverId) {
    return '$driverForm/$driverId';
  }

  static String vehicleDetailsPath(String vehicleId) {
    return '$vehicleDetails/$vehicleId';
  }

  static String editVehiclePath(String vehicleId) {
    return '$vehicleForm/$vehicleId';
  }

  static String locationProfilePath(String locationId) {
    return '$locationProfile/$locationId';
  }

  static String editLocationPath(String locationId) {
    return '$locationForm/$locationId';
  }

  static String waterPointProfilePath(String waterPointId) {
    return '$waterPointProfile/$waterPointId';
  }

  static String editWaterPointPath(String waterPointId) {
    return '$waterPointForm/$waterPointId';
  }

  static String partnerTankerProfilePath(String partnerTankerId) {
    return '$partnerTankerProfile/$partnerTankerId';
  }

  static String editPartnerTankerPath(String partnerTankerId) {
    return '$partnerTankerForm/$partnerTankerId';
  }

  static String expenseCategoryProfilePath(String expenseCategoryId) {
    return '$expenseCategoryProfile/$expenseCategoryId';
  }

  static String editExpenseCategoryPath(String expenseCategoryId) {
    return '$expenseCategoryForm/$expenseCategoryId';
  }

  static String expenseDetailsPath(String expenseId) {
    return '$expenseDetails/$expenseId';
  }

  static String editExpensePath(String expenseId) {
    return '$expenseForm/$expenseId';
  }

  static String orderDetailsPath(String orderId) {
    return '$orderDetails/$orderId';
  }

  static String editOrderPath(String orderId) {
    return '$newOrder/$orderId';
  }
}
