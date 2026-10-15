# ADR-0006: Local Storage with SharedPreferences

- **Status:** Accepted
- **Date:** 2026-10-14
- **Decision owner:** Salman Naghori / Tech Lead
- **Classification:** PROJECT-SPECIFIC

## Context

LastSpot requires persistence for user preferences, onboarding flags, active theme selection, language choice, installation identifiers, and session tokens.

## Problem

Which storage solution should persist application settings and preferences across app restarts?

## Decision

Use `shared_preferences` (^2.5.5) encapsulated behind `SharedPrefsUtil` (`lib/core/utils/shared_prefs_util.dart`).

**Rules:**
1. Direct calls to `SharedPreferences.getInstance()` in feature widgets or data sources are prohibited.
2. All read/write operations must go through `SharedPrefsUtil` injected via `sl<SharedPrefsUtil>()`.
3. Complex objects are stored as JSON strings and deserialized through typed helpers.

## Evidence

- `lib/core/utils/shared_prefs_util.dart`
- `lib/core/di/service_locator.dart` (registers `SharedPrefsUtil` singleton)
- `lib/features/settings/presentation/bloc/settings_cubit.dart`

## Alternatives Considered

| Alternative | Why Not |
|-------------|---------|
| Hive / Isar | Overkill for simple key-value settings; LastSpot's primary data store is Supabase with online-first synchronization. |
| GetStorage | Example ADR referenced GetStorage, but the codebase uses standard, officially supported `shared_preferences`. |

## Consequences

- **Positive:** Zero native dependencies beyond Flutter SDK standards, high reliability across Android and iOS.
- **Negative / Costs:** Not intended for large offline relational databases.
- **Rules Enforced:** PR-D1.
