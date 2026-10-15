# ADR-0008: Compile-Time Environment Configuration and AppConstants

- **Status:** Accepted
- **Date:** 2026-10-14
- **Decision owner:** Salman Naghori / Tech Lead
- **Classification:** PROJECT-SPECIFIC

## Context

LastSpot requires configuration for Supabase URL, anon keys, support contact, app versions, and platform checks. Sensitive backend keys (like `SUPABASE_SERVICE_ROLE_KEY`) must never be bundled into the client app.

## Problem

How should environment variables, keys, and global app constants be structured securely and accessibly?

## Decision

1. Use `--dart-define` compile-time environment variables surfaced through `SupabaseConfig` (`lib/core/network/supabase_config.dart`).
2. Global, immutable application constants (support email, fallback URLs, app identity) live in `AppConstants` (`lib/core/constants/app_constants.dart`).
3. Never include backend service role keys or sensitive credentials in the Flutter source.
4. Feature flags, minimum versions, and maintenance mode checks are loaded dynamically from Supabase at startup (`StartupBloc`).

## Evidence

- `lib/core/network/supabase_config.dart`
- `lib/core/constants/app_constants.dart`
- `lib/features/startup/presentation/bloc/startup_bloc.dart`
- GEMINI.md Rule 10.

## Alternatives Considered

| Alternative | Why Not |
|-------------|---------|
| Flutter Dotenv (.env in assets) | Bundles plain-text asset files into APK/IPA bundles which can be extracted easily. |
| Hardcoded Credentials | Violates SEC-1 and basic security hygiene. |

## Consequences

- **Positive:** Secure, CI/CD friendly, zero runtime overhead.
- **Negative / Costs:** Requires passing `--dart-define` parameters during release builds.
- **Rules Enforced:** PR-G1, SEC-1.
