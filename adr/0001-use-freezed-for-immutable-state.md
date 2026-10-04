# ADR 0001: Use Freezed for Immutable State and Data Classes

## Context
LastSpot is currently using `equatable` for value equality in BLoC states and Data Models. However, as the app grows, manually writing `copyWith` methods, ensuring exhaustive `switch` cases for complex states, and handling JSON serialization logic becomes highly error-prone and tedious.

## Decision
We will adopt the **`freezed`** and **`freezed_annotation`** packages for all new models, entities, and BLoC/Cubit states.

1. **State Paradigm**: All BLoC states will be defined as `@freezed` unions.
2. **Data Classes**: All models and entities will be defined as `@freezed` classes with generated `copyWith` and `toJson`/`fromJson` methods (paired with `json_serializable`).
3. **Migration Strategy**: We will incrementally refactor existing `Equatable` classes (like `AuthCubit` state and `PushNotificationService` models) as they are modified.

## DEP-1 Justification
- **Package**: `freezed` / `freezed_annotation`
- **Why**: Eliminates boilerplate for `copyWith`, enforces exhaustive pattern matching for UI states, and guarantees true immutability.
- **Alternatives Considered**: 
  - `equatable` (Current): Lacks generated `copyWith` and exhaustive pattern matching.
  - `built_value`: More verbose syntax and slower generator.
- **Impact**: Adds a build-step requirement (`build_runner`), but significantly reduces runtime bugs related to state mutation and forgotten switch cases.

## Status
Proposed

## Consequences
- Developers must run `fvm dart run build_runner build -d` after modifying state or model files.
- Boilerplate is drastically reduced in exchange for generated `.freezed.dart` files.
