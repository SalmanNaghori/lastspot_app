# Project profile (active) — LastSpot

This folder is the **only** project-specific brain the agent should load by default.

## Required files

| File | Status |
|------|--------|
| `README.md` (this file) | Complete |
| `project-rules.md` | Complete |
| `architecture-map.md` | Complete |
| `audit-report.md` | Complete |
| `dependency-inventory.md` | Complete |
| `remediation-backlog.md` | Complete |
| `features.md` | Complete (14 features catalogued) |

## This project

- **App name / package:** `lastspot_app`
- **Architecture level:** L3 (Feature-First Clean Architecture: Presentation, Domain, Data)
- **Orientation:** Feature First (`Stay` confirmed — single tree: `lib/features/<name>/{data, domain, presentation}` plus `lib/core/`). Record: [ADR-0001](../../adr/0001-feature-first-clean-architecture.md).
- **Legacy root (brownfield):** n/a (no legacy layer tree exists)
- **New-feature root:** `lib/features/<name>/`
- **State:** `flutter_bloc` (^9.1.1) + `equatable` (^2.1.0). Local UI state uses `ValueNotifier`. Record: [ADR-0003](../../adr/0003-flutter-bloc-state-management.md).
- **DI:** `get_it` (^9.2.1) via `lib/core/di/service_locator.dart`. Record: [ADR-0002](../../adr/0002-get-it-service-locator.md).
- **Routing:** `go_router` (^17.5.0) via `lib/core/network/router.dart` and `AppRoutes`. Record: [ADR-0004](../../adr/0004-go-router-declarative-routing.md).
- **HTTP / Backend:** `supabase_flutter` (^2.18.0) client, PostgREST queries, and RPCs. Record: [ADR-0005](../../adr/0005-supabase-gateway-and-result-boundary.md).
- **Storage:** `shared_preferences` (^2.5.5) via `SharedPrefsUtil`. Record: [ADR-0006](../../adr/0006-shared-preferences-local-storage.md).
- **Realtime:** Supabase Realtime Channels. Record: [ADR-0007](../../adr/0007-supabase-realtime-messaging.md).
- **Serializer / result type:** Freezed + `json_serializable`; `Result<T, Exception>` boundary. (ADR-0005)
- **Strings / locales:** `AppLocalizations` (`intl_en.arb`) + `AppString` constants. (ND-A)
- **Test stack:** `flutter_test` (unit & widget tests).
- **Logging / crash / analytics:** `logger` (`LoggerUtils`) + Firebase Core / Messaging. (ND-B)
- **Flavors / toolchain pin / CI:** `.fvmrc` (Flutter stable pin), `fvm flutter`, `fvm dart`.
- **Platforms / form factors / themes:** Android, iOS; Phones & Tablets via `ResponsiveLayout`; Material 3 Light/Dark via `AppTheme`.
