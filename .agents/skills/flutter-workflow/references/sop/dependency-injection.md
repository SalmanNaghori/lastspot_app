# SOP: Dependency Injection

Applicability: read `../REPOSEED.md`. Package APIs and helper names below are examples conditional on this app's recorded choices; do not adopt a reference-app package or class by copying an example.


## Purpose

Make every class's collaborators visible in its constructor so it can be understood, replaced, and tested without a widget tree or a live backend.

## Scope

Constructor injection, the composition root, service locator usage, lifecycles, scoping, testing.

## Principles

1. **Constructor injection is the rule.** A class lists what it needs; something else decides what it gets.
2. **One composition root.** Resolution happens at the edges (DI modules, `BlocProvider.create`, route wrappers, app boot), never in the middle.
3. **Depend on abstractions across layers**, concretes within a layer.
4. **Lifecycle is explicit**: singleton, lazy singleton, factory — chosen per type, disposed when owned.
5. **No hidden globals.** A global `BuildContext`, a static mutable field, or `Hive.box('name')` inside a class body are all dependencies in disguise.

## Standard

### Container (RECOMMENDED; PROJECT-SPECIFIC choice recorded in an ADR + PR-B1)

- L1: none; construct in `main.dart` and pass down.
- L2+: a container (`get_it` RECOMMENDED for its simplicity) **or** generated wiring (`injectable`). One per project.
- Expose one alias (e.g. `sl` for get_it) and never call `GetIt.I` elsewhere.

### Registration (UNIVERSAL, HIGH)

| Type | Lifetime | Registration |
|------|----------|--------------|
| Config, app-level services, repositories, data sources, gateways, buses | Lazy singleton (`registerLazySingleton`), with `dispose:` when it owns resources | one instance, created on first use |
| Blocs / Cubits | Factory (`registerFactory`) | new instance per `BlocProvider`, which closes it |
| Eager infrastructure that must exist before others (config, bus) | `registerSingleton` | created at boot |

Split registrations into modules by kind and call them in dependency order from one `setupLocator()`. Document the order (a comment block at the top of the setup function).

```dart
sl.registerLazySingleton<ProductsRepository>(
  () => ProductsRepositoryImpl(apiService: sl(), messaging: sl()),
);
sl.registerFactory(() => ProductListCubit(repository: sl(), bus: sl(), networkMonitor: sl()));
```

### Resolution points — where container lookups (e.g. `sl<>()`) are allowed (UNIVERSAL, HIGH)

| Allowed | Not allowed |
|---------|-------------|
| DI modules | Widget `build`, `initState`, UI helpers |
| `BlocProvider(create: (_) => sl<X>())` | Cubit/Bloc method bodies |
| `AutoRouteWrapper.wrappedRoute` | Repository / data source bodies |
| App bootstrap (`AppInitializer`, `AppBootStartup`, splash) | Domain services / policies |
| Background isolate entry points (must build their own graph) | Extension methods |

If a widget needs a value (current user id, a config URL), it comes from **state** (a Cubit exposes it) or from a **constructor parameter**, not from a container lookup such as `sl<SessionProvider>().userId` (ANTI-PATTERN).

### Injecting into widgets (UNIVERSAL)

- Screens: get their Cubit via `BlocProvider` in the route wrapper.
- Reusable widgets: take values and callbacks as constructor parameters. Never resolve services.
- Dialogs/sheets opened via `showModalBottomSheet`: pass `BlocProvider.value(value: context.read<X>())` to carry the existing instance.

### Testing (UNIVERSAL)

- Unit tests construct the class directly with mocks; the container is not involved.
- Widget tests wrap with `BlocProvider.value(value: mockCubit)`.
- If the container must be used (boot tests), call `sl.reset()` in `tearDown`.

### Lifecycle and disposal (UNIVERSAL)

- Lazy singletons owning streams/sockets/controllers register `dispose:`.
- `BlocProvider` closes factories; never close a Cubit you did not create.
- Scoped lifetimes (per login session) use `sl.pushNewScope()` / `popScope()` or explicit reset on logout — not `registerSingleton` re-registration.

## Recommended implementation

- Add a debug assertion at the end of `setupLocator()` that resolves every registered type once (`sl.allReadySync()` + a smoke `sl<X>()` list) to catch ordering errors at startup instead of at first navigation.
- Provide test doubles via constructor, not via container overrides.

## Examples


Bad: `sl<AppStorage>()` inside a widget; a UI helper reading `sl<SessionProvider>()`; a repository opening a DB box by name in its body; a global `appContext` used for sizing.

## Anti-patterns

- Service locator as a global variable bag.
- Registering a Bloc as a singleton (state leaks across screens).
- `new`-ing a repository inside a Cubit.
- A class that resolves its own dependencies in its constructor body (`_repo = sl()`) — still hidden.

## Exceptions

Background isolates (`firebaseMessagingBackgroundHandler`, background location) cannot share the main container; they may construct a minimal graph locally. Document which classes are isolate-safe.
