# Project-Specific Rules — LastSpot

These rules govern all UI, business logic, and architecture for LastSpot (`lastspot_app`).

## A. Structure & Placement

- **PR-A1. Orientation:** `Feature First Clean Architecture` (`Stay` confirmed). Single unified tree. (ADR-0001)
- **PR-A2. Placement Table:**

| Layer / Concern | Path Convention |
|-----------------|-----------------|
| Screen (Parent) | `lib/features/<feature>/presentation/pages/<feature>_screen.dart` |
| Screen (Mobile) | `lib/features/<feature>/presentation/pages/<feature>_screen_mobile.dart` |
| Screen (Tablet) | `lib/features/<feature>/presentation/pages/<feature>_screen_tablet.dart` |
| Feature Widgets | `lib/features/<feature>/presentation/widgets/<widget_name>.dart` |
| BLoC / Cubit | `lib/features/<feature>/presentation/bloc/<name>_bloc.dart` or `_cubit.dart` |
| Domain Entities | `lib/features/<feature>/domain/entities/<entity_name>.dart` |
| Repository Interfaces | `lib/features/<feature>/domain/repositories/<name>_repository.dart` |
| Domain Use Cases | `lib/features/<feature>/domain/usecases/<name>_usecase.dart` |
| Data Models | `lib/features/<feature>/data/models/<name>_model.dart` |
| Data Sources | `lib/features/<feature>/data/datasources/<name>_remote_datasource.dart` |
| Repository Impls | `lib/features/<feature>/data/repositories/<name>_repository_impl.dart` |
| Core / Shared Tokens | `lib/core/{constants, di, extension, l10n, network, services, theme, utils, widgets}` |
| Tests | `test/features/<feature>/...` mirroring `lib/features/<feature>/` |

- **PR-A3. Naming:** Files and directories use `snake_case`. Classes use `PascalCase`.
- **PR-A4. Single Orientation:** Never create `lib/layers/`. Every feature lives completely within its `lib/features/<feature>/` directory.
- **PR-A5. Reusable UI Components:** Never write private widget classes (`_MyWidget`) or widget-building methods (`Widget _buildRow()`). Extract public widgets into `widgets/` or `lib/core/widgets/`.
- **PR-A6. Check Variables:** Paths and regexes for guardrail checks:

```sh
export UI="lib/features/*/presentation/pages lib/features/*/presentation/widgets lib/core/widgets"
export STATE="lib/features/*/presentation/bloc"
export PRES="lib/features/*/presentation lib/core/widgets"
export DATA="lib/features/*/data"
export DOMAIN="lib/features/*/domain"
export REPO_IF="lib/features/*/domain/repositories"
export CORE="lib/core"
export DI="lib/core/di"
export TOKENS="lib/core/theme lib/core/constants"
export STRINGS="lib/core/l10n lib/core/constants/app_string.dart"

export LOOKUP='sl<|getIt<'
export ROOT_ALLOW='BlocProvider\(|create:|wrappedRoute|MultiBlocProvider'
export GATEWAY='SupabaseClient|SupabaseConfig|BaseRepository'
export STORAGE='SharedPrefsUtil|SharedPreferences'
export LOGGER='LoggerUtils|developer\.log'
```

## B. Dependency Injection

- **PR-B1. Container:** `get_it` (`sl<T>()`) configured in `lib/core/di/service_locator.dart`. (ADR-0002)
- **PR-B2. Resolution Points:** DI resolution is restricted to composition roots:
  - App bootstrap (`lib/main.dart`)
  - Global providers in `LastSpotApp` (`lib/lastspot_app.dart`)
  - Screen-level route providers (`BlocProvider(create: (_) => sl<MyCubit>())`)
  - DI container lookup MUST NOT occur inside widget build trees or business logic methods.

## C. State Management

