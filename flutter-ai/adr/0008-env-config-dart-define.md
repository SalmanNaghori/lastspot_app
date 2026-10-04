> **EXAMPLE ADR** (reference profile). Greenfield: write your own from TEMPLATE.md; do not copy these decisions unless this is that stack.

# ADR-0008: Environment configuration via --dart-define-from-file

- **Status:** Accepted
- **Date:** 2026-09-08 (reconstructed)
- **Decision owner:** Not determinable from repository evidence
- **Classification:** UNIVERSAL

## Context

Four environments (`local`, `dev`, `staging`, `prod`) with different base URLs, socket URLs and third-party API keys. No Android/iOS build flavors are defined.

## Problem

How are environment values and secrets supplied to the app?

## Decision

- Values live in `config/<env>.json` (gitignored; keys: `BASE_URL`, `SOCKET_BASE_URL`, `GOOGLE_API_KEY`, `GIF_API_KEY`, `STICKER_API_KEY`, `AWS_IMG_URL`, `AWS_REFERER`, `TENOR_API_KEY`).
- They are injected at build time with `--dart-define-from-file=config/<env>.json` and read once by `ConfigInjection` via `String.fromEnvironment` into an immutable `AppConfiguration` registered in `get_it`.
- No secret appears in Dart source, `AndroidManifest.xml`, `Info.plist`, or committed JSON.
- Run configurations (`.idea/runConfigurations`, gitignored) carry the flag; the README must document the command.

## Evidence

- `core/di/service_locator.dart:34-36` comment; `core/di/configInjection/config_injection.dart`; `core/config/app_config.dart`; `.gitignore` `config/*.json`.
- Violations: hardcoded key in `utils/extensions.dart:974`, Maps keys in manifest/plist (R4, R5); `TENOR_API_KEY` unused; `Environment` enum unused.

## Alternatives considered

| Alternative | Why not |
|-------------|---------|
| `.env` + `flutter_dotenv` | Bundles secrets as an asset readable from the APK. |
| Native build flavors | More setup; dart-define covers the need. May be added later for per-env app ids/icons. |
| Remote config | Not for build-time endpoints. |

## Consequences

- Positive: secrets never in the repo; single typed config object; trivially mockable.
- Negative: forgetting the flag yields empty strings at runtime — `ConfigInjection` should fail fast on empty `BASE_URL`; native-side keys (Maps) still need placeholders (R5).
- Rules: `sop/configuration.md`, `sop/security.md`, `guardrails/security.md`, `rules/security.rules`.

## Migration

Move remaining hardcoded keys to config (R4, R5). Add `config/*.json.example` with key names only.

## Review trigger

Need for per-environment bundle ids / icons → add flavors alongside dart-define.
