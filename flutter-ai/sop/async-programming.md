# SOP: Async Programming

## Purpose

Asynchronous code that cannot leak, race, or emit into a dead object.

## Scope

Futures, streams, subscriptions, cancellation, debounce/throttle, concurrency policies, isolates, timers, lifecycle and disposal.

## Principles

1. **Every subscription has an owner and a cancellation point.**
2. **Every `await` is a lifecycle boundary**: check the owner is still alive before acting.
3. **Time-based waits are not synchronisation.** Wait for a signal, not a duration.
4. **Heavy work leaves the main isolate.**
5. **One debounce mechanism per project.**

## Standard

### Futures (UNIVERSAL, HIGH)

- Prefer `async/await` over `.then` chains.
- Never ignore a returned `Future`. Use `await`, or `unawaited(...)` with a comment saying why fire-and-forget is safe (reference uses `unawaited` for uploads — correct).
- In Cubits: `if (isClosed) return;` after every `await`. In `State`: `if (!mounted) return;` before using `context` or `setState` after an `await`.
- Parallel independent calls: `Future.wait([...])`, with per-call `Either` so one failure does not discard the others.

### Streams and subscriptions (UNIVERSAL, HIGH)

```dart
class FooCubit extends Cubit<FooState> {
  StreamSubscription<Bar>? _barSub;
  FooCubit(this._repo) : super(const FooState()) {
    _barSub = _repo.watchBars().listen((bars) {
      if (isClosed) return;
      emit(state.copyWith(bars: bars));
    });
  }
  @override
  Future<void> close() async {
    await _barSub?.cancel();
    return super.close();
  }
}
```

- Store every `StreamSubscription`; cancel in `close()` / `dispose()`. Reference leaks: `NetworkRequestQueue`, `NotificationManager`, `NotificationRemoteDataSource`, `VerifyOTPScreen`, `selfie_camera_screen` (R10).
- Broadcast streams for many listeners; single-subscription otherwise.
- A subscription helper mixin (reference `EventSubscriberMixin`) must both cancel **and clear** its list (R11).
- Never `listen` inside `build`.

### Cancellation (UNIVERSAL)

- Long-running requests that can be superseded (search) carry a request id or `CancelToken`; stale results are ignored (`if (requestId != _latest) return;`).
- Uploads expose a `CancelToken` through the repository when the UI offers cancel.

### Debounce / throttle (UNIVERSAL)

- Search input: debounce 300–600 ms in the Cubit.
- Scroll/pagination triggers: throttle or guard with status.
- One mechanism (`easy_debounce` in reference; a `Timer` field is acceptable at L1). Cancel in `close()`.

### Concurrency policies (RECOMMENDED)

| Intent | Policy |
|--------|--------|
| Submit / create / delete | droppable — ignore while in flight |
| Search / filter | restartable — latest wins |
| Ordered mutations (send messages) | sequential queue |
| Independent reads | concurrent |

Implement via `bloc_concurrency` transformers in Blocs, or status guards + request ids in Cubits (see `bloc.md`).

### Timers and `Future.delayed` (UNIVERSAL, HIGH)

- `Future.delayed` is acceptable only for **intentional UX delays** (splash minimum, animation sequencing), never to wait for another component to be ready. Reference has ~50 uses, many as readiness hacks (cold-start notification 1 s, deep link 400–500 ms) — ANTI-PATTERN (R23). Replace with a `Completer`/`onAppReady` signal or a stream event.
- `Timer`/`Timer.periodic` stored in a field and cancelled in `dispose()`.

### Isolates (RECOMMENDED)

- JSON decode/parse of large payloads via `compute` (reference: `parseResponse` for > 50 keys, Dio `BackgroundTransformer` — good).
- Image/video processing in isolates or native plugins.
- Background isolates (FCM handler, background location) build their own minimal dependency graph and never touch UI or the main container.

### Lifecycle (UNIVERSAL)

- `WidgetsBindingObserver` registered in `initState`, removed in `dispose` (reference `OrbitListTabScreen` does this correctly).
- App-level lifecycle handler (reference `AppLifeCycleHandler`) is the single place reacting to foreground/background for sockets, badges, caches.
- Tab/router listeners (`TabsRouter.addListener`) removed in `dispose`.

### Race conditions checklist (UNIVERSAL)

- Two fetches in flight → guard with status or request id.
- Realtime event arrives during initial load → reducer must merge, not overwrite (reference chat reducer handles this).
- Logout during request → interceptor + `isClosed` handle it; never emit user data after logout event.

## Recommended implementation

- `mixin SubscriptionOwner` with `addSub(StreamSubscription)` and `cancelAll()` used by Cubits and services.
- A `lint` rule `unawaited_futures` (from `flutter_lints` extras / `very_good_analysis`) enabled.

## Examples

Good: `orbit_list_cubit.dart` `close()` cancels debounce and subscriptions; `BaseCubit.close()` cancels network subscription.

Fix: `network_request_queue.dart:28-32` unstored listen; `event_subscriber_mixin.dart:17-21` no clear.

## Anti-patterns

- `Future.delayed(const Duration(milliseconds: 500), () => navigate())` to "let the router settle".
- `.listen(...)` without storing the subscription.
- `emit` after `await` without `isClosed`.
- `setState` after `await` without `mounted`.
- Periodic timers never cancelled.

## Exceptions

Splash-screen minimum display time and staggered entrance animations may use `Future.delayed` with a named constant and a comment.
