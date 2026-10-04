> **EXAMPLE ADR** (reference profile). Greenfield: write your own from TEMPLATE.md; do not copy these decisions unless this is that stack.

# ADR-0006: Hive for structured cache, AES-wrapped GetStorage for session

- **Status:** Accepted — storage backend for secrets under review (ND-8)
- **Date:** 2026-09-08 (reconstructed)
- **Decision owner:** Not determinable from repository evidence
- **Classification:** PROJECT-SPECIFIC

## Context

The app caches chat messages per conversation, drafts, and notification history, and persists session (token, userId, encryption key/IV, flags, theme).

## Problem

Where does local data live and how is sensitive data protected?

## Decision

- **Hive** for structured/large data: `chat_drafts` (typeId 21), `notification_messages_box` (22), per-chat `chat_messages_cache_v1_<id>` boxes with encrypted message bodies, meta/tracking boxes. Adapters are handwritten. Boxes are opened in `HiveInjection`.
- **GetStorage** wrapped by `EncryptedStorage` (AES-CBC via `encrypt`) behind the `AppStorage` interface for key-value/session data. Keys are enumerated in `StorageKeys`.
- All access goes through `AppStorage` / data sources; no direct `GetStorage()` or `Hive.box()` outside `core/storage`, `core/di/hiveInjection`, `data/localDB`.

## Evidence

- `core/storage/*`, `core/di/hiveInjection/hive_injection.dart`, `data/localDB/*`, `data/localModels/*`.
- Reason for GetStorage over `flutter_secure_storage`: **Not determinable from repository evidence.**

## Alternatives considered

| Alternative | Why not (at the time) |
|-------------|------------------------|
| `flutter_secure_storage` for token | Not chosen; reason unknown. It is the universal recommendation and is tracked as ND-8 / R6. |
| Isar / Drift | Heavier; Hive suffices for cache semantics. |
| SharedPreferences | GetStorage chosen; functionally similar. |

## Consequences

- Positive: single `AppStorage` seam makes backend swap a one-file change; chat cache encrypted at rest.
- Negative: AES key is derived from the package name and IV from platform name (`encrypted_storage.dart:36-59`) — derivable, so protection against a rooted device is weak; `clearSession` incomplete (R7).
- Rules: `sop/security.md` §Storage, `guardrails/security.md`, `project/project-rules.md` PR-G3.

## Migration

R6: introduce `SecureAppStorage` using `flutter_secure_storage` for `token`, `encryptionKey`, `encryptionIV`; keep GetStorage for non-sensitive prefs.

## Review trigger

ND-8 decision; any security review; Hive 2.x maintenance status.
