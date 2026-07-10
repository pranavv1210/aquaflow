# AquaFlow

Production-grade Android application for a water tanker business.

## Features (v1.0.0)

- **Feature-first Flutter architecture**: Clean separation of modules (Customers, Drivers, Vehicles, Locations, Water Points, Orders, Expenses).
- **Comprehensive CRUD Operations**: Create, Read, Update, and (Soft) Delete for all core business entities.
- **Realtime Supabase Integration**: Instant synchronization of data across devices.
- **Dynamic Dashboards**: Real-time business metrics including Today's Revenue, Expenses, Profit, and Pending Payments.
- **In-Depth Analytics**: Visual charts for revenue trends, expense breakdowns, vehicle/driver performance, and customer value.
- **Payment Tracking**: Granular tracking for partial payments, fully paid orders, and pending balances.
- **State Management & Navigation**: Robust architecture using Riverpod and GoRouter.
- **Material 3 Design**: Premium, highly responsive, and animated user interface built with reusable tokens and glassmorphism elements.
- **Historical Data Import**: Python-based tool (`tools/import_excel.py`) for seamlessly migrating legacy Excel records into the Supabase backend.

## Running Locally

To run the application locally, ensure you provide the required Supabase environment variables:

```powershell
flutter pub get
flutter run --dart-define=SUPABASE_URL=your-url --dart-define=SUPABASE_ANON_KEY=your-key
```

## Release Build

To build the production APK with tree-shaking and optimizations:

```powershell
flutter build apk --release
```
