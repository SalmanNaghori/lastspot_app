# Codebase Audit Report — LastSpot (`lastspot_app`)

- **Date:** 2026-10-14
- **Scope:** Complete codebase (`pubspec.yaml`, `lib/main.dart`, `lib/core/`, all 14 `lib/features/`, test suite)
- **Method:** Static file inspection, vertical slice verification, AST analysis, and ripgrep pattern counts.

---

## 1. Classification & Findings

### UNIVERSAL (Architecture & Principles)
- **Feature-First Clean Architecture:** The entire app is organized by features (`lib/features/<name>/`) with clean sub-layers (`data/`, `domain/`, `presentation/`).
- **Dependency Direction:** Domain layer has zero Flutter UI imports. Repositories in data implement domain interfaces.
- **Declarative Routing:** Clean `go_router` usage. Exactly 0 occurrences of `Navigator.push` or `MaterialPageRoute`.
- **Responsive Layout:** All major feature pages separate mobile and tablet views through `ResponsiveLayout`.

### PROJECT-SPECIFIC (Conventions & Stack Choices)
- **FVM Governance:** Strict `fvm flutter` and `fvm dart` CLI execution per `.fvmrc`.
- **State Management:** `flutter_bloc` (`Bloc` & `Cubit`) with `equatable`. Ephemeral UI state uses `ValueNotifier`.
- **Dynamic Sizing:** Sizing driven by `Dimensions` with responsive suffixes (`.dynamicW`, `.dynamicH`, `.dynamicSP`, `.dynamicR`).
- **Gateway & Data Boundary:** `supabase_flutter` wrapped in data sources. Repositories extend `BaseRepository` and return `Result<T, Exception>`.
- **Single-Device Session:** Session activation (`activate_my_session`) and device registration (`register_my_device`) enforced via Supabase RPCs.

### LEGACY / PATTERN DRIFT
- **Hardcoded Colors (`Colors.*`):** 46 occurrences found (e.g. `Colors.white`, `Colors.black`, `Colors.transparent` in `create_spot_screen_mobile.dart`, `onboarding_screen.dart`, etc.) rather than `context.colorScheme` / `AppColor`.
- **Debug Print Statements:** 10 occurrences of `print(...)` in `lib/features/spot/data/datasources/spot_remote_datasource.dart`.
- **Service Locator in Presentation (`sl<`):** 18 occurrences in `lib/features/`, primarily at screen composition roots creating BLoCs for `BlocProvider`, with a few direct service calls (`ImageService`, `SharedPrefsUtil`).
- **Empty Catches (`catch (_)`):** 15 occurrences across data sources and network helpers.

---

## 2. Quantitative Pattern Audit

| Pattern / Check | Count | Status | Notes |
|-----------------|-------|--------|-------|
| `Navigator.push` / `MaterialPageRoute` | 0 | PASSED | 100% `go_router` adoption |
| `Colors.` in features | 46 | DRIFT | Needs token migration (ND-C) |
| `print(` in production code | 10 | DEBT | Restricted to `spot_remote_datasource.dart` (ND-B) |
| `sl<` in `lib/features/` | 18 | ACCEPTABLE | Screen-level composition roots |
| `catch (_)` in `lib/` | 15 | DEBT | Needs logging in catch blocks |
| `setState` in feature widgets | 23 | ACCEPTABLE | Limited to trivial UI animation/toggles |
| Total test suite | 62 passed | HEALTHY | 0 failures across unit and widget tests |
