# Guardrails: Platform Integration (Permissions, Push, Native)

SOP: `sop/platform-integration.md`. Related: SEC-15, SEC-20, ROUTE-7.

**PLAT-1** — Every runtime permission MUST have a user-facing purpose string (iOS `NS*UsageDescription`, Android rationale) from the string source and a documented purpose in the project README (SEC-20). Unused permissions MUST be removed.
Check: diff to `Info.plist` / `AndroidManifest.xml` adding a permission → README + purpose string updated.

**PLAT-2** — Permissions MUST be requested just-in-time from a user action, behind one permission service; requesting at app start (except where the OS requires it) MUST NOT be added.

**PLAT-3** — Every permission flow MUST handle granted, denied, permanently denied (deep-link to settings), restricted/limited (iOS photos, approximate location) states; the feature MUST degrade gracefully when denied.

**PLAT-4** — Push notification payloads MUST be validated before use (ROUTE-7); tapping a notification MUST route through the typed router after app/session readiness; foreground, background and terminated states MUST each be handled. Device tokens MUST be refreshed on rotation and unregistered on logout.

**PLAT-5** — Platform channels MUST be wrapped in one Dart service per capability (typed API, mapped errors → `Failure`); `MethodChannel` calls MUST NOT appear in widgets or state holders. Channel names MUST be constants prefixed with the app id.
Check: `rg -n "MethodChannel\(|EventChannel\(" $PRES $STATE` → must be empty.

**PLAT-6** — Background work (background fetch, WorkManager, background location, audio) MUST be declared, justified in an ADR, and limited to what store policies allow; background isolates follow ASYNC-7.
