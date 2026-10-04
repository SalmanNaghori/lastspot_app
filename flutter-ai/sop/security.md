# SOP: Security

## Purpose

Protect user data and backend credentials against the realistic threats to a mobile app: extracted binaries, rooted devices, network interception, log leakage, and malicious deep links.

## Scope

Secrets, tokens, secure storage, environment configuration, logging, PII, deep links, local persistence, network security, build signing.

## Principles

1. **Anything in the binary is public.** Keys shipped in the app must be restricted server-side; secrets must not be shipped at all.
2. **Tokens live in OS-backed secure storage**, are transmitted only in headers, and are never logged.
3. **Logs are for developers, in debug builds, and still redacted.**
4. **Inputs from outside the app (links, notifications, sockets) are untrusted.**
5. **Release builds are signed with release keys and ship no debug bypasses.**

## Standard

### Secrets and keys (UNIVERSAL, HIGH)

- Never hardcode API keys, tokens, passwords, or encryption keys in Dart, `AndroidManifest.xml`, `Info.plist`, or committed JSON.
- Build-time values via `--dart-define-from-file=config/<env>.json` (gitignored) → typed config object (ADR-0008). Native-side keys (Maps) via `manifestPlaceholders` / xcconfig fed from the same source.
- Third-party keys that must be in the binary (Maps, Firebase) are **restricted** in the provider console to the app's bundle id / SHA / referrer.
- Reference violations: Google key literal `utils/extensions.dart:974`; Maps keys in manifest/plist (R4, R5).
- `firebase_options.dart`, `google-services.json`, `GoogleService-Info.plist` may be committed (they are not secrets by design) **provided** Firebase security rules and API-key restrictions are in place; document this in the project README.

### Tokens and session (UNIVERSAL, HIGH)

- Access/refresh tokens, encryption keys: `flutter_secure_storage` (Keychain / EncryptedSharedPreferences) behind the project storage interface.
- Never in URL query strings (reference socket URL — R3). Sockets authenticate via `auth` payload or headers.
- Logout clears **all** session-scoped keys (reference `clearSession` leaves keys — R7).
- Token attached only when `requiresAuth` and only to the private backend (`apiType: private`).
- Reference project's AES-over-GetStorage with a key derived from the package name is obfuscation, not protection (R6, ND-8). Universal rule: derive keys from OS secure storage or a server-issued secret, never from public app metadata.

### Local persistence (UNIVERSAL)

- Classify stored data: session (secure storage), sensitive cache (encrypted, key in secure storage), preferences (plain).
- Encrypt message bodies / PII at rest when cached (reference does for chat — keep).
- Clear caches on logout and on account deletion.

### Logging (UNIVERSAL, HIGH)

- All logging through one `DebugLog`/logger gated by `kDebugMode`; `print` forbidden.
- Never log: tokens, FCM tokens, OTPs, phone numbers, emails, full request/response bodies containing PII, full notification payloads, socket URLs with credentials. Reference logs FCM token and socket URL (R3, R12).
- HTTP logger enabled only in debug (reference does this — keep) with header redaction.
- Crash reporting (Crashlytics) records errors with **no PII** in custom keys; set user id only as an opaque identifier.

### Network security (UNIVERSAL, HIGH)

- HTTPS only. Android `usesCleartextTraffic=false`; iOS ATS default.
- No `badCertificateCallback` returning `true` in release (reference staging bypass must be `kReleaseMode`-guarded or removed — R8).
- Certificate pinning OPTIONAL for high-risk apps; plan rotation.

### Deep links and notifications (UNIVERSAL)

- Validate host, path, id format; require an active session for protected destinations; ignore unknown links with a log (R13).
- Notification payloads are validated before routing; never `eval`-style dynamic behaviour from payload strings.

### Permissions and privacy (UNIVERSAL)

- Request the minimum (background location only when the feature is active — reference starts it from `ActiveOrbitCubit`; good).
- Every declared permission/background mode has a documented reason (reference `bluetooth-central` background mode appears unused — review).
- Privacy manifest (iOS) and data-safety form (Android) kept in sync with actual SDK usage.

### Build and release (UNIVERSAL, HIGH)

- Release signing with a release keystore from `key.properties` (gitignored); never `signingConfigs.debug` for release (reference — R2).
- Obfuscation: `--obfuscate --split-debug-info=<dir>` for release; keep symbol files for Crashlytics.
- Debug-only code behind `kDebugMode`/`kReleaseMode` and verified absent from release via review.

### Dependencies (UNIVERSAL)

- Native plugins reviewed for permissions and network access before adding (see `dependency-management.md`).
- `flutter pub outdated` + advisory check per release.

## Recommended implementation

- `SecureAppStorage` implementation of the existing `AppStorage` interface (single seam).
- A CI grep step failing on `AIza`, `sk_live`, `Bearer ` literals in `lib/`, `android/app/src`, `ios/Runner`.
- A `LogRedactor` applied to Dio and socket logs.

## Examples

Good (reference): dart-define config (ADR-0008); `PrettyDioLogger(enabled: kDebugMode)`; encrypted chat cache; `AuthInterceptor` scoped by `requiresAuth`.

Fix (reference): R1–R8, R12, R13 in `profiles/reference/remediation-backlog.md`.

## Anti-patterns

- Key literals "temporarily" in code.
- Token in query string or in logs.
- `.env` bundled as an asset.
- Trust-all TLS callbacks.
- Debug signing in release.
- Encryption key derived from package name.

## Exceptions

Public third-party keys that the provider requires client-side (Maps, Places, Tenor) are allowed in the binary via config injection **with console restrictions**; document restriction settings in the project README.
