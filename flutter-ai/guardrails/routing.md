# Guardrails: Routing and Navigation

SOP: `sop/routing.md`.

**ROUTE-1** — Every screen MUST be registered in the single route table with a typed route (`@RoutePage()` → `XRoute`). Screens reachable only via `Navigator.push(MaterialPageRoute/CupertinoPageRoute)` MUST NOT be added.
Check: `rg -n "Navigator\.(push|pushReplacement)\(|CupertinoPageRoute\(|MaterialPageRoute\(" lib/layers/presentation` → new hits are violations (reference legacy: 18, `navigateToPage`).

**ROUTE-2** — Route path strings MUST NOT be hardcoded in feature code.
Check: `rg -n "pushNamed\(|'/[a-z]" lib/layers/presentation --glob '!**/app_router.dart'`.

**ROUTE-3** — Navigation MUST be invoked only from widgets/listeners (`context.router`) or from the navigation service in non-widget handlers (notifications, deep links, boot). Blocs, Cubits, repositories, data sources MUST NOT navigate.
Check: `rg -l "router\.|NavigationService|navigatorKey" lib/layers/presentation/{cubit,bloc} lib/layers/data lib/layers/domain` → must be empty.

**ROUTE-4** — Session-only screens MUST carry the auth guard in the route table.
Check: review `app_router.dart`; every route under authenticated shells has `guards:` or is a child of a guarded parent.

**ROUTE-5** — Route arguments MUST be typed constructor parameters; `Map<String, dynamic>` argument bags MUST NOT be used.

**ROUTE-6** — Deep links MUST be validated (known host, known path, id format) and MUST require an active session for protected destinations before navigating. Unknown links MUST be ignored and logged.

**ROUTE-7** — Notification-tap routing MUST go through the handler registry → typed route; handlers MUST validate payload fields before use.

**ROUTE-8** — Screen-scoped Blocs/Cubits SHOULD be provided in the route wrapper (`AutoRouteWrapper.wrappedRoute`), not at app root.

**ROUTE-9** — Dialogs and bottom sheets MUST be shown via the project helpers and MUST receive existing Cubits via `BlocProvider.value`; they MUST NOT create new repository-backed Cubits internally.

**ROUTE-10** — After adding or renaming a screen, generated route code MUST be regenerated and committed in the same PR.
Check: `app_router.gr.dart` contains the new `XRoute`.

## Reference project status

Legacy `Navigator.push`/`navigateToPage` (R30), deep-link validation (R13/ND-12), 21 root providers (ROUTE-8 SHOULD).
