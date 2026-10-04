> **EXAMPLE ADR** (reference profile). Greenfield: write your own from TEMPLATE.md; do not copy these decisions unless this is that stack.

# ADR-0002: get_it service locator with ordered registration modules

- **Status:** Accepted
- **Date:** 2026-09-08 (reconstructed)
- **Decision owner:** Not determinable from repository evidence
- **Classification:** PROJECT-SPECIFIC (container choice), UNIVERSAL (constructor injection + composition root)

## Context

The app needs one place to compose Dio, storage, Hive, Firebase, repositories, and ~82 blocs/cubits, with a strict initialisation order.

## Problem

How are dependencies composed and resolved?

## Decision

- `get_it` is the single container, exposed as `GetIt sl = GetIt.instance` (`core/di/service_locator.dart`).
- Registration is split into modules invoked in a documented order: Config → EventBus → LifeCycle → MainConfig → External → Hive → AppLevel → DataSources → Repositories → DomainServices → Blocs → Cubits → Boot.
- Repositories/services: `registerLazySingleton<Abstract>(() => Impl(dep: sl()))`. Blocs/Cubits: `registerFactory`.
- All classes receive dependencies through constructors. `sl<>()` is resolved **only** at composition roots (DI modules, `BlocProvider.create`, `wrappedRoute`, boot).

## Evidence

- `service_locator.dart:33-78`; `repository_injection.dart`; `cubits_injection.dart`.
- 0 `sl<` hits inside `data/repositoryImpl/` confirms constructor injection in the data layer.
- Violations exist (~170 `sl<` in widgets, some in cubit methods) and are tracked as R14; they do not change the decision.

## Alternatives considered

| Alternative | Why not |
|-------------|---------|
| `injectable` codegen | Adds a build step; the ordered manual modules already document dependencies explicitly. Acceptable future option. |
| Provider/Riverpod as DI | Would introduce a second state/DI paradigm beside flutter_bloc. |
| Constructor-only manual wiring | ~120 registrations; a container is justified at this size. |

## Consequences

- Positive: explicit, greppable dependency graph; trivial to swap impls for tests.
- Negative: global mutable container; misuse (`sl<>` in widgets) is easy and must be guarded.
- Rules: `sop/dependency-injection.md`, `guardrails/architecture.md` §DI, `rules/dependency.rules`, `project/project-rules.md` §B.

## Migration

None. Existing `sl<>` leaks are fixed incrementally (R14).

## Review trigger

If registrations exceed ~200 or ordering bugs recur, evaluate `injectable`.
