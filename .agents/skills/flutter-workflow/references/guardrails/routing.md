# Guardrails: Routing and Navigation

SOP: `sop/routing.md`.

**ROUTE-1** — Every screen MUST be registered in the single route table with a typed route (the router package from PR-E1, e.g. `@RoutePage()` → `XRoute` with auto_route, `@TypedGoRoute` with go_router). Screens reachable only via `Navigator.push(MaterialPageRoute/CupertinoPageRoute)` MUST NOT be added.
Check: `rg -n "Navigator\.(push|pushReplacement)\(|CupertinoPageRoute\(|MaterialPageRoute\(" $PRES` → new hits are violations.

**ROUTE-2** — Route path strings MUST NOT be hardcoded in feature code.
Check: `rg -n "pushNamed\(|goNamed\(|context\.go\('/|'/[a-z]" $PRES --glob '!**/*router*.dart'`.

**ROUTE-3** — Navigation MUST be invoked only from widgets/listeners or from the navigation service in non-widget handlers (notifications, deep links, boot). Blocs, Cubits, repositories, data sources MUST NOT navigate.
Check: `rg -l "router\.|NavigationService|navigatorKey|GoRouter" $STATE $DATA $DOMAIN` → must be empty.

**ROUTE-4** — Session-only screens MUST carry the auth guard in the route table.
Check: review the route table; every route under authenticated shells has `guards:` or is a child of a guarded parent.

**ROUTE-5** — Route arguments MUST be typed constructor parameters; `Map<String, dynamic>` argument bags MUST NOT be used.

**ROUTE-6** — Deep links MUST be validated (known host, known path, id format) and MUST require an active session for protected destinations before navigating. Unknown links MUST be ignored and logged.

**ROUTE-7** — Notification-tap routing MUST go through the handler registry → typed route; handlers MUST validate payload fields before use.

**ROUTE-8** — Screen-scoped state holders SHOULD be provided in the route/screen wrapper (e.g. `AutoRouteWrapper.wrappedRoute`, a `GoRoute` builder, a scoped `ProviderScope`), not at app root.

**ROUTE-9** — Dialogs and bottom sheets MUST be shown via the project helpers and MUST receive existing state holders from the caller (e.g. `BlocProvider.value`); they MUST NOT create new repository-backed state holders internally.

**ROUTE-10** — After adding or renaming a screen, generated route code MUST be regenerated and committed in the same PR.
Check: the generated router file contains the new route.
