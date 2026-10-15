# ADR-0002: Dependency Injection via GetIt Service Locator

- **Status:** Accepted
- **Date:** 2026-10-14
- **Decision owner:** Salman Naghori / Tech Lead
- **Classification:** PROJECT-SPECIFIC

## Context

The app requires modular, testable decoupling between presentation, domain, and data layers. Dependencies include Supabase and Firebase singletons, remote data sources, repositories, use cases, and presentation BLoCs/Cubits.

## Problem

Which dependency injection approach should decouple components without exposing the service container directly in the widget build tree?

## Decision

Use `get_it` (^9.2.1) configured centrally in `lib/core/di/service_locator.dart` via `setupServiceLocator()`.

**Resolution Rules:**
- Singletons and factories are registered at app bootstrap in `main.dart`.
- Resolution (`sl<T>()`) is permitted **only** at composition roots:
  - Bootstrap (`main.dart`)
  - Global providers in `LastSpotApp` (`MultiBlocProvider`)
  - Route / page creation (`BlocProvider(create: (_) => sl<MyCubit>())`)
- Direct container lookup (`sl<T>()`) inside widget `build()` trees or repository/BLoC bodies is prohibited.

## Evidence

- `lib/core/di/service_locator.dart` (registers all data sources, repositories, use cases, cubits, and services).
- `lib/main.dart` lines 32-35.
- `lib/lastspot_app.dart` lines 36-62.

## Alternatives Considered

| Alternative | Why Not |
|-------------|---------|
| Riverpod Overrides | Would require rewriting state management from `flutter_bloc` to Riverpod providers. |
| Pure Constructor Injection | Cumbersome across deep navigation routes without a DI container. |

## Consequences

- **Positive:** Fast lookups, simple mockability in unit tests, centralized dependency graph.
- **Negative / Costs:** Requires discipline to prevent container resolution leaks inside widgets.
- **Rules Enforced:** PR-B1, PR-B2.
