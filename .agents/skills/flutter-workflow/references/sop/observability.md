# SOP: Observability — Logging, Crash Reporting, Analytics

## Purpose

Know when the app breaks in production and what users do, without leaking personal data.

## Scope

Logger, log levels, crash/non-fatal reporting, breadcrumbs, performance traces, product analytics, consent. Guardrails: `../guardrails/observability.md` (OBS-*), ERR-5, ERR-6, SEC-10..12. Decision: ND-11.

## Principles

1. One logger, one crash reporter, one analytics interface — vendors are swappable behind them.
2. Production signals are structured and PII-free.
3. Debug verbosity never ships.

## Standard

### Logger (UNIVERSAL, HIGH)

- One `AppLogger` (wrapping `logger`, `logging`, or `dart:developer`), injected or accessed via a top-level instance created at bootstrap.
- Levels: `trace` (dev only), `debug`, `info` (lifecycle), `warning` (recoverable), `error` (failure). Release: `warning+` forwarded to the crash reporter as breadcrumbs/non-fatals; nothing to console.
- Message format: `'<Class.method> <what happened>'` + structured fields; errors with `error` and `stackTrace` arguments.

### Crash reporting (UNIVERSAL, HIGH)

```dart
Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await bootstrap();                                  // config, DI, crash reporter
    FlutterError.onError = crashReporter.recordFlutterError;          // once (ERR-5)
    PlatformDispatcher.instance.onError = (e, st) { crashReporter.recordFatal(e, st); return true; };
    runApp(const App());
  }, (e, st) => crashReporter.recordFatal(e, st));
}
```

- Disabled (or a separate project) for dev/staging flavors.
- Symbols / debug info uploaded on every release build (SEC-18).
- Non-fatals for degraded-but-handled failures (OBS-3) with keys `feature`, `operation`, `failure_kind`.

### Analytics (RECOMMENDED when the product needs it)

- `AnalyticsService` interface with typed methods or an `AnalyticsEvent` sealed class; vendor SDK only in its implementation.
- Tracking plan in the project (`docs/project/flutter/tracking-plan.md` or the analytics tool): event name, trigger, parameters, owner.
- Screen views tracked once, centrally (router observer), not per screen.

### Privacy and consent (UNIVERSAL)

- No PII/tokens/payloads in logs, keys, breadcrumbs or events (OBS-4, SEC-10). Use an opaque user id.
- If consent is required (GDPR/ePrivacy, ATT for tracking on iOS), collection starts only after consent, and is stopped on withdrawal (OBS-6).
- Store disclosures (privacy labels, Data safety) list every SDK that collects data (REL-4).

### Performance monitoring (OPTIONAL)

- Startup trace, screen render traces for hot screens, network traces from the HTTP interceptor — only if a budget exists to act on them (`performance.md`).

## Anti-patterns

- `print` / `debugPrint` left in code; HTTP body logging in release.
- Calling `FirebaseCrashlytics.instance` / `FirebaseAnalytics.instance` from widgets.
- `logEvent('Clicked Button 2')` — free-text event names.

## Exceptions

Debug-only diagnostic screens may show verbose logs behind `kDebugMode`.
