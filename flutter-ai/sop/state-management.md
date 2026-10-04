# SOP: State Management

## Purpose

Decide, for any piece of state, where it lives and how it changes — so that loading, error, empty, pagination and refresh look the same in every feature.

## Scope

Choice of approach (setState, Cubit, Bloc, other), state shape, status model, pagination/refresh/retry contracts, cross-feature updates, provider scoping. flutter_bloc mechanics are in `bloc.md`.

## Principles

1. **State is immutable data; a transition is a function.** Never mutate state in place.
2. **Data and status live together.** A list screen must be able to show stale data while `paginating` or `syncing`.
3. **The UI dispatches intent and renders state; it never decides business outcomes.**
4. **Side effects belong at the edge** (listeners), not inside state holders.
5. **Choose the simplest tool that survives the next requirement**, and use one tool per project.

## Standard

### Choosing an approach (UNIVERSAL, HIGH)

| Situation | Use |
|-----------|-----|
| Ephemeral, single-widget UI state (expanded/collapsed, text field focus, animation) | `setState` / `ValueNotifier` |
| Screen or feature state with async work or shared across widgets | **The project's chosen paradigm** (ADR). Common defaults: Cubit, or Riverpod Notifier |
| Feature with several distinct user intents needing an explicit event log / per-intent concurrency | Bloc (if flutter_bloc is the ADR choice) or equivalent |
| App-wide session/config state | Root-scoped holder; keep the count small |
| Another paradigm | Only if the project ADR chose it as **the** approach. Mixing feature-level paradigms is an architectural defect |

When multiple approaches are justified: widget-local `setState` **alongside** one feature-level paradigm is normal. Two feature-level paradigms is not.

### State shape (UNIVERSAL, HIGH)

```dart
@freezed
abstract class FooState with _$FooState {
  const factory FooState({
    @Default(Status.initial) Status status,
    @Default('') String error,
    @Default(unExpectedErrorCode) int errorCode,
    // data fields, always present so stale data survives status changes
    @Default([]) List<FooEntity> items,
    @Default(true) bool hasMore,
  }) = _FooState;
  const FooState._();
  bool get isEmpty => status == Status.success && items.isEmpty;
}
```

- Immutable (`freezed` RECOMMENDED; `Equatable` + `copyWith` acceptable).
- **One `Status` enum project-wide** (`none, initial, loading, paginating, success, failure, noInternet, syncing` in the reference project). Do not create per-feature status enums.
- `error` is a user-displayable `String`; `errorCode` allows the UI to branch (401, no-internet).
- Sealed state hierarchies (`Loading | Loaded | Error`) are OPTIONAL for small finite flows without data-during-loading needs.
- Boolean flag soups (`isLoading` + `isSuccess` + `hasError` + sticky `error`) are ANTI-PATTERN (observed: `AuthState`, `CreateOrbitState`). They allow impossible combinations and lose data on reload.

### How each situation is represented (UNIVERSAL)

| Situation | Representation | UI |
|-----------|----------------|----|
| Initial (nothing fetched) | `Status.initial` | skeleton/loader |
| Loading first page | `Status.loading`, data may be empty | loader |
| Loading next page | `Status.paginating`, data retained | list + footer spinner |
| Background refresh | `Status.syncing`, data retained | list, optional subtle indicator |
| Success | `Status.success` | content, or **empty state** if `items.isEmpty` |
| Failure with no data | `Status.failure` + `error` | error view with retry |
| Failure with data | `Status.failure` handled as toast; data retained (`BaseCubit.handleFailure(isSyncing, hasData)`) | content + toast |
| Offline | `Status.noInternet` | offline view; auto-retry via `onInternetRestored` |

### Pagination contract (UNIVERSAL, HIGH)

```text
fields:   items, hasMore, (total optional), status
inputs:   fetch({bool loadMore = false})
rules:    - ignore loadMore when !hasMore or already loading/paginating
          - skip = loadMore ? items.length : 0 ; limit = const per cubit (project default 10)
          - hasMore = skip + received.length < total   (or received.length == limit when no total)
          - loadMore appends; fresh fetch replaces
refresh:  fetch() with Status.syncing when data exists, Status.loading when not
retry:    same entry point as the failed call
```

The reference project has four pagination variants (NEEDS-DECISION) — new code uses this contract.

### Cross-feature and realtime updates (RECOMMENDED, HIGH)

- Cubits never call other cubits. They communicate through a typed event bus (`GlobalEventBus` + `EventSubscriberMixin` in the reference project, ADR-0007) or repository streams.
- Handlers check `isClosed` before emitting and are disposed in `close()`.

### Provider scoping (UNIVERSAL)

- Provide at the **narrowest scope that works**: route wrapper (`AutoRouteWrapper.wrappedRoute`) for screen state; root only for session-wide state.
- Root providers should stay under ~10. The reference project has 21 (NEEDS-DECISION).
- Read with `context.read` for actions, `BlocBuilder`/`BlocSelector`/`buildWhen` for rendering. Avoid `context.watch` in large builds.

### Side effects (UNIVERSAL, HIGH)

Navigation, toasts, dialogs, blocking loaders, haptics: only in `BlocListener` / `listener:` callbacks. Never in a Cubit/Bloc, repository, or data source. The reference project complies (0 hits) — keep it that way.

## Recommended implementation

- Extend a project `BaseCubit` that centralises `handleFailure`, no-internet retry, staleness (`isStale`, `markFresh`). Reference: `lib/layers/base/base_cubit.dart`.
- Expose derived getters on state (`isReady`, `isEmpty`) instead of computing in widgets.
- Debounce user input inside the cubit (`easy_debounce` or a `Timer`), cancel in `close()`.

## Examples

Reference (good): `orbit_list_cubit.dart` — `Status`, `hasMore`, `paginating`/`syncing`, realtime patches, debounce cancelled in `close()`.

Reference (legacy): `auth_bloc.dart` + `auth_state.dart` — flag soup, no `isClosed` after `await`.

## Anti-patterns

- Business decisions in widgets (`if (distance > 2000) fetch()` in a `build`).
- Cubit holding a `BuildContext` or reading another bloc via context (`chat_details_user_ui.dart:83`).
- A Bloc with large public non-event methods used as a service façade (`UserProfileBloc`).
- God cubits > ~400 lines with unrelated responsibilities (`chat_contacts_base_cubit.dart` 758).
- Two loaders for one state (EasyLoading **and** inline spinner).

## Exceptions

Widget-local controllers (`ScrollController`, `TextEditingController`, `AnimationController`) are UI state and stay in `State<T>`; a UI "controller" class that only glues scroll/observer behaviour (`chat_message_list_controller.dart`) is acceptable in `ui/<feature>/controller/`.
