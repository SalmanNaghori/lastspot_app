# SOP: Error Handling

## Purpose

Every failure is caught once, translated once, represented once, and shown once — with no silent losses.

## Scope

Network, HTTP, auth/authz, validation, parsing, timeouts, storage, platform, unknown errors; propagation from gateway to UI; logging and crash reporting.

## Principles

1. **Failures are values at layer boundaries** (`Either<Failure, T>`); exceptions are for programming errors.
2. **Translate at the edge where the error originates**: Dio errors in the gateway, storage errors in the data source, parse errors in the parser.
3. **Never swallow**: every catch either returns a `Failure`, rethrows, or logs with context and a documented reason for continuing.
4. **The user sees a message; the developer sees a stack trace.** Don't confuse the two.
5. **UI-specific error rendering never leaks into data layers.**

## Standard

### Failure type (UNIVERSAL, HIGH)

```dart
class Failure extends Equatable {
  const Failure(this.error, {this.statusCode = unExpectedErrorCode, this.kind = FailureKind.unknown});
  final String error;       // user-safe message
  final int statusCode;     // HTTP or app code
  final FailureKind kind;   // RECOMMENDED addition
}
enum FailureKind { network, timeout, unauthorized, forbidden, validation, notFound, server, parse, storage, unknown }
```

Reference project has `Failure(error, statusCode)` with app codes 101 (unexpected), 110 (no internet), -1 (timeout). Adding `kind` is RECOMMENDED so UI branches on an enum rather than magic numbers.

### Translation table (UNIVERSAL)

| Source | Where caught | Becomes |
|--------|--------------|---------|
| `DioExceptionType.connectionError`, `SocketException` | gateway | `Failure(kind: network, code: noInternet)` |
| `connectionTimeout` / `receiveTimeout` | gateway | `Failure(kind: timeout)` |
| HTTP 4xx/5xx `badResponse` | gateway error mapper | message from body `error`/`message`, `statusCode` from response; 401 → `unauthorized` (also handled by interceptor), 403 → `forbidden`, 422 → `validation` |
| HTML body (proxy/ngrok) | mapper | server failure with generic message (reference handles this — good) |
| `TypeError`, `FormatException` while parsing | parser (`backToUI`) | `Failure(kind: parse)` — log full details, show generic message |
| Hive / storage exceptions | data source | `Failure(kind: storage)` |
| Platform plugin errors (permissions, camera) | service/helper wrapping the plugin | `Failure` or typed result |
| Anything else | gateway/parser fallback `catch (e, st)` | `Failure(kind: unknown)` + `recordError` |

### Propagation (UNIVERSAL)

```text
gateway → left(Failure) → repository (passes through or enriches) → Cubit.fold
  → emit(status: failure|noInternet, error, errorCode)
  → BlocListener: toast / error view / redirect (401)
```

- Cubits never `try/catch` around repository calls (the repository already returns `Either`). They may catch around non-repository async work (platform plugins) and must convert to state.
- 401 is handled centrally by the auth-failure interceptor (clear session, emit logout event); Cubits do not special-case it.

### Catch discipline (UNIVERSAL, HIGH)

Allowed shapes:

```dart
} on DioException catch (e) { return left(_mapper.map(e)); }        // translate
} catch (e, st) { DebugLog.e('ctx', e, st); return left(Failure(...)); }  // translate + log
} catch (e, st) { DebugLog.w('cache miss, continuing', e, st); /* documented fallback */ }
```

Forbidden: `catch (_) {}`, `catch (e) { print(e); }` with no return/rethrow/documented fallback, catching to return a fake success. Reference has 4 empty catches and ~43 log-only catches (audit §10) — new code may not add any.

### Validation errors (UNIVERSAL)

- Client-side validation results are **state**, not failures: `fieldErrors: {'phone': 'Invalid number'}`.
- Server-side 422 payloads are mapped to the same `fieldErrors` shape by the repository.

### Storage errors (UNIVERSAL)

Cache read failures degrade to "no cache" and log; cache write failures log and do not fail the user action unless the feature is offline-first.

### Unknown / global (UNIVERSAL, HIGH)

- `FlutterError.onError` and `PlatformDispatcher.instance.onError` set **once**, both logging to console in debug and recording to Crashlytics (or equivalent). Reference sets `FlutterError.onError` three times, last one dropping Crashlytics (R1).
- `runZonedGuarded` wraps `runApp`.
- Background isolates set their own handlers.

### Presenting errors (UNIVERSAL)

| Situation | UI |
|-----------|----|
| Failure, no data | error view with retry button |
| Failure, data present | toast/snackbar, keep data |
| No internet | dedicated offline view/banner; auto-retry on restore |
| 401 | interceptor logs out; router guard redirects |
| Validation | inline field error |
| Parse/unknown | generic "Something went wrong" + retry; details only in logs |

Messages come from the string constants/l10n, never raw exception text (reference `Failure('Parse error: $e\n$st')` leaks stack traces into `state.error` — fix by logging the trace and returning a generic message).

## Recommended implementation

- `Failure.kind` enum + `extension FailureX on Failure { bool get isNoInternet; bool get isAuth; }`.
- Sealed `Failure` subclasses OPTIONAL when UI needs exhaustive handling.
- A `Result` extension on `Either` for `getOrElse`, `fold` shortcuts (reference: `either_extension_function.dart`).

## Examples

Good (reference): `network_api_impl.dart:62-100` — catches Dio/Socket/Type/Format/fallback separately; `BaseCubit.handleFailure` distinguishes no-internet and "has data".

Fix (reference): `app_initializer.dart:40-49`; empty catches listed in audit §10; `update_ui_mixin.dart:55` stack trace in user message.

## Anti-patterns

- Empty catch blocks.
- Swallowing and returning a default that looks like success.
- Throwing across the repository boundary.
- UI (toast/dialog) inside repository or data source.
- Showing exception `toString()` to users.

## Exceptions

Fire-and-forget telemetry may swallow its own errors after logging at debug level; mark with `// telemetry: best effort`.
