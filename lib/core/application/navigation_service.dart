import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../router/app_routes.dart';

class NavigationService {
  const NavigationService();

  void goToCustomers(BuildContext context) {
    context.go(AppRoutes.customers);
  }

  void goToCustomerForm(BuildContext context) {
    context.go(AppRoutes.customerForm);
  }

  void goToCustomerProfile(BuildContext context, String customerId) {
    context.go(AppRoutes.customerProfilePath(customerId));
  }

  void goToEditCustomer(BuildContext context, String customerId) {
    context.go(AppRoutes.editCustomerPath(customerId));
  }

  void goToDrivers(BuildContext context) {
    context.go(AppRoutes.drivers);
  }

  void goToDriverForm(BuildContext context) {
    context.go(AppRoutes.driverForm);
  }

  void goToDriverProfile(BuildContext context, String driverId) {
    context.go(AppRoutes.driverProfilePath(driverId));
  }

  void goToEditDriver(BuildContext context, String driverId) {
    context.go(AppRoutes.editDriverPath(driverId));
  }

  void goToVehicles(BuildContext context) {
    context.go(AppRoutes.vehicles);
  }

  void goToVehicleForm(BuildContext context) {
    context.go(AppRoutes.vehicleForm);
  }

  void goToVehicleDetails(BuildContext context, String vehicleId) {
    context.go(AppRoutes.vehicleDetailsPath(vehicleId));
  }

  void goToEditVehicle(BuildContext context, String vehicleId) {
    context.go(AppRoutes.editVehiclePath(vehicleId));
  }

  void goToLocations(BuildContext context) {
    context.go(AppRoutes.locations);
  }

  void goToLocationForm(BuildContext context) {
    context.go(AppRoutes.locationForm);
  }

  void goToLocationProfile(BuildContext context, String locationId) {
    context.go(AppRoutes.locationProfilePath(locationId));
  }

  void goToEditLocation(BuildContext context, String locationId) {
    context.go(AppRoutes.editLocationPath(locationId));
  }

  void goToWaterPoints(BuildContext context) {
    context.go(AppRoutes.waterPoints);
  }

  void goToWaterPointForm(BuildContext context) {
    context.go(AppRoutes.waterPointForm);
  }

  void goToWaterPointProfile(BuildContext context, String waterPointId) {
    context.go(AppRoutes.waterPointProfilePath(waterPointId));
  }

  void goToEditWaterPoint(BuildContext context, String waterPointId) {
    context.go(AppRoutes.editWaterPointPath(waterPointId));
  }

  void goToPartnerTankers(BuildContext context) {
    context.go(AppRoutes.partnerTankers);
  }

  void goToPartnerTankerForm(BuildContext context) {
    context.go(AppRoutes.partnerTankerForm);
  }

  void goToPartnerTankerProfile(BuildContext context, String partnerTankerId) {
    context.go(AppRoutes.partnerTankerProfilePath(partnerTankerId));
  }

  void goToEditPartnerTanker(BuildContext context, String partnerTankerId) {
    context.go(AppRoutes.editPartnerTankerPath(partnerTankerId));
  }

  void goToExpenseCategories(BuildContext context) {
    context.go(AppRoutes.expenseCategories);
  }

  void goToExpenseCategoryForm(BuildContext context) {
    context.go(AppRoutes.expenseCategoryForm);
  }

  void goToExpenseCategoryProfile(
    BuildContext context,
    String expenseCategoryId,
  ) {
    context.go(AppRoutes.expenseCategoryProfilePath(expenseCategoryId));
  }

  void goToEditExpenseCategory(BuildContext context, String expenseCategoryId) {
    context.go(AppRoutes.editExpenseCategoryPath(expenseCategoryId));
  }

  void goToExpenses(BuildContext context) {
    context.go(AppRoutes.expenses);
  }

  void goToExpenseForm(BuildContext context) {
    context.go(AppRoutes.expenseForm);
  }

  void goToExpenseDetails(BuildContext context, String expenseId) {
    context.go(AppRoutes.expenseDetailsPath(expenseId));
  }

  void goToEditExpense(BuildContext context, String expenseId) {
    context.go(AppRoutes.editExpensePath(expenseId));
  }
}
