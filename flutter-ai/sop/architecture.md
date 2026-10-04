# SOP: Architecture

## Purpose

Give every developer and AI agent one answer to "which architecture should I use, and where does this code belong?" without forcing enterprise structure on small apps or letting large apps grow without structure.

## Scope

Whole-application architecture: levels, layers, dependency direction, and the procedure for auditing an existing project before touching it.

## Principles

1. **Start simple; add structure when complexity justifies it.** Architecture is a cost paid to manage change. Pay it when change is expensive, not before.
2. **Dependencies point inward.** UI → application logic → data access → platform/infrastructure. Never the reverse.
3. **One way to do each thing inside a feature.** Two patterns for the same job in one feature is a defect. App-wide mixed trees are allowed only as a recorded brownfield strangler (one orientation per feature).
4. **The project is the source of truth.** Inspect before you design. A generic best practice never overrides a documented project decision (ADR).
5. **Abstraction must earn its place.** An interface with one implementation and no test double is noise.

## Standard

### Architecture levels (UNIVERSAL, HIGH)

| Level | Name | Use when | Required structure | Optional | Upgrade when | Over-engineering risk |
|-------|------|----------|--------------------|----------|--------------|-----------------------|
| **L1** | Simple app | ≤ 5 screens, 1 developer, no backend or one trivial API, prototype | `lib/main.dart`, `lib/screens/`, `lib/widgets/`, `lib/services/` (plain classes), `setState` or `Cubit` | `models/` | A second developer joins, or a screen needs data from 2+ sources | Adding repositories/DI/routing packages to a 3-screen app |
| **L2** | Feature-based app | 5–30 screens, 1–4 developers, a REST backend | `lib/features/<feature>/{views,widgets,controller,models,services}`, `lib/core/{network,theme,routing,di}`, `lib/shared/`, typed routing, one HTTP gateway, constructor injection (container optional) | `domain/` inside a feature when logic is non-trivial | Cross-feature realtime, offline cache, or team > 4 | Use cases and DTO/entity splits in every feature |
| **L3** | Layered / modular app | 30+ screens, realtime, offline cache, 4–10 developers | Everything in L2 plus: abstract repositories, DI container with composition root, `Failure`/`Either` boundary, event bus or equivalent for cross-feature updates, base state model, error/log infrastructure | Use cases for complex orchestration; data sources when 2+ sources; feature-first **or** layer-first orientation (ADR) | Build times, ownership, or release cadence differ per feature area | Mandating use cases and data sources for every feature |
| **L4** | Large / enterprise | Multiple teams, shared code across apps, independent release of modules | L3 plus Dart packages per feature/shared module (`packages/`), melos or workspace, API contracts between packages, CI per package | Design-system package, platform-channel packages | — | Splitting into packages before ownership boundaries exist |

The reference project snapshot is **L3, layer-first** (example ADR-0001 in `adr/`; see `profiles/reference/`). That example is **not** the greenfield default.

**Greenfield (UNIVERSAL, HIGH):** if `lib/` is empty or `project/README.md` Orientation is `_TBD_`, the agent MUST stop and ask Feature First vs Layer First before creating any `lib/` files (`checklists/greenfield-kickoff.md`). Feature First is RECOMMENDED for new L2+. After the answer: write this project's ADR-0001, fill PR-A1/PR-A2, scaffold only that tree.

**Brownfield (UNIVERSAL, HIGH):** do not bulk-migrate an existing tree. Detect the layout, then ask **Stay** vs **Strangler** once (`sop/project-structure.md`). Do not run the greenfield orientation ask on an app that already has a tree.

### Layer responsibilities (UNIVERSAL, HIGH)

