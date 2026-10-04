> **EXAMPLE ADR** (reference profile). Greenfield: write your own from TEMPLATE.md; do not copy these decisions unless this is that stack.

# ADR-0003: flutter_bloc with BaseCubit + Status state model

- **Status:** Accepted
- **Date:** 2026-09-08 (reconstructed)
- **Decision owner:** Not determinable from repository evidence
- **Classification:** PROJECT-SPECIFIC (BaseCubit), RECOMMENDED universally (single Status enum + immutable state)

## Context

Presentation logic is implemented with `flutter_bloc` (14 Blocs, ~68 Cubits). Three state styles coexist. A shared `BaseCubit` exists but is used by only 9 cubits.

## Problem

Which state-management shape is the standard for new code?

## Decision

- **Cubit is the default.** A Bloc is used only when a feature has multiple distinct user intents that benefit from an explicit event log (auth, create-orbit, chat actions).
- Data-loading cubits extend `BaseCubit<S>` (`base/base_cubit.dart`) and implement `onInternetRestored` and `stateWithFailure`.
- State is a `@freezed` class with `Status status`, `String error`, `int errorCode`, and data fields. `Status` is the enum in `base/base_status.dart`.
- Flag-style states (`isLoading/isSuccess/hasError`) are LEGACY and must not be added.
- Side effects (navigation, toasts, loaders) happen in `BlocListener`, never in the Bloc/Cubit.
- `bloc_concurrency` is **not** adopted (ND-3). Double-submit is prevented by early-return on `Status.loading` plus UI disabling, and `if (isClosed) return;` follows every `await`.

## Evidence

- `orbit_list_cubit.dart`, `home_cubit.dart`, `feeds_cubit.dart` — Status + freezed + BaseCubit.
- `auth_state.dart`, `create_orbit_state.dart` — legacy flag states.
- 0 hits for `Navigator`/`EasyLoading`/`Fluttertoast` in `bloc/` and `cubit/`.
- Reason for original Bloc-vs-Cubit split: **Not determinable from repository evidence.**

## Alternatives considered

| Alternative | Why not |
|-------------|---------|
| Sealed state hierarchies (`Loading/Loaded/Error`) everywhere | Loses data during loading/paginating; the `Status` model keeps data + status together, which the list screens rely on. Allowed for small finite flows. |
| Riverpod | Would run two paradigms in parallel. |
| Adopt `bloc_concurrency` now | Cheap, but requires converting cubits to blocs to use transformers; deferred (ND-3). |

## Consequences

- Positive: uniform loading/error/no-internet handling; stale-refresh logic shared; realtime subscription cleanup centralised via `EventSubscriberMixin`.
- Negative: legacy flag states remain until migrated (R18); BaseCubit adoption is incomplete (ND-1).
- Rules: `sop/state-management.md`, `sop/bloc.md`, `guardrails/state-management.md`, `rules/bloc.rules`, `project/project-rules.md` §C.

## Migration

Incremental: convert one legacy Bloc state per PR with tests (R18).

## Review trigger

If more than ~5 Blocs need transformer semantics (restartable search, droppable submit), adopt `bloc_concurrency` via a superseding ADR.
