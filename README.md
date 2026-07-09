# AquaFlow

Production-grade Android application foundation for a water tanker business.

## Phase 0 Scope

- Feature-first Flutter architecture
- Riverpod application providers
- GoRouter navigation shell
- Supabase initialization through Dart environment defines
- Material 3 design system with reusable tokens and widgets
- Placeholder pages only; no CRUD, database tables, analytics, or business logic

## Running Locally

```powershell
flutter pub get
flutter run --dart-define=SUPABASE_URL=your-url --dart-define=SUPABASE_ANON_KEY=your-key
```

The app can run without Supabase defines during foundation development. In that case Supabase initialization is skipped and a warning is logged.
