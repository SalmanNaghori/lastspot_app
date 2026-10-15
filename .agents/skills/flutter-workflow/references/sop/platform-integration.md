# SOP: Platform Integration — Permissions, Push Notifications, Native Code

## Purpose

Integrate OS capabilities in a way that is predictable for users, passes store review, and keeps native details out of features.

## Scope

Runtime permissions, push notifications (FCM/APNs), local notifications, platform channels / FFI / Pigeon, background execution, app lifecycle, native configuration files. Guardrails: `../guardrails/platform.md` (PLAT-*), SEC-15, SEC-20, ROUTE-7, ASYNC-7.

## Principles

1. Each OS capability sits behind one Dart service with a typed API.
2. Ask for permissions only when the user understands why.
3. Every native touchpoint has a documented purpose (README) and a store-policy check.

## Standard

### Permissions (UNIVERSAL, HIGH)

- One `PermissionService` (wrapping `permission_handler` or platform APIs) returns a typed `PermissionStatus` (granted, denied, permanentlyDenied, restricted, limited).
- Flow: user action → (optional) in-app rationale → OS prompt → handle each status. Permanently denied → explain + button to app settings.
- iOS: every `NS*UsageDescription` in `Info.plist` is specific ("to scan receipts", not "app needs camera"); localized via `InfoPlist.strings` when the app is localized.
- Android: request only what the target SDK needs (e.g. photo picker instead of storage permission; `POST_NOTIFICATIONS` on 13+).
- README table: permission → purpose → feature → when requested (SEC-20).

### Push notifications (UNIVERSAL when used)

- One `PushService`: token registration/refresh, foreground display (local notification), tap handling for foreground/background/terminated (`getInitialMessage`).
- Tap → validate payload (SEC-15) → wait for app + session readiness (signal, not `Future.delayed`) → typed route (ROUTE-7).
- Logout: delete/unregister the token server-side.
- Payload contract (type, ids) documented in `docs/project/flutter/architecture-map.md`; unknown types ignored and logged.
- Notification channels (Android) defined once with ids as constants.

### Native code (UNIVERSAL)

- Prefer maintained plugins; write native code only when none fits (DEP-1).
- Platform channels: typed via **Pigeon** (RECOMMENDED) or a hand-written wrapper; channel names `com.example.app/<capability>`; `PlatformException` mapped to `Failure`.
- No `MethodChannel` in widgets/state holders (PLAT-5).

### Background and lifecycle (UNIVERSAL)

- Background work needs an ADR (what, why, OS limits, battery impact) (PLAT-6).
- Lifecycle via `AppLifecycleListener` in one place (e.g. session refresh on resume); features subscribe through a stream/bus.

## Recommended implementation

- A `capabilities/` (or `core/platform/`) folder with one service per capability: `permission_service.dart`, `push_service.dart`, `biometric_service.dart`, `share_service.dart`.
- A debug screen that shows current permission states and the push token (debug builds only).

## Anti-patterns

- Requesting camera, location and notifications on the splash screen.
- Navigating from a notification handler with `Future.delayed(Duration(seconds: 1))` "to wait for the app".
- Generic purpose strings that get rejected in review.

## Exceptions

OS-mandated startup prompts (e.g. ATT must precede tracking) follow the platform's rules; document them.
