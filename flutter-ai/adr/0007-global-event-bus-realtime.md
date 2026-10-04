> **EXAMPLE ADR** (reference profile). Greenfield: write your own from TEMPLATE.md; do not copy these decisions unless this is that stack.

# ADR-0007: GlobalEventBus for realtime and cross-feature updates

- **Status:** Accepted
- **Date:** 2026-09-08 (reconstructed)
- **Decision owner:** Not determinable from repository evidence
- **Classification:** PROJECT-SPECIFIC; pattern RECOMMENDED for realtime-heavy apps

## Context

Socket events (new message, orbit created, member joined, connection request, session invalidated) must update many independent cubits (lists, details, badges, chat) without coupling them to each other or to the socket.

## Problem

How do realtime and cross-feature state changes propagate?

## Decision

- `GlobalEventBus` (`core/realtime/global_event_bus.dart`): a broadcast `StreamController<AppRealtimeEvent>` with `emit(event)` and `on<T>()`.
- Every event is a typed subclass of `AppRealtimeEvent` in `core/realtime/events/<domain>_realtime_event.dart`.
- Socket ingress: `SocketManager → SocketClient → GlobalSocketRouter → <Domain>SocketHandler` (in `data/globalUpdatesHandler/`) parses raw payloads and emits typed events.
- Subscribers use `EventSubscriberMixin.listenTo<T>(bus, handler)` and call `disposeSubscriptions()` in `close()`. Handlers check `isClosed` before `emit`.
- Local (non-socket) cross-feature updates (e.g. `CreatedNewOrbitEvent` after a successful create) use the same bus.
- Cubits never call other cubits directly.
- Chat message list uses a richer path: `RealtimeMessages` (domain/realtime) + use cases + `ChatMessageListStateReducer`; page size 20 (differs from the project default 10) — accepted for chat only.

## Evidence

- `orbit_list_cubit.dart:126-230` subscribes to 11 event types.
- `SocketManager` reconnect/auth flow; `AuthFailureInterceptor` emits `LogoutEvent` on the same bus.
- Reason for a custom bus over `Stream`-per-repository: **Not determinable from repository evidence.**

## Alternatives considered

| Alternative | Why not |
|-------------|---------|
| Repository-exposed streams per entity | Requires each cubit to know each repository stream; bus decouples producers and consumers. |
| `event_bus` package | Trivial to hand-roll (14 lines); avoids a dependency. |
| Blocs listening to other blocs | Direct coupling; forbidden by `guardrails/state-management.md`. |

## Consequences

- Positive: producers and consumers decoupled; realtime and local updates share one path; easy to test by emitting events.
- Negative: untyped-by-topic global channel can become a hidden dependency; subscription leaks if `disposeSubscriptions` is forgotten (R11 bug: list not cleared); event ordering not guaranteed across handlers.
- Rules: `sop/async-programming.md`, `sop/state-management.md` §Cross-feature, `guardrails/state-management.md`, `project/project-rules.md` PR-C4.

## Migration

None.

## Review trigger

If event types exceed ~100 or ordering bugs appear, consider per-domain buses or a typed channel per feature.
