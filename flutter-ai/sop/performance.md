# SOP: Performance

## Purpose

Keep the app at 60/120 fps and startup fast by following a small set of required rules, applying recommended optimisations where they matter, and refusing premature ones.

## Scope

Widget rebuilds, Bloc rebuilds, lists, images, JSON, pagination, memory, streams, animations, startup, build methods.

## Principles

1. **Measure before optimising** (DevTools performance overlay, timeline, memory).
2. **Required rules are cheap and always apply.** Recommended rules apply where profiling or scale says so. Premature rules are refused in review.
3. **Don't do work in `build`.**

## Standard

### Required (UNIVERSAL, HIGH)

| Rule | Why |
|------|-----|
| `const` constructors and `const` widget instances wherever possible (`prefer_const_constructors` lint on — reference has it) | skips rebuilds |
| `ListView.builder` / `SliverList` / `GridView.builder` for unbounded or > ~20 items | lazy build |
| Stable `Key`s for list items with state or reordering | correct element reuse |
| Scope Bloc rebuilds: `BlocBuilder` with `buildWhen`, or `BlocSelector`, on the smallest subtree | avoids whole-screen rebuilds |
| No network, storage, heavy computation, or `await` in `build` | jank |
| Cancel subscriptions/timers/controllers in `dispose`/`close` | memory leaks |
| Network images through the cached wrapper with `memCacheWidth`/`cacheWidth` for large images | memory |
| JSON parse of large payloads off the main isolate (`compute`) | frame drops |
| Paginate every server list; never fetch "all" | memory + latency |
| Dispose `TextEditingController`, `ScrollController`, `AnimationController`, `FocusNode` | leaks |

### Recommended (apply when profiling or scale justifies)

| Optimisation | When |
|--------------|------|
| `RepaintBoundary` around maps, videos, complex canvases (reference does this for maps) | isolated repaint areas |
| `AutomaticKeepAliveClientMixin` for tab bodies | expensive tabs |
| `ValueListenableBuilder`/`ValueNotifier` for high-frequency values (audio position) | > ~10 updates/s |
| Precache images / fonts for first screens | visible startup jank |
| Deferred initialisation of heavy services after first frame (`addPostFrameCallback`) | startup > 1.5 s |
| `Image.asset(cacheWidth:)` and downscaled thumbnails for grids | large media grids |
| Debounce search 300–600 ms; throttle scroll handlers | high-frequency input |
| `compute` for image manipulation, or native plugins | UI thread saturation |
| Lazy Hive box opening per feature | many boxes |
| Marker/asset caches for maps (reference `MarkerUtils`) | repeated bitmap decoding |

### Premature (refuse in review unless profiled)

- Splitting every widget into its own file "for performance".
- Custom `shouldRebuild` logic on small trees.
- Replacing `flutter_bloc` with a "faster" library.
- Hand-rolled image caches when the wrapper already caches.
- Micro-optimising `copyWith` calls.
- Isolates for < 10 ms work.

### Startup (RECOMMENDED)

- Only what the first screen needs before `runApp`; everything else after first frame or on demand.
- Firebase init and DI setup are acceptable before `runApp`; heavy Hive box opening and socket connect should be deferred (reference opens all boxes at boot — review).
- Measure with `flutter run --trace-startup`.

### Memory (UNIVERSAL)

- Watch for retained `BuildContext`, closures capturing `State`, global caches without bounds (reference `MarkerUtils` global cache — add bounds/eviction).
- Long-lived singletons holding large lists (chat cache) need eviction policies.

### Animations (RECOMMENDED)

- Implicit animations (`AnimatedContainer`) for simple cases; `AnimationController` disposed; avoid animating layout of large lists.
- Lottie files kept small; cache compositions.

## Recommended implementation

- Enable `flutter_lints` performance-related rules (`prefer_const_*`, `avoid_unnecessary_containers`, `use_key_in_widget_constructors`).
- Add a periodic profiling session per release on a low-end Android device.

## Examples

Good (reference): `RepaintBoundary` on Google Maps; `compute` parsing; `ListView.builder` in home; `EasyDebounce` in search cubits.

Fix (reference): 896 `context.read` / 7 `BlocSelector` suggests wide rebuilds — migrate hot screens (chat, home) to `BlocSelector`/`buildWhen`; uncancelled subscriptions (R10); unbounded marker cache.

## Anti-patterns

- `ListView(children: list.map(...).toList())` for server lists.
- `MediaQuery.of(context)` in deep leaf widgets (use `MediaQuery.sizeOf`).
- Rebuilding a `Scaffold` because a text field changed.
- `Future.delayed` polling loops.

## Exceptions

Prototype screens may skip pagination if the dataset is provably bounded (< 50 items) and documented.
