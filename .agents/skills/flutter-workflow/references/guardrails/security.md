# Guardrails: Security

SOP: `sop/security.md`, `sop/configuration.md`.

## Secrets and configuration

**SEC-1** — API keys, tokens, passwords, encryption keys and salts MUST NOT appear in Dart source, `AndroidManifest.xml`, `Info.plist`, Gradle files, or committed JSON/YAML.
Check: `rg -n "AIza[0-9A-Za-z_-]{30,}|sk_live|Bearer [A-Za-z0-9._-]{20,}|apiKey\s*[:=]\s*'" lib android/app/src ios/Runner` → must be empty.

**SEC-2** — Environment values MUST be supplied via `--dart-define-from-file` into one typed config object read once in the DI config module. `String.fromEnvironment` MUST NOT appear elsewhere.
Check: `rg -l "String.fromEnvironment" lib --glob '!**/config*/**'` → must be empty.

**SEC-3** — `config/*.json` (real values) MUST be gitignored; a `*.json.example` with key names MUST be committed.
Check: `git check-ignore config/dev.json` succeeds; `ls config/*.example`.

**SEC-4** — Runtime `.env` files bundled as assets MUST NOT be used for secrets.
Check: `rg -n "flutter_dotenv|\.env" pubspec.yaml`.

**SEC-5** — Client-side third-party keys that must ship (Maps, Firebase) MUST be restricted in the provider console to the app's bundle id / signing certificate; the restriction MUST be documented in the project README.

## Tokens and storage

**SEC-6** — Access tokens, refresh tokens and encryption keys MUST be stored in OS-backed secure storage (Keychain / Keystore via `flutter_secure_storage` or equivalent) behind the project storage interface. Obfuscation-grade schemes (keys derived from package name, constant IVs) MUST NOT be introduced.
Check: `rg -n "packageName|Platform\.(isAndroid|isIOS)|IV\.fromLength|IV\.fromUtf8" $CORE` → review key derivation.

**SEC-7** — Tokens MUST be transmitted only in HTTP headers or socket auth payloads, never in URLs.
Check: `rg -n "token=|\?token" lib` → must be empty.

**SEC-8** — Logout MUST clear every session-scoped key, in-memory session state, offline queues, socket connections, and sensitive caches.
Check: compare the session keys in the storage-keys class with the logout/clear-session body.

**SEC-9** — Sensitive cached data (messages, PII) MUST be encrypted at rest with a key held in secure storage, and MUST be cleared on logout / account deletion.

## Logging and telemetry

**SEC-10** — Logs MUST NOT contain tokens, FCM tokens, OTPs, passwords, phone numbers, emails, full request/response bodies with PII, full notification payloads, or URLs containing credentials — in any build mode.
Check: `rg -n "($LOGGER)\w*\(.*(token|Token|otp|password|phone|email|payload|url)" lib` → review each.

**SEC-11** — All logging MUST go through the project logger with environment-appropriate level filtering and redaction; debug/verbose output is disabled in release, while sanitized warning/error reporting follows PR-K1; `print` MUST NOT be used.
Check: `rg -n "^\s*print\(" lib` → must be empty.

**SEC-12** — Crash reporting MUST be wired exactly once for `FlutterError.onError` and `PlatformDispatcher.instance.onError` and MUST NOT attach PII as custom keys.
Check: `rg -c "FlutterError.onError =" lib` → 1.

## Network

**SEC-13** — HTTPS MUST be used for all endpoints; cleartext traffic MUST be disabled on Android.
Check: `rg -n "usesCleartextTraffic=\"true\"|http://" android/app/src/main/AndroidManifest.xml $CORE` → review.

**SEC-14** — TLS validation MUST NOT be bypassed in release; any development bypass MUST be compiled out with `kReleaseMode`.
Check: `rg -n -B5 "badCertificateCallback" lib` shows guard.

## Inputs

**SEC-15** — Deep links and notification payloads MUST be validated (host, path, id format, required fields) before navigation or data use; protected destinations MUST require an active session.
Check: review the deep-link handler and the notification-tap handler.

**SEC-16** — WebViews MUST load only allow-listed hosts and MUST NOT enable JavaScript bridges to app internals without review.

## Build and release

**SEC-17** — Release builds MUST be signed with a release keystore from a gitignored `key.properties`; `signingConfigs.debug` MUST NOT be used for `release`.
Check: `rg -n "signingConfig signingConfigs.debug|signingConfig = signingConfigs.debug" android/app/build.gradle*` → must be empty.

**SEC-18** — Release builds SHOULD be built with `--obfuscate --split-debug-info`; symbol files MUST be uploaded to the crash reporter.

**SEC-19** — Debug-only code paths (mock servers, test credentials, verbose interceptors) MUST be guarded by `kDebugMode` and verified absent from release.

**SEC-20** — Every declared permission and background mode MUST have a documented purpose in the project README; unused ones MUST be removed.
