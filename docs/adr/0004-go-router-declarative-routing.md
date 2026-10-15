# ADR-0004: Declarative Routing with go_router

- **Status:** Accepted
- **Date:** 2026-10-14
- **Decision owner:** Salman Naghori / Tech Lead
- **Classification:** PROJECT-SPECIFIC

## Context

The app requires deep linking, URL parameter parsing, auth state redirection, and clean navigation stack control across tabs (Home, Explore, Create, Activities, Profile) and contextual flows (Direct Chat, Group Chat, Group Info, Notifications, Reports).

## Problem

Which routing library should manage navigation, deep linking, and auth guards while preventing navigation spaghetti?

## Decision

Use `go_router` (^17.5.0).

**Rules:**
1. All route path strings, route names, and parameterized path generator methods are centralized in `lib/core/network/app_routes.dart` (`AppRoutes`).
2. Declarative router configuration is defined in `lib/core/network/router.dart` (`appRouter`).
3. Imperative `Navigator.push`, `Navigator.pop`, and `MaterialPageRoute` are strictly prohibited. Use `context.go()`, `context.push()`, `context.pop()`, or `context.safePush()`.
4. Auth redirection is governed at the router level via `refreshListenable` listening to `AuthBloc`.

## Evidence

- `lib/core/network/router.dart`
- `lib/core/network/app_routes.dart`
- Quantitative audit: Exactly 0 occurrences of `MaterialPageRoute` or `Navigator.push`.

## Alternatives Considered

| Alternative | Why Not |
|-------------|---------|
| AutoRoute | Example ADR referenced AutoRoute, but the actual repository exclusively uses `go_router` with 100% compliance. |
| Vanilla Navigator 2.0 | High implementation complexity with no benefits over `go_router`. |

## Consequences

- **Positive:** Type-safe path helpers, deep link support, seamless auth redirects, consistent back navigation.
- **Negative / Costs:** Route arguments must be passed via query parameters, path variables, or `extra`.
- **Rules Enforced:** PR-E1, PR-E2, PR-E3.
