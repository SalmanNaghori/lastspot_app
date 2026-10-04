# Guardrails: Architecture, Structure, Dependency Injection

SOP: `sop/architecture.md`, `sop/project-structure.md`, `sop/dependency-injection.md`, `sop/feature-architecture.md`.

## Layer boundaries

**ARCH-1** — Dependencies MUST point inward: `presentation → domain → data → core`. A lower layer MUST NOT import a higher layer.
Feature First folders: presentation = `views/` + `widgets/` + `controller/`; data = `services/` + `models/`.
Check (use the tree this project recorded):
- Layer First: `rg "import 'package:<app>/(layers/)?presentation" lib/layers/{domain,data,core}` → must be empty.
- Feature First: `rg "import 'package:<app>/features/.*/(views|widgets|controller)" lib/features --glob '**/services/**' --glob '**/models/**'` and the same pattern under `lib/core` (except DI/routing) → must be empty.

**ARCH-2** — `domain/` and `data/` MUST NOT import Flutter UI (`package:flutter/material.dart`, `widgets.dart`, `cupertino.dart`), `BuildContext`, `Navigator`, overlays, toasts or loaders. Feature First: `services/` and `models/` are data.
Check:
- Layer First: `rg -l "BuildContext|Navigator\.|EasyLoading|Fluttertoast|showDialog|showModalBottomSheet" lib/layers/{domain,data}` → must be empty.
- Feature First: same pattern on `lib/features/**/services` `lib/features/**/models`.

**ARCH-3** — `core/` MUST NOT import feature UI/state code, except the DI and routing modules whose job is composition.
Check:
- Layer First: `rg -l "presentation/(ui|cubit|bloc)" lib/layers/core --glob '!**/di/**' --glob '!**/navigation/**' --glob '!**/notification/**'`.
- Feature First: `rg -l "package:<app>/features/" lib/core --glob '!**/di/**' --glob '!**/routing/**' --glob '!**/navigation/**'`.

**ARCH-4** — Widgets MUST NOT call the HTTP client, the API gateway, a repository, or a data source directly.
Check:
- Layer First: `rg -l "Repository|DataSource|BaseApiService|Dio\(" lib/layers/presentation/ui lib/layers/presentation/commonWidgets lib/layers/presentation/auth`
- Feature First: same pattern on `lib/features/**/views` `lib/features/**/widgets` (type names in controller imports excepted).

**ARCH-5** — Business rules (filtering, distance/threshold checks, validation logic, decryption, eligibility) MUST live in a state holder, use case or policy, not in a widget `build`, `initState` or UI helper.
Check: review; heuristics `rg "decryptString|distanceBetween|\.where\("` on `lib/layers/presentation/ui` **or** `lib/features/**/views` `lib/features/**/widgets`.

**ARCH-6** — A new abstraction (interface, base class, use case, data source, mapper) MUST be justified by at least one of: a second implementation, a test double need, or orchestration across 2+ sources. Otherwise it MUST NOT be created.

**ARCH-7** — The architecture level and orientation MUST be recorded in `project/README.md` and an ADR. New code MUST follow it.
- A **feature** MUST live in one tree (`lib/features/<name>/` **or** the legacy layer-first folders — not both).
- App-wide mixed trees (Strangler) are allowed **only** with a brownfield ADR that names the legacy root and the new-feature root.
- Stay projects MUST NOT add `lib/features/` if that root is not already the app tree.
- Greenfield MUST NOT scaffold `lib/` until orientation is answered (`checklists/greenfield-kickoff.md`).
- Bulk-moving a legacy tree is MUST NOT.
Check: new paths for feature `foo` appear under only one of `lib/features/foo/` and `lib/layers/**/foo*`. Stay: `git diff --name-only | rg '^lib/features/'` is empty unless Feature First is already the tree.

## Structure

**STRUCT-1** — New directories MUST be `snake_case`. Existing camelCase directories MAY remain until a hygiene PR.
Check: `find lib -type d -newer <base-commit> | rg "[A-Z]"` for new dirs.

**STRUCT-2** — Third-party or vendored packages MUST NOT live under `lib/`; they MUST be in `packages/` with a `path:` dependency.
Check: `find lib -name pubspec.yaml`.

**STRUCT-3** — Source directories MUST NOT be listed under `flutter.assets` in `pubspec.yaml`.
Check: `rg "^\s*- lib/" pubspec.yaml`.

**STRUCT-4** — A barrel file MUST NOT re-export third-party packages or more than one layer. New code in `data/`, `domain/`, `core/` SHOULD NOT import a mega-barrel.
Check: `rg "^export 'package:(flutter|flutter_bloc|hive|dio|get_it)" lib`.

**STRUCT-5** — Generated files (`*.g.dart`, `*.freezed.dart`, `*.gr.dart`) MUST be either all committed or all ignored; they MUST NOT be hand-edited.

**STRUCT-6** — Scratch or dead files MUST NOT be merged (empty files, fully commented-out files, unrouted legacy screens).
Check: `find . -maxdepth 1 -type f -size 0`; files whose non-comment line count is 0.

## Dependency injection

**DI-1** — Every class MUST receive its collaborators through its constructor (or the project's declared injection graph). A class MUST NOT resolve its own infrastructure dependencies from the container in its body.

**DI-2** — Container / override resolution MUST occur only at composition roots: DI modules, route/provider wrappers, app bootstrap, background-isolate entry points — as listed in `project/architecture-map.md`.

**DI-3** — Repositories, services, gateways MUST be registered as long-lived singletons (or equivalent) against their **abstraction**; UI state holders MUST be per-route / factory scoped (or constructed when dependency-free).

**DI-4** — Registrations MUST be placed in the module matching their kind and MUST respect the documented initialisation order.

**DI-5** — Global mutable state as a dependency channel (global `BuildContext`, static mutable fields, opening DB boxes by magic name inside a class body) MUST NOT be introduced.

**DI-6** — UI state holders MUST NOT be registered as app-wide singletons and MUST NOT be injected into other feature state holders.

**DI-7** — Root-level (`main.dart`) providers SHOULD be limited to session-wide state; screen state SHOULD be scoped via the route wrapper.

## Exceptions

Only via `checklists/exception-request.md` + ADR. Known accepted deviations for the **reference** snapshot: layer-first orientation (example ADR-0001); use cases limited to chat (ADR-0005). Those examples are not greenfield defaults. Brownfield Strangler (mixed trees, one orientation per feature) is the allowed mixed form — not an exception to ARCH-7.
