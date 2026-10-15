# ADR-0003: State Management with flutter_bloc and ValueNotifier

- **Status:** Accepted
- **Date:** 2026-10-14
- **Decision owner:** Salman Naghori / Tech Lead
- **Classification:** PROJECT-SPECIFIC

## Context

LastSpot coordinates asynchronous data streams, authentication lifecycle, match participation states, notifications, and real-time messaging. Predictable state transitions, event decoupling, and clear side-effect boundaries are critical.

## Problem

Which state management paradigm should govern business logic, global state, and asynchronous lifecycles across the application?

## Decision

Use `flutter_bloc` (^9.1.1) with `equatable` (^2.1.0) as the primary state management framework.

**Rules:**
1. **Business Logic & Async State:** Handled exclusively via `Bloc` and `Cubit`. States are modeled as sealed classes or subclasses of an abstract state class extending `Equatable` (e.g. `Initial`, `Loading`, `Loaded`, `Error`). No boolean flag-soup (`isLoading`, `hasError`, etc.).
2. **Local UI State:** Use `ValueNotifier` for purely local, ephemeral UI state (filter toggles, active page indices, password visibility).
3. **UI Side Effects:** Navigation, SnackBar notifications, bottom sheets, and dialogs are triggered in `BlocListener`, never inside state holders or repositories.
4. **Minimal `setState`:** `setState` is reserved for trivial widget-internal animations and gestures.

## Evidence

- `lib/features/auth/presentation/bloc/auth_bloc.dart`
- `lib/features/spot/presentation/bloc/spot_details_bloc.dart`
- `lib/features/chat/presentation/bloc/chat_cubit.dart`
- GEMINI.md Rule 6.

## Alternatives Considered

| Alternative | Why Not |
|-------------|---------|
| Riverpod | Not used in existing codebase; `flutter_bloc` is already adopted consistently across all 14 features. |
| Provider / ChangeNotifier | Lack of explicit event-driven trace and predictable state machine guarantees for complex async flows. |

## Consequences

- **Positive:** Unidirectional data flow, high testability (`bloc_test`), clean separation from presentation.
- **Negative / Costs:** Requires boilerplate state/event class declarations.
- **Rules Enforced:** PR-C1, PR-C2, PR-C3, GEMINI Rule 6.
