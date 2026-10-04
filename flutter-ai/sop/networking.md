# SOP: Networking

## Purpose

One path for every network call, so authentication, retries, timeouts, offline behaviour, logging and error translation are implemented once.

## Scope

HTTP client, gateway abstraction, request description, interceptors, serialization hand-off, uploads/downloads, connectivity, offline queue, realtime transport hand-off.

## Principles

1. **Exactly one HTTP gateway.** Repositories talk to the gateway, never to the client.
2. **Requests are data.** Describe a call with a value object; the gateway executes it.
3. **Failure is a value**, returned as `Either<Failure, T>`, never thrown across the repository boundary.
4. **Cross-cutting behaviour lives in interceptors**, not in repositories.
5. **Parsing is the repository's job**, off the main thread when payloads are large.

## Standard

### Layering (UNIVERSAL, HIGH)

```text
Cubit → Repository (interface) → RepositoryImpl → [RemoteDataSource] → ApiService (gateway) → Dio → API
```

Forbidden edges: Widget → gateway, Widget → Dio, Cubit → Dio, Repository → raw Dio.

### Gateway (UNIVERSAL; reference: `BaseApiService` / `NetworkAPIImpl`, ADR-0005)

```dart
abstract class ApiService {
  Future<Either<Failure, dynamic>> execute(ApiRequest request);
}
```

Responsibilities: connectivity pre-check, URL resolution (base URL vs absolute public URL), executing the client call, catching every exception type (`DioException`, `SocketException`, `TypeError`, `FormatException`, fallback) and mapping to `Failure`. Nothing else.

### Request value object (UNIVERSAL; reference: `ApiRequest`)

Fields: `url`, `method`, `query`, `body`, `requiresAuth`, `onSendProgress`, `allowQueued`, `apiType` (private backend vs public third-party). Add per-request timeout override when needed for uploads.

### Endpoints (UNIVERSAL)

A single `ApiEndpoints` class with `static const` strings and `static String x(id)` functions. No inline URL strings in repositories. No duplicates (reference: `aboutUs` vs `aboutUsAPI` is LEGACY). Consistent leading slash convention.

### Interceptor chain (UNIVERSAL pattern; reference order is correct)

1. **Auth** — attach `Authorization: Bearer` when `extra['requiresAuth']`.
2. **Auth failure** — on 401 (except login endpoints) clear session and emit a logout event; handle 503 (maintenance) / 409 (force update) centrally.
3. **Retry** — idempotent methods only (GET/HEAD), bounded attempts, backoff, skip multipart.
4. **Logging** — debug builds only; redact `Authorization`, tokens, phone numbers, OTPs.

Token refresh, if the backend supports it, belongs in the auth-failure interceptor with a single-flight lock. The reference backend has no refresh (401 = logout); document this per project.

### Timeouts (RECOMMENDED)

Connect 15–30 s, receive 30 s, send 30 s; uploads override per request. The reference project's 120 s everywhere is NEEDS-DECISION (ND-14).

### Connectivity and offline (OPTIONAL, reference PROJECT-SPECIFIC)

- One connectivity abstraction (`NetworkMonitor`), one underlying package.
- Offline queue for idempotent mutations flagged `allowQueued`, keyed to de-duplicate, flushed on reconnect, cleared on logout. Do not queue reads or non-idempotent creates without an idempotency key.

### Serialization hand-off (UNIVERSAL)

Repository receives `dynamic` JSON from the gateway and parses with the model's `fromJson`. Large payloads parse in an isolate (`compute`). Parsing errors become `Failure`, not crashes. Reference: `UpdateUiMixin.backToUI` + `parseResponse` (PROJECT-SPECIFIC helper implementing this universal rule).

### Uploads / downloads (UNIVERSAL)

- Multipart via `FormData` + `MultipartFile.fromFile` with explicit `contentType`; progress via `onSendProgress`.
- Compress media before upload (reference: `video_compress`, `flutter_image_compress`).
- Downloads: stream to file with `onReceiveProgress`; never buffer large bodies in memory.

### TLS (UNIVERSAL, HIGH)

- No `badCertificateCallback` that returns `true` in release builds. Reference project trusts any cert for the staging host — must be compiled out (`kReleaseMode`) or removed (R8).
- Certificate pinning OPTIONAL; if used, pin via `SecurityContext` and plan rotation.

### Realtime (PROJECT-SPECIFIC pattern, RECOMMENDED shape)

Socket transport wrapped in a client class; a manager handles connect/auth/reconnect; handlers translate raw events to typed events on a bus. Auth token goes in headers/auth payload, **never** in the URL query string (reference violates this — R3).

## Recommended implementation

- Fail fast in the gateway if base URL is empty (config not injected).
- Add a `requestId` header for tracing.
- Expose `Failure.kind` (network / auth / server / parse / unknown) in addition to `statusCode` so UI can branch without magic numbers.

## Examples

Reference (good): `network_api_impl.dart` exception handling; `retry_interceptor.dart` idempotency guard; `orbits_repository_impl.dart` request construction.

Reference (fix): `dio_injection.dart` cert bypass; `socket_manager.dart:164-171` token in URL.

## Anti-patterns

- `Dio()` constructed anywhere outside the DI module.
- Repository catching `DioException` itself.
- Endpoint strings inline in repositories or widgets.
- Logging full request/response bodies in release.
- Two connectivity packages (`connectivity_plus` + `internet_connection_checker_plus`).

## Exceptions

Third-party public APIs (Google Places, Tenor) go through the same gateway with `apiType: public` and `requiresAuth: false`; API keys come from `AppConfiguration`, never literals.
