# SOP: BLoC / Cubit (flutter_bloc)

## Purpose

Mechanics for writing, wiring, and testing `flutter_bloc` Blocs and Cubits consistently. Read `state-management.md` first for the "which and why".

## Scope

Class layout, events, states, emit safety, concurrency, dependencies, providing to the tree, listening, testing.

## Principles

1. A Bloc/Cubit is a pure Dart class: no Flutter UI imports.
2. Every async gap is a chance for the Bloc to have been closed.
3. Dependencies come in through the constructor.
4. Events describe what happened; methods (Cubit) describe what to do.

## Standard

### File layout (UNIVERSAL, HIGH)

```text
foo_cubit/            (feature folder, snake_case)
  foo_cubit.dart
  foo_state.dart      (+ foo_state.freezed.dart)
foo_bloc/
  foo_bloc.dart
  foo_event.dart
  foo_state.dart
```

`part`/`part of` for event/state files is OPTIONAL; pick one style per project. The reference project mixes both (NEEDS-DECISION → default: separate files with imports, freezed state).

### Events (UNIVERSAL, HIGH)

```dart
sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => const [];
}

final class LoginRequested extends AuthEvent {
  const LoginRequested({required this.phoneNo, required this.countryCode});
  final String phoneNo;
  final String countryCode;
  @override
  List<Object?> get props => [phoneNo, countryCode];
}
```

- `sealed` base (not `abstract`), `Equatable`, `const` constructors.
- Every declared event has a registered `on<E>` handler (dead `CompleteProfileEvent` in reference is LEGACY).
- A Bloc's public API is `add(event)`. Public non-event methods that mutate state are ANTI-PATTERN.

### Cubit methods (UNIVERSAL)

- Verb-named, return `Future<void>` for async.
- Guard re-entry: `if (state.status == Status.loading) return;`.

### Emit safety (UNIVERSAL, HIGH)

```dart
final result = await _repository.fetch();
if (isClosed) return;          // mandatory after every await
result.fold(handleFailure, (data) => emit(...));
```

Also `if (isClosed) return;` at the top of every stream/bus handler.

### Concurrency (RECOMMENDED)

| Need | Bloc (with `bloc_concurrency`) | Cubit |
|------|--------------------------------|-------|
| Ignore duplicate submits | `transformer: droppable()` | early-return on `Status.loading` + UI disables button |
| Latest search wins | `transformer: restartable()` | debounce + ignore stale result (compare request id) |
| Process in order | `transformer: sequential()` | await chain / queue |
| Default | `concurrent()` (bloc default) | — |

The reference project does not use `bloc_concurrency` (ND-3). Until decided, Cubits use the right-hand column; new Blocs that need per-intent policy should propose adding `bloc_concurrency` (dev cost: one dependency, no code changes elsewhere).

### Debounce / throttle (UNIVERSAL)

One mechanism per project (`easy_debounce` in the reference). Always cancel in `close()`:

```dart
@override
Future<void> close() async {
  EasyDebounce.cancel(_debounceKey);
  await disposeSubscriptions();
  return super.close();
}
```

### Dependencies (UNIVERSAL, HIGH)

- Constructor-injected abstractions (`FooRepository`, `NetworkMonitor`, `GlobalEventBus`, `AuthStateProvider`).
- No `sl<>()`/`GetIt.I` inside the class body (observed violations: `location_cubit.dart:262`).
- No `BuildContext`, `Navigator`, `EasyLoading`, toast, or widget imports.

### Providing (UNIVERSAL)

```dart
// screen-scoped (preferred)
class FooScreen extends StatelessWidget implements AutoRouteWrapper {
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider(create: (_) => sl<FooCubit>()..load(), child: this);
}
// root: only session-wide state
```

- Register Cubits/Blocs as **factories** in DI; `BlocProvider` owns the lifecycle and calls `close()`.
- `BlocProvider.value` only for passing an existing instance down (dialogs, sheets, new routes).
- Pure UI cubits without dependencies may be constructed directly (`BlocProvider(create: (_) => ToggleCubit())`).

### Consuming (UNIVERSAL)

| Need | Use |
|------|-----|
| Render part of state | `BlocSelector` or `BlocBuilder` with `buildWhen` |
| React once (navigate, toast, loader) | `BlocListener` with `listenWhen` |
| Both | `BlocConsumer` |
| Trigger an action | `context.read<FooCubit>().doX()` |
| Avoid | `context.watch` in large `build` methods; reading a Bloc inside another Bloc |

### Cross-Bloc communication (UNIVERSAL)

Through a typed bus or repository stream, subscribed in the constructor, disposed in `close()`. Never `context.read<OtherBloc>()` inside a Bloc, never inject one Bloc into another.

### Testing (UNIVERSAL, HIGH)

```dart
blocTest<FooCubit, FooState>(
  'emits [loading, success] when fetch succeeds',
  build: () {
    when(() => repo.fetchFoos(req: any(named: 'req')))
        .thenAnswer((_) async => right(fixtureFooList));
    return FooCubit(repository: repo, networkMonitor: monitor);
  },
  act: (c) => c.fetch(),
  expect: () => [
    const FooState(status: Status.loading),
    isA<FooState>().having((s) => s.status, 'status', Status.success),
  ],
);
```

Every new/changed Bloc/Cubit ships with: success path, failure path, no-internet path, pagination (`hasMore` false stops), and `isClosed` safety where relevant.

## Recommended implementation

Reference `BaseCubit` (`lib/layers/base/base_cubit.dart`): network-restore hook, staleness, `handleFailure → stateWithFailure`. Adopt it for every data-loading Cubit (ND-1 default: adopt).

## Examples

- Good Cubit: `orbit_list_cubit.dart`, `feeds_cubit.dart`.
- Good Bloc events: `auth_event.dart` (sealed + Equatable), names aside.
- Legacy: `auth_bloc.dart` (flag state, no `isClosed`), `user_profile_bloc.dart` (public imperative methods).

## Anti-patterns

- `emit` after `await` without `isClosed`.
- Bloc registered in the wrong DI module (`ChatPinnedBloc` in cubits module).
- State class named after a field (`LastMessageState`).
- 21 root providers; 30 providers in one screen wrapper.
- `Future.delayed` inside a Bloc to "wait for the UI".

## Exceptions

A Cubit may expose a `Stream` or `ValueNotifier` for high-frequency values (audio position, scroll offset) where `emit` per frame would be wasteful; document it in the class doc comment.
