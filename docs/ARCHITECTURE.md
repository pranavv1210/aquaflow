# AquaFlow Architecture

AquaFlow follows feature-first Clean Architecture.

## Dependency Flow

Presentation

Application

Domain

Infrastructure

Dependencies point inward. UI depends on application providers and use cases. Use cases depend on domain repository contracts. Supabase implementations live in the data/infrastructure layer and depend on the domain contracts, not the other way around.

## Layers

### Presentation

Flutter pages and widgets render state, collect user input, and trigger application use cases through Riverpod providers.

Presentation must not call Supabase directly. Presentation must not import DTOs.

### Application

The application layer coordinates use cases, validation, navigation abstractions, permissions, configuration, refresh behavior, and shared application services.

Customer examples:

- `GetCustomersUseCase`
- `GetCustomerUseCase`
- `CreateCustomerUseCase`
- `UpdateCustomerUseCase`
- `DeleteCustomerUseCase`
- `SearchCustomersUseCase`
- `RefreshCustomersUseCase`

Business validation belongs here. Widgets may still run simple form validation for immediate UX feedback.

### Domain

The domain layer contains business entities, value objects, inputs, enums, and repository contracts.

Repository contracts return `Result<T>` and never expose Supabase, DTOs, SQL details, or transport objects.

### Infrastructure

The infrastructure layer implements repository contracts using Supabase and maps DTOs to domain entities.

DTOs are private to infrastructure boundaries and should not be passed into UI widgets.

## Use Case Flow

1. Widget receives input.
2. Widget calls a Riverpod use case provider.
3. Use case validates and coordinates the action.
4. Use case calls a domain repository contract.
5. Supabase repository implementation executes the database request.
6. DTO response maps to a domain entity.
7. Result returns to the application layer.
8. UI renders success or failure.

## Result And Failure Handling

Repositories and use cases return `Result<T>`.

Failures are typed:

- `NetworkFailure`
- `DatabaseFailure`
- `ValidationFailure`
- `PermissionFailure`
- `UnknownFailure`

Raw exceptions are mapped inside infrastructure helpers before reaching application or presentation.

## Dependency Injection

All dependencies are provided through Riverpod.

The app config is loaded once at startup and injected through `appConfigProvider`.

Feature dependencies are created through providers:

- Repository provider
- Validation service provider
- Use case providers
- UI state providers

## Navigation

Navigation is wrapped by `NavigationService`.

Widgets should use the service instead of scattering route strings throughout presentation code.

## Environment

The app loads Supabase configuration from `.env` at startup, with dart-define retained as a fallback. Credential values must not be logged.

## Future Modules

Drivers, Vehicles, Partner Tankers, Locations, Water Points, Expense Categories, Orders, Expenses, and Analytics should follow the same flow:

Presentation -> Application Use Case -> Domain Repository Contract -> Supabase Repository Implementation -> DTO Mapper -> Domain Entity.
