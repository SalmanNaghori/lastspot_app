# Guardrails: State Management

SOP: `sop/state-management.md`, `sop/bloc.md`.

**STATE-1** — A project MUST use one feature-level state-management paradigm (the one recorded in its ADR). A second paradigm MUST NOT be introduced. `setState`/`ValueNotifier` for widget-local ephemera is not a second paradigm.

**STATE-2** — Prefer the simplest holder that fits the ADR (e.g. Cubit before Bloc; a single Notifier before a deep provider graph). Heavier patterns MUST be justified in the PR or ADR.

**STATE-3** — State classes MUST be immutable (`freezed`, `Equatable` + `copyWith`, or sealed immutable types). Mutable fields or in-place list mutation MUST NOT be used.

**STATE-4** — Async state MUST use one shared status model (or sealed states) so data can survive refresh/pagination. Boolean flag sets (`isLoading` + `isSuccess` + `hasError`) MUST NOT be introduced. Per-feature copies of the status enum MUST NOT be created.

**STATE-5** — After every `await` in a state holder, and at the top of every stream/bus handler, the code MUST check closed/disposed/mounted (as appropriate for the paradigm) before emitting/updating state.

**STATE-6** — State holders MUST NOT import Flutter UI, hold a `BuildContext`, navigate, show toasts/dialogs/loaders, or read other feature holders via `context`.

**STATE-7** — State holders MUST NOT resolve infrastructure from the DI container in their bodies (composition roots only).

**STATE-8** — Feature state holders MUST NOT call other feature holders directly. Cross-feature updates MUST go through the mechanism in the ADR (typed event bus, repository streams, or equivalent).

**STATE-9** — Every stream/bus subscription and debounce key created by a state holder MUST be cancelled in `close()`/`dispose()`/`ref.onDispose`.

**STATE-10** — If using Bloc: public mutation API MUST be `add(event)`. Public methods that `emit` directly on a Bloc MUST NOT be added. Every declared event MUST have a registered handler. (N/A for other paradigms.)

**STATE-11** — If using Bloc: events MUST be a `sealed` class hierarchy extending `Equatable`, with `const` constructors. (N/A for other paradigms.)

**STATE-12** — Side effects (navigation, toast, dialog, loader, haptics) MUST happen only in listeners / UI-edge callbacks or route/notification handlers.

**STATE-13** — Pagination MUST follow the project contract (`skip/limit/hasMore` + paginating status); duplicate in-flight loads MUST be guarded.

**STATE-14** — State holders SHOULD stay under ~400 lines; beyond that they MUST be split or a written justification MUST accompany the PR.
Check: `wc -l lib/layers/presentation/{cubit,bloc}/**/*.dart | sort -n | tail`.

**STATE-15** — Widgets SHOULD read state with `BlocBuilder`+`buildWhen` or `BlocSelector`; `context.watch` in large `build` methods SHOULD NOT be used.

**STATE-16** — `Future.delayed` MUST NOT be used inside a Bloc/Cubit to wait for another component's readiness.
Check: `rg -n "Future.delayed" lib/layers/presentation/{cubit,bloc}`.

## Reference project status

Legacy flag states (`AuthState`, `CreateOrbitState`), `isClosed` gaps (`AuthBloc`, `LocationCubit`), dead `CompleteProfileEvent`, `UserProfileBloc` public methods — tracked in `profiles/reference/remediation-backlog.md` R9, R18, R26.