- **PR-C1. Paradigm:** `flutter_bloc` (`Bloc` & `Cubit`) using `equatable` for value equality. (ADR-0003)
- **PR-C2. Local UI State:** Use `ValueNotifier` for purely local ephemeral UI state (e.g. toggles, filter selections, active indices). `setState` is only used for trivial interactive animations/controllers.
- **PR-C3. Side Effects:** Navigation, dialogs, toasts, and bottom sheets execute in presentation listeners (`BlocListener` / event handlers), never inside BLoCs or repositories.

## D. Networking and Data

- **PR-D1. Gateway:** Supabase client (`supabase_flutter`) wrapped behind DataSources (`*RemoteDataSource`) and Repositories (`*RepositoryImpl`). UI never calls Supabase directly. (ADR-0005)
- **PR-D2. Result Boundary:** Repositories return `Result<T, Exception>` (or `Success<T>` / `Failure<Exception>`), handled via `BaseRepository`.
- **PR-D3. Sensitive Operations:** Joins, slot decrements, session activation, and moderation MUST execute via Supabase RPCs/Edge Functions, never client-side direct writes.
- **PR-D4. Serialization:** Freezed (`@freezed`) and `json_serializable` for immutable entities and data transfer models.

## E. Routing

- **PR-E1. Declarative Routing:** `go_router` via `appRouter` in `lib/core/network/router.dart`. (ADR-0004)
- **PR-E2. Route Constants:** All route paths and query parameter builders are centralized in `lib/core/network/app_routes.dart` (`AppRoutes`).
- **PR-E3. No Push Navigation:** `Navigator.push` and `MaterialPageRoute` are strictly prohibited.

## F. UI, Theming & Responsiveness

- **PR-F1. Design System:** Material 3 (`ThemeData(useMaterial3: true)`), Google Fonts Inter typography, supporting both Light and Dark themes via `ThemeMode`.
- **PR-F2. Dimensions:** Never use raw numeric literals for sizes, margins, padding, or radii. Use `Dimensions` dynamic extensions (`.dynamicW`, `.dynamicH`, `.dynamicSP`, `.dynamicR`).
- **PR-F3. Colors:** Never hardcode `Colors.*` or hex codes. Use `context.colorScheme` / `context.primaryColor` (extensions from `app_color.dart`) or `AppColor.*`.
- **PR-F4. Responsive Layout:** Every major screen MUST implement `ResponsiveLayout`, splitting into parent, `_mobile.dart`, and `_tablet.dart`.
- **PR-F5. Strings:** User-facing strings must use `AppLocalizations` (`intl_en.arb`) accessed via `context.loc` or `AppString`.

## G. Security

- **PR-G1. Credentials:** Never hardcode API keys, service role keys, or secrets in source code. Use compile-time environment variables (`SupabaseConfig`).
- **PR-G2. Single Device Session:** Enforce single-device session integrity via `activate_my_session` and `register_my_device` RPCs.

## H. Testing & Tooling

- **PR-H1. Flutter Version Management (FVM):** ALWAYS execute CLI commands via `fvm flutter` and `fvm dart`.
- **PR-H2. Test Coverage:** Every feature must ship unit and widget tests in `test/features/<feature>/` covering BLoCs, entities, policies, and interactive widgets.

## I. Open Decisions (NEEDS-DECISION)

| ID | Topic | Current State | Recommendation |
|----|-------|---------------|----------------|
| **ND-A** | String Centralization | Mixed use of `AppString` (constants) and `AppLocalizations` (`intl_en.arb`) | Standardize all user-facing strings in `intl_en.arb`, keeping `AppString` for technical/app constants only. |
| **ND-B** | Debug Logging in Data Layer | 10 `print()` statements exist in `spot_remote_datasource.dart` | Replace raw `print` calls with `LoggerUtils` or `developer.log` to satisfy `avoid_print` lint. |
| **ND-C** | Hardcoded Colors in Older Screens | 46 occurrences of `Colors.*` (e.g. `Colors.white`, `Colors.black`, `Colors.transparent`) in `create_spot_screen_mobile.dart` | Refactor older spot creation screens to use `context.colorScheme` and `AppColor`. |