| Layer | Contains | Must not contain |
|-------|----------|------------------|
| **presentation** | Screens, widgets, state holders (Cubit/Bloc/Notifier/Controller), UI helpers. Feature First folders: `views/`, `widgets/`, `controller/`. | HTTP calls, storage access, service-locator lookups outside composition roots |
| **domain / application** | Repository interfaces, use cases (optional), policies, domain services, failure types | Flutter imports (`BuildContext`, widgets, `Navigator`, overlays) |
| **data** | Repository impls, data sources, models/DTOs, mappers, local DB. Feature First folders: `services/`, `models/`. | UI, navigation, presentation models |
| **core / infrastructure** | HTTP gateway, DI modules, routing config, theme, storage adapters, logging, platform services | Feature logic |

Dependency direction: `presentation → domain → data → core`. `core` never imports a feature.

### Data flow (UNIVERSAL, HIGH)

```text
User interaction
  → Widget (dispatch intent)
  → Bloc/Cubit (decide, emit loading)
  → Repository interface
  → Repository impl (compose sources, map, translate errors)
  → Data source / HTTP gateway / local DB
  → Either<Failure, Model>
  → Bloc/Cubit (fold → emit success | failure)
  → Widget (render state; side effects in listener)
```

Where each responsibility lives:

| Responsibility | Lives in |
|----------------|----------|
| Business rules, orchestration | Bloc/Cubit (or use case when spanning repositories) |
| API call | Repository impl / remote data source |
| JSON ↔ model | Model `fromJson/toJson`, invoked by repository |
| Error translation | Network gateway + error mapper → `Failure` |
| State | Immutable state class owned by Bloc/Cubit |
| Dependency wiring | Composition root (DI modules, `BlocProvider.create`, route wrapper) |
| Navigation, toasts, loaders | Widget listeners (`BlocListener`), never in Bloc/Cubit or data |

### Auditing an existing project before changing it (UNIVERSAL)

1. Read `pubspec.yaml` — identify state, routing, DI, HTTP, storage, serialization packages.
2. Read the composition root (`main.dart`, DI setup).
3. Read three complete vertical slices (screen → state → repository → gateway).
4. Read three shared widgets and the theme.
5. Count patterns with `rg` (e.g. `sl<`, `Navigator.push`, `Colors\.`) to find drift.
6. Record findings with the classification vocabulary and evidence (`project/audit-report.md`).
7. Only then design or implement.

## Recommended implementation

- Choose the **lowest level that fits today** and write the level in `project/README.md`.
- At L2+, keep a single HTTP gateway abstraction and a single `Failure` type from day one; they are cheap and prevent the most expensive later refactors.
- Write one ADR per architectural package choice when starting a project (orientation, state, routing, DI, HTTP, storage).
- Feature First is RECOMMENDED for new L2/L3 projects; Layer First is acceptable when documented (ADR). Existing apps MUST NOT bulk-migrate; use Stay or Strangler.

## Examples

Reference vertical-slice examples (optional): `profiles/reference/architecture-map.md`. For the active app, document one real slice in `project/architecture-map.md`.

## Anti-patterns

| Anti-pattern | Why it hurts | Observed in reference project |
|--------------|--------------|-------------------------------|
| Widget resolves services from the container | Hidden dependencies, untestable widgets | ~170 `sl<` hits in `presentation/ui` |
| Domain code imports Flutter UI | Domain becomes untestable without a widget tree | `domain/helper/*picker_helper.dart` |
| Domain imports presentation models | Reverses dependency direction | `general_repository.dart:1` |
| Mega barrel re-exporting every layer | Analyzer cannot detect layer violations | `utils/exports.dart` |
| Two implementations of the same concern | Drift, duplicated bugs | two theme stacks, two connectivity packages, three serializers |
| Enterprise structure for trivial features | Boilerplate without benefit | (avoided: use cases only in chat) |
| Whole-tree folder migration | Merge conflicts, broken imports, no tests to protect the move | (do not: rewrite `lib/layers` into `lib/features`) |
| One feature split across two trees | Two homes, missed files, ARCH-7 fail | screen in `lib/features/foo` + cubit in `lib/layers/.../foo` |

## Exceptions

Use `checklists/exception-request.md`. Typical accepted exceptions: a platform plugin that requires a `BuildContext` inside a service (wrap at the presentation edge); a performance hot path that bypasses a layer (must be documented inline and in an ADR).
