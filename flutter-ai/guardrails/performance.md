# Guardrails: Performance and Async

SOP: `sop/performance.md`, `sop/async-programming.md`.

## Performance

**PERF-1** — Unbounded or server-backed lists MUST use builder-based widgets (`ListView.builder`, `SliverList`, `GridView.builder`) and MUST be paginated.
Check: `rg -n "ListView\(\s*$|ListView\(children" lib/layers/presentation/ui` → review.

**PERF-2** — `build` methods MUST NOT perform network, storage, decryption, JSON parsing, or O(n) work over large collections.
Check: `rg -n "jsonDecode|decryptString|\.sort\(|await " lib/layers/presentation/ui` inside `build` → review.

**PERF-3** — Bloc-driven rebuilds SHOULD be scoped with `BlocSelector` or `buildWhen`; a whole-screen `BlocBuilder` for a field-level change SHOULD NOT be used on hot screens (lists, chat).

**PERF-4** — `const` constructors MUST be declared where possible and `const` instances used (`prefer_const_constructors`, `prefer_const_declarations` lints enabled and clean).

**PERF-5** — Large network images MUST specify a memory cache size (`memCacheWidth`/`cacheWidth`) via the image wrapper; large JSON payloads SHOULD be parsed via `compute`.

**PERF-6** — Global in-memory caches (markers, images, messages) MUST have a bound or eviction policy.
Check: `rg -n "static final Map|static final List" lib` → review each for eviction.

**PERF-7** — List items with per-item state or reordering MUST have stable `Key`s (`ValueKey(id)`).

**PERF-8** — Premature optimisation (per-widget files "for performance", custom rebuild schedulers, hand-rolled caches duplicating library caches) MUST NOT be introduced without a profiling result attached to the PR.

## Async and lifecycle

**ASYNC-1** — Every `StreamSubscription` MUST be stored and cancelled in `dispose()`/`close()`. `.listen(` without an owner MUST NOT exist.
Check: files containing `.listen(` must contain `cancel()`; `rg -n "\.listen\(" lib | rg -v "_sub|Subscription|listenTo"` → review. (Reference violations R10.)

**ASYNC-2** — Every `Timer`, `AnimationController`, `TextEditingController`, `ScrollController`, `FocusNode`, `StreamController` MUST be disposed/cancelled by its owner.
Check: `rg -n "Timer\.periodic|Timer\(" lib` → owner has `cancel()`.

**ASYNC-3** — After every `await` in a `State`, `mounted` MUST be checked before using `context` or `setState`.
Check: lint `use_build_context_synchronously` enabled and clean.

**ASYNC-4** — Returned `Future`s MUST NOT be silently dropped; use `await` or `unawaited()` with a comment.
Check: lint `unawaited_futures` enabled.

**ASYNC-5** — `Future.delayed` MUST NOT be used as a readiness/synchronisation mechanism. It MAY be used for intentional UX timing with a named constant and comment.
Check: `rg -n "Future.delayed" lib` → each hit is either a named UX constant or a violation. (Reference: ~50, R23.)

**ASYNC-6** — Superseded async work (search, filters) MUST ignore stale results (request id / cancel token) so an older response cannot overwrite a newer one.

**ASYNC-7** — Background isolates MUST NOT access UI, the main DI container, or main-isolate singletons; they MUST build their own minimal dependencies.

**ASYNC-8** — Subscription helper mixins MUST cancel **and clear** their subscription lists so re-subscription after dispose does not leak.
Check: `event_subscriber_mixin.dart` `disposeSubscriptions` contains `clear()`. (Reference: R11.)

**ASYNC-9** — Long-lived services (queues, socket managers, notification managers) MUST expose `dispose()` and MUST be registered with `dispose:` in the container.
Check: `rg -n "registerLazySingleton\(" lib/layers/core/di | rg -v "dispose:"` → review each for owned resources.

## Reference project status

Tracked: R10, R11, R23; hot-screen rebuild scoping (7 `BlocSelector` vs 896 `context.read`); unbounded `MarkerUtils` cache.
