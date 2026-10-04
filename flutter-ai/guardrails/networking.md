# Guardrails: Networking and Error Handling

SOP: `sop/networking.md`, `sop/repository.md`, `sop/error-handling.md`, `sop/models-and-data.md`.

## Networking

**NET-1** — All HTTP MUST go through the single API gateway (`BaseApiService` in the reference). The HTTP client (`Dio`) MUST NOT be imported or constructed outside `core/network` and the DI module.
Check: `rg -l "package:dio/|Dio\(" lib --glob '!**/core/network/**' --glob '!**/core/di/**'` → must be empty.

**NET-2** — Only repository implementations and remote data sources MAY call the gateway. Cubits, Blocs, widgets, helpers MUST NOT.
Check: `rg -l "executeAPI|BaseApiService" lib/layers/presentation lib/layers/domain --glob '!**/repositories/**'` → must be empty.

**NET-3** — Every endpoint MUST be a constant or function on the central endpoints class. Inline URL strings in repositories/widgets MUST NOT exist. Duplicate constants for one endpoint MUST NOT be added.
Check: `rg -n "url: '" lib/layers/data` and `rg -n "https?://" lib/layers/data lib/layers/presentation --glob '!**/api_endpoints.dart'`.

**NET-4** — Requests MUST be described with the request value object (`ApiRequest`); `requiresAuth` MUST be `false` for public/third-party endpoints and login/OTP endpoints.

**NET-5** — Auth headers, 401 handling, retry, and logging MUST be implemented as interceptors, not in repositories.
Check: `rg -n "Authorization|statusCode == 401" lib/layers/data` → must be empty.

**NET-6** — Retry MUST apply only to idempotent methods (GET/HEAD) and MUST NOT retry multipart uploads.

**NET-7** — Request/response logging MUST be enabled only under `kDebugMode` and MUST redact credentials.
Check: `rg -n "PrettyDioLogger|LogInterceptor" lib` shows a `kDebugMode`/`enabled:` guard.

**NET-8** — `badCertificateCallback` MUST NOT return `true` in release builds. Any development bypass MUST be guarded by `kDebugMode`/`!kReleaseMode`.
Check: `rg -n -B3 "badCertificateCallback" lib` shows the guard. (Reference violation: `dio_injection.dart`, R8.)

**NET-9** — Tokens MUST be sent in headers or auth payloads, never in URL query strings (HTTP or socket).
Check: `rg -n "token=|\?token|'token': " lib/layers/core` → must be empty. (Reference violation: `socket_manager.dart`, R3.)

**NET-10** — Timeouts MUST be set explicitly; defaults SHOULD be ≤ 30 s with per-request overrides for uploads.

**NET-11** — Exactly one connectivity abstraction and one underlying package MUST be used.
Check: `rg -l "package:connectivity_plus/" lib` should be empty once ND-4 is executed.

**NET-12** — Parsing of large payloads SHOULD happen off the main isolate; parsing MUST never throw across the repository boundary.

## Repository boundary

**ERR-1** — Every repository method MUST return `Future<Either<Failure, T>>` (or `Stream<T>`). Repositories MUST NOT throw and MUST NOT return raw `Map`/`dynamic`.
Check: `rg -n "Future<(?!Either)" lib/layers/domain/repositories` → must be empty.

**ERR-2** — Cubits/Blocs MUST NOT wrap repository calls in `try/catch`; failure arrives as `Left(Failure)`.
Check: `rg -n "try \{" lib/layers/presentation/{cubit,bloc}` → review each; only non-repository async work permitted.

**ERR-3** — Empty catch blocks MUST NOT exist. Every `catch` MUST return a `Failure`, rethrow, or log with context **and** a comment documenting why continuing is safe.
Check: `rg -n -U "catch \([^)]*\)\s*\{\s*\}" lib`; `rg -n "catch \(_\)" lib`.

**ERR-4** — Users MUST NOT be shown raw exception text or stack traces. `Failure.error` MUST be a user-safe message; details go to logs.
Check: `rg -n "Failure\('.*\$e" lib` → review. (Reference: `update_ui_mixin.dart` parse error message.)

**ERR-5** — `FlutterError.onError` and `PlatformDispatcher.instance.onError` MUST each be assigned exactly once, and both MUST forward to the crash reporter in release.
Check: `rg -c "FlutterError.onError =" lib` → 1. (Reference: 3, R1.)

**ERR-6** — Logging MUST use the project logger; `print` MUST NOT appear in `lib/`.
Check: `rg -n "^\s*print\(" lib` → must be empty (lint `avoid_print`).

**ERR-7** — Validation errors MUST be state (field errors), not `Failure`s and not toasts-only.

## Models

**ERR-8** — A project MUST use one serialization stack for new models (`freezed` + `json_serializable`). Legacy generators MUST NOT receive new models.
Check: new files under `lib/generated/json/` in a PR → violation.

**ERR-9** — Model parsing MUST tolerate missing/unknown fields (defaults, nullable, `unknownEnumValue`); UI MUST NOT `!` parsed values.

## Reference project status

Tracked: R1, R3, R8, R25 (timeouts), R31 (endpoint duplicates), ND-4, ND-5, ND-14.
