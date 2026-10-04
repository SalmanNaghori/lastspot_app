# SOP: Routing and Navigation

## Purpose

Every screen reachable through one typed, guarded, discoverable route table; navigation triggered only from the presentation edge.

## Scope

Route definitions, naming, arguments, nested routers, guards, deep links, notification routing, navigation results, dialogs and sheets.

## Principles

1. Routes are typed. Strings are for the router, not for feature code.
2. One route table. A screen not in it does not exist.
3. Navigation is a side effect: it happens in listeners/handlers, never in Blocs, repositories or data sources.
4. Deep links are untrusted input.

## Standard

### Package (RECOMMENDED; reference: auto_route, ADR-0004)

L1 may use `Navigator` with a `Routes` constants class. L2+ uses a declarative typed router (`auto_route` or `go_router` with typed routes). One per project.

### Definitions (UNIVERSAL)

- Every screen: `@RoutePage()` class `XScreen` → generated `XRoute` (`replaceInRouteName: 'Screen,Route'`).
- Registered once in `AppRouter.routes`; nested routers for shells/tabs (`children:`).
- Arguments are constructor parameters of the screen (typed, required where needed); the generator produces `XRouteArgs`. Pass ids, not whole objects, when the target can fetch (avoids stale data); pass objects only for pure display screens.
- Initial route and auth redirect are defined in the router, not in screens.

### Guards (UNIVERSAL)

`guards: [_authGuard]` on every session-only route. The guard redirects (`replaceAll([AuthStepperRoute()])`) and never shows UI itself.

### Invoking navigation (UNIVERSAL, HIGH)

| From | Use |
|------|-----|
| Widget / `BlocListener` | `context.router.push/replace/pop/navigate(XRoute(...))` |
| Non-widget code (notification tap, deep link, boot) | `NavigationService` wrapping the router (reference: `core/navigation/navigation_service.dart`) |
| Bloc / Cubit / repository | **never** — emit state; listener navigates |
| Legacy `Navigator.push(context, CupertinoPageRoute(...))` for screens | LEGACY (reference: `navigateToPage`, 18 hits) — do not add |

### Results (UNIVERSAL)

`final result = await context.router.push<T>(XRoute())`; the pushed screen returns via `context.router.pop(result)`. Type `T` explicitly.

### Dialogs and bottom sheets (UNIVERSAL)

- Not routes unless they need deep-link addressability.
- Shown via project helpers (`showXSheet(context)`, `showXDialog(context)`) that wrap `showModalBottomSheet`/`showDialog` with theme defaults.
- Pass existing Cubits with `BlocProvider.value`.

### Deep links (UNIVERSAL, HIGH)

- Universal/App Links + custom scheme handled by one service (`DeepLinkService`).
- Parse → validate (known host, known path, id format) → check session → navigate with a typed route. Unknown links are ignored and logged.
- Never navigate to a protected screen from a link before the session is restored; queue until app ready (reference does this after login — keep, but validate ids: R13).

### Notification routing (UNIVERSAL pattern)

Type → handler registry → typed route (reference: `NotificationHandlerRegistry`). Handlers are pure functions of the payload; they call `NavigationService`.

### Route observers (OPTIONAL)

For analytics/active-screen tracking, one `RouteObserver` registered on the router (reference: `AppRouteObserver`).

## Recommended implementation

- After adding a screen: annotate, register, run `build_runner`, add guard if needed, add a widget test that the route builds.
- Keep `app_router.dart` grouped by feature with a one-line comment per route (reference does this).

## Examples

Good (reference): `create_orbit_screen.dart:95-108` — `BlocListener` navigates on success; `app_router.dart` nested `DashboardTabRoute` children with guard.

Legacy (reference): `edit_profile_screen.dart` → `navigateToPage(...)`.

## Anti-patterns

- Hardcoded route path strings in widgets.
- Duplicate route definitions for the same screen.
- `Navigator.of(context).push(MaterialPageRoute(builder: ...))` for a screen that has a route.
- Navigation inside a Cubit via a global navigator key.
- Deep link handler that trusts any id.

## Exceptions

Full-screen media viewers or overlays that need custom transitions may use `Navigator.push` with a `PageRouteBuilder` **if** they are not addressable screens; add a comment referencing this exception. (Reference: `message_action_route.dart` overlay.)
