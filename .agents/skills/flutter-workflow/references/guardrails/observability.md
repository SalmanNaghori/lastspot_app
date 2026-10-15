# Guardrails: Observability (Logging, Crash Reporting, Analytics)

SOP: `sop/observability.md`. Related: ERR-5, ERR-6, SEC-10..12.

**OBS-1** — All diagnostics MUST go through one project logger with levels (`trace/debug/info/warning/error`). Release builds MUST log only `warning+` and only to the crash reporter / remote sink — never to the device console.
Check: `rg -n "^\s*(print|debugPrint)\(" lib` → empty; logger configuration shows a release level.

**OBS-2** — Crash reporting MUST be initialised once before `runApp` inside a guarded zone, wiring `FlutterError.onError`, `PlatformDispatcher.instance.onError` and isolate errors; it MUST be disabled or tagged for non-production flavors.

**OBS-3** — Non-fatal errors that degrade the user experience (failed payments, sync failures, parse failures) MUST be recorded as non-fatals with context (feature, operation, failure kind) — not just logged locally.

**OBS-4** — Logs, crash custom keys, breadcrumbs and analytics events MUST NOT contain PII, tokens or payloads (SEC-10). User identification, if used, MUST be an opaque internal id.

**OBS-5** — Analytics MUST go through one analytics interface (not the vendor SDK from feature code). Event names and parameters MUST be constants in a tracking plan (`snake_case`, ≤ 40 chars, documented in the project). Ad-hoc string events MUST NOT be added.
Check: `rg -n "FirebaseAnalytics\.instance|Mixpanel|Amplitude" lib --glob '!**/analytics/**'` → must be empty.

**OBS-6** — Collection that requires consent (analytics, crash reporting where applicable, ad ids) MUST respect the user's consent state before the first event and MUST stop when consent is withdrawn; the consent requirement is recorded in `docs/project/flutter/project-rules.md`.
