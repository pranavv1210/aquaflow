import 'package:aquaflow/core/models/customer.dart';
import 'package:aquaflow/core/models/domain_enums.dart';
import 'package:aquaflow/core/models/driver.dart';
import 'package:aquaflow/core/models/location.dart';
import 'package:aquaflow/core/models/vehicle.dart';
import 'package:aquaflow/core/models/water_point.dart';
import 'package:aquaflow/core/theme/app_theme.dart';
import 'package:aquaflow/features/customers/application/customer_providers.dart';
import 'package:aquaflow/features/customers/presentation/customer_profile_page.dart';
import 'package:aquaflow/features/drivers/application/driver_providers.dart';
import 'package:aquaflow/features/drivers/presentation/driver_profile_page.dart';
import 'package:aquaflow/features/home/presentation/home_shell.dart';
import 'package:aquaflow/features/locations/application/location_providers.dart';
import 'package:aquaflow/features/locations/presentation/location_profile_page.dart';
import 'package:aquaflow/features/vehicles/application/vehicle_providers.dart';
import 'package:aquaflow/features/vehicles/presentation/vehicle_details_page.dart';
import 'package:aquaflow/features/water_points/application/water_point_providers.dart';
import 'package:aquaflow/features/water_points/presentation/water_point_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('customer profile renders selected customer', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedCustomerProvider(
            'customer-1',
          ).overrideWith((ref) async => _customer),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const HomeShell(
            currentPath: '/customers/profile/customer-1',
            child: CustomerProfilePage(customerId: 'customer-1'),
          ),
        ),
      ),
    );
    await _settleProfile(tester);

    expect(find.text('Test Customer'), findsOneWidget);
  });

  testWidgets('driver profile renders selected driver', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedDriverProvider(
            'driver-1',
          ).overrideWith((ref) async => _driver),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const HomeShell(
            currentPath: '/drivers/profile/driver-1',
            child: DriverProfilePage(driverId: 'driver-1'),
          ),
        ),
      ),
    );
    await _settleProfile(tester);

    expect(find.text('Test Driver'), findsOneWidget);
  });

  testWidgets('vehicle details renders selected vehicle', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedVehicleProvider(
            'vehicle-1',
          ).overrideWith((ref) async => _vehicle),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const HomeShell(
            currentPath: '/vehicles/details/vehicle-1',
            child: VehicleDetailsPage(vehicleId: 'vehicle-1'),
          ),
        ),
      ),
    );
    await _settleProfile(tester);

    expect(find.text('Test Vehicle'), findsOneWidget);
  });

  testWidgets('location profile renders selected location', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedLocationProvider(
            'location-1',
          ).overrideWith((ref) async => _location),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const HomeShell(
            currentPath: '/locations/profile/location-1',
            child: LocationProfilePage(locationId: 'location-1'),
          ),
        ),
      ),
    );
    await _settleProfile(tester);

    expect(find.text('Test Location'), findsOneWidget);
  });

  testWidgets('water point profile renders selected water point', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedWaterPointProvider(
            'water-1',
          ).overrideWith((ref) async => _waterPoint),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const HomeShell(
            currentPath: '/water-points/profile/water-1',
            child: WaterPointProfilePage(waterPointId: 'water-1'),
          ),
        ),
      ),
    );
    await _settleProfile(tester);

    expect(find.text('Test Water Point'), findsOneWidget);
  });
}

Future<void> _settleProfile(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

final _now = DateTime(2026, 7, 11, 9);

final _customer = Customer(
  id: 'customer-1',
  displayName: 'Test Customer',
  createdAt: _now,
  updatedAt: _now,
);

final _driver = Driver(
  id: 'driver-1',
  driverName: 'Test Driver',
  status: DriverStatus.available,
  createdAt: _now,
  updatedAt: _now,
);

final _vehicle = Vehicle(
  id: 'vehicle-1',
  vehicleName: 'Test Vehicle',
  registrationNumber: 'KA01AB1234',
  vehicleType: VehicleType.tractor,
  status: VehicleStatus.available,
  createdAt: _now,
  updatedAt: _now,
);

final _location = Location(
  id: 'location-1',
  locationName: 'Test Location',
  createdAt: _now,
  updatedAt: _now,
);

final _waterPoint = WaterPoint(
  id: 'water-1',
  waterPointName: 'Test Water Point',
  locationId: 'location-1',
  createdAt: _now,
  updatedAt: _now,
);
