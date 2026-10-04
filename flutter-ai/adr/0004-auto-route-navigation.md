> **EXAMPLE ADR** (reference profile). Greenfield: write your own from TEMPLATE.md; do not copy these decisions unless this is that stack.

# ADR-0004: auto_route typed navigation with AuthGuard and custom deep links

- **Status:** Accepted
- **Date:** 2026-09-08 (reconstructed)
- **Decision owner:** Not determinable from repository evidence
- **Classification:** PROJECT-SPECIFIC (package), UNIVERSAL (typed routes, guards, no string routes)

## Context

~79 screens, nested tab navigation (dashboard, chat shell, social health shell, appeals shell), authenticated areas, universal links and a custom app deep-link scheme, plus notification-tap routing.

## Problem

How are routes defined, guarded and invoked?

## Decision

- `auto_route` with `@AutoRouterConfig(replaceInRouteName: 'Screen,Route')` in `core/navigation/app_router.dart`; every screen is `@RoutePage()` class `XScreen` → generated `XRoute`.
- `AuthGuard` protects session-only routes via `guards: [_authGuard]`.
- Navigation from widgets: `context.router.*`. From non-widget code (notifications, deep links, boot): `NavigationService` (wraps `AppRouter`).
- Screen-scoped providers via `AutoRouteWrapper.wrappedRoute`.
- auto_route's own deep-link resolution is disabled (`deepLinkBuilder: (_) => DeepLink.defaultPath`); `DeepLinkService` (`app_links`) resolves links after full login so guards and session state are respected.

## Evidence

- `app_router.dart`, `auth_guard.dart`, `navigation_service.dart`, `core/deepLink/`, `main.dart:99-102`.
- `context.router` 117 hits vs `Navigator.push` 18 (legacy `navigateToPage`).
- Reason for disabling auto_route deep links: **Not determinable from repository evidence** (likely to sequence after boot/login).

## Alternatives considered

| Alternative | Why not |
|-------------|---------|
| go_router | Both are valid; switching has no benefit at this stage. |
| Navigator 1.0 with string routes | No typed args, no guards, error-prone. |

## Consequences

- Positive: compile-time route args; central guard; one place to see all routes.
- Negative: codegen step; legacy `Navigator.push` paths remain (R30); deep-link IDs are unvalidated (R13).
- Rules: `sop/routing.md`, `guardrails/routing.md`, `rules/routing.rules`, `project/project-rules.md` §E.

## Migration

Replace remaining `navigateToPage` / `Navigator.push` screen pushes with typed routes.

## Review trigger

auto_route major version change, or if web/URL-based navigation becomes a requirement.
