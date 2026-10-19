# SOP: Project Structure

## Purpose

Make "where does this file go?" answerable in under ten seconds, for humans and agents.

## Scope

Directory layout for each architecture level, feature-first vs layer-first, brownfield Stay vs Strangler, barrel files, generated code, assets, tests, vendored packages.

## Principles

1. Placement is predictable from the file's role.
2. Directory names are `snake_case` everywhere (Dart convention).
3. Generated code sits beside its source and is committed consistently (all or none).
4. Third-party code is never inside `lib/`.
5. **One orientation per feature.** A feature lives entirely in one tree. App-wide mixed trees are allowed only as a recorded brownfield strangler — never as a bulk rewrite.

## Standard

### Choosing a tree (UNIVERSAL, HIGH)

| Situation | What to do |
|-----------|------------|
| Greenfield / empty `lib/` / Orientation `_TBD_` | Stop. Ask Feature First vs Layer First (`checklists/greenfield-kickoff.md`). Do not scaffold `lib/` until answered. |
| Existing app, orientation already recorded | Follow `project/project-rules.md` PR-A1 / PR-A2. Do not re-ask. |
| Existing app, no orientation recorded | Detect the current tree. Ask **Stay** vs **Strangler** once (below). Do not run the greenfield ask. |

Feature First is RECOMMENDED for new L2+ apps. Layer First is a valid L3 variant when chosen in an ADR.

### L1 (UNIVERSAL)

```text
lib/
  main.dart
  app.dart
  screens/
  widgets/
  models/
  services/
```

#### L2+ Feature First (RECOMMENDED for new projects)

Each feature carries its own `data / domain / presentation` layers. Layer rules (ARCH-1) apply inside the feature exactly as they do in Layer First; only the nesting differs.

```text
lib/
  main.dart
  app/                            app widget, bootstrap, DI composition root
  core/
    network/  routing/  theme/  storage/  di/  errors/  utils/
  shared/
    widgets/                      design-system and 2+ feature widgets
    models/                       models used by 2+ features
  features/
    <feature>/
      data/
        models/                   request/response models for this feature
        data_sources/             remote/local data sources, API services
        repositories/             <x>_repository_impl.dart
      domain/
        repositories/             <x>_repository.dart (abstract contract, imports models only)
        usecases/                 OPTIONAL — only when FEAT-3 says so
        entities/                 OPTIONAL — only when FEAT-3 says so
        policies/                 OPTIONAL — only when FEAT-3 says so
      presentation/
        screens/                    routed screens only
        widgets/                  feature-only widgets
        controller/               state holders (Notifier / Cubit / Bloc; file name follows the state ADR)
test/
  features/<feature>/
    data/ domain/ presentation/   mirrors lib/
  core/...
```

Layer mapping (ARCH-1 still applies):

| Layer | Feature First folders |
|-------|------------------------|
| presentation | `features/<x>/presentation/` (`screens/`, `widgets/`, `controller/`) |
| domain | `features/<x>/domain/` (`repositories/` always; `usecases/`, `entities/`, `policies/` when added) |
| data | `features/<x>/data/` (`models/`, `data_sources/`, `repositories/`) |
| core | `lib/core/`, never imports a feature |

Dependency direction: `presentation → domain ← data`. Screens and widgets never call HTTP or data sources. Controllers talk to domain contracts (repository interfaces or use cases), never to `data/` directly. `controller/` is the folder name regardless of Riverpod vs Bloc.

Placement for a new feature `foo` (Feature First):

| Artifact | Path |
|----------|------|
| Screen | `lib/features/foo/presentation/screens/foo_screen.dart` |
| Screen widgets | `lib/features/foo/presentation/widgets/` |
| Controller / notifier / cubit | `lib/features/foo/presentation/controller/foo_controller.dart` (or `foo_notifier.dart` / `foo_cubit.dart` per state ADR) |
| Request / response models | `lib/features/foo/data/models/` |
| Data sources / API services | `lib/features/foo/data/data_sources/foo_remote_data_source.dart` |
| Repository impl | `lib/features/foo/data/repositories/foo_repository_impl.dart` |
| Repository interface | `lib/features/foo/domain/repositories/foo_repository.dart` (imports models only) |
| Use cases / entities / policies | `lib/features/foo/domain/{usecases,entities,policies}/` (only when FEAT-3 says so) |
| Shared widget | `lib/shared/widgets/` |
| Route | project's router (usually `lib/core/routing/` or `lib/core/navigation/`) |
| Tests | `test/features/foo/{data,domain,presentation}/...` mirroring `lib/` |

`domain/repositories/` is always present. Do **not** add `usecases/`, `entities/` or `policies/` by default.

Junior-friendly type folders **inside** each feature. Layer rules still apply; only the folders change.

```text
lib/
  main.dart
  app/                          app widget, bootstrap, DI composition root
  core/
    network/  routing/  theme/  storage/  di/  errors/  utils/
  shared/
    widgets/                    design-system and 2+ feature widgets
    models/                     models used by 2+ features
  features/
    <feature>/
      screens/                    routed screens only
      widgets/                  feature-only widgets
      controller/               state holders (Notifier / Cubit / Bloc — file name follows the state ADR)
      models/                   request/response models for this feature
      services/                 <x>_repository.dart (interface — domain contract, imports models only),
                                <x>_repository_impl.dart, data sources, API services
      domain/                   OPTIONAL — use cases / policies only when FEAT-3 says so
test/
  features/<feature>/...
  core/...
```

Layer mapping (ARCH-1 still applies):

| Layer | Feature First folders |
|-------|------------------------|
| presentation | `screens/` + `widgets/` + `controller/` |
| domain | repository interface `services/<x>_repository.dart` + `domain/` (use cases, entities, policies) when added |
| data | the rest of `services/` (repository impls, data sources) + `models/` |
| core | `lib/core/` — never imports a feature |

Views and widgets never call HTTP or services. Controllers talk to services. `controller/` is the folder name regardless of Riverpod vs Bloc.

Placement for a new feature `foo` (Feature First):

| Artifact | Path |
|----------|------|
| Screen | `lib/features/foo/screens/foo_screen.dart` |
| Screen widgets | `lib/features/foo/widgets/` |
| Controller / notifier / cubit | `lib/features/foo/controller/foo_controller.dart` (or `foo_notifier.dart` / `foo_cubit.dart` per state ADR) |
| Models | `lib/features/foo/models/` |
| Repository interface | `lib/features/foo/services/foo_repository.dart` (imports `models/` only) |
| Repository impl / data sources | `lib/features/foo/services/foo_repository_impl.dart`, `foo_remote_data_source.dart` |
| Shared widget | `lib/shared/widgets/` |
| Route | project's router (usually `lib/core/routing/` or `lib/core/navigation/`) |
| Tests | `test/features/foo/...` mirroring `lib/` |

Do **not** add `domain/` by default.

### L3 Layer First (PROJECT-SPECIFIC when chosen)

The optional reference snapshot (`profiles/reference/`) uses this tree. Projects record their own layout in ADR-0001; use this only if Layer First was chosen.

```text
lib/
  main.dart
  layers/
    app/            bootstrap, barrels
    base/           BaseCubit, Status, base views
    core/           config, di, network, navigation, realtime, notification, storage, auth, theme, services, widgets
    data/           models/, remote/, localDB/, localModels/, repositoryImpl/, globalUpdatesHandler/
    domain/         repositories/ (abstract), usecases/, services/, policies/, realtime/
    presentation/   bloc/, cubit/, ui/<feature>/{widgets,model}, commonWidgets/, shared/
    utils/
```

Placement for a new feature `foo` in a Layer First app:

| Artifact | Path |
|----------|------|
| Repository interface | `lib/layers/domain/repositories/foo_repository.dart` |
| Repository impl | `lib/layers/data/repositoryImpl/foo_repository_impl.dart` |
| Response model | `lib/layers/data/models/responseModels/foo_entity.dart` |
| Request model | `lib/layers/data/models/requestModels/foo_req_model.dart` |
| Cubit | `lib/layers/presentation/cubit/foo_cubit/foo_cubit.dart` + `foo_state.dart` (new dirs snake_case) |
| Screen | `lib/layers/presentation/ui/foo/foo_screen.dart` |
| Screen widgets | `lib/layers/presentation/ui/foo/widgets/` |
| DI | add to the matching `core/di/*Injection` module |
| Route | `core/navigation/app_router.dart` |
| Tests | `test/presentation/cubit/foo_cubit_test.dart`, `test/data/foo_repository_impl_test.dart` |

### Existing apps — Stay vs Strangler (UNIVERSAL, HIGH)

A full move (`lib/layers/` → `lib/features/`) is **not** the upgrade path. It burns review/merge time, breaks imports, and fights every open branch.

| Choice | When | Placement |
|--------|------|-----------|
| **Stay** | Team does not want two trees. Default for a large existing app that is not being rewritten. | Keep the current layout forever. New files go next to siblings. Feature First is not introduced. |
| **Strangler** | Team wants Feature First going forward without a rewrite. | Brand-new features go under `lib/features/<name>/...`. Existing features keep receiving files in the legacy tree. |

Strangler rules:

1. Record in an ADR + `project/project-rules.md`: `Orientation: mixed` — name the **legacy root** (e.g. `lib/layers/`) and the **new-feature root** (`lib/features/`). Keep a short feature→tree map, or "all legacy until listed".
2. **One orientation per feature.** Never put a screen in `lib/features/foo` while its state holder stays in `lib/layers/presentation/cubit/foo`.
3. Before creating a file, search which tree that **feature** already occupies; put the file there. Use `lib/features/` only when the feature does not exist yet.
4. Relocate a feature only when it is already being rewritten (dedicated PR, tests in the same change, one feature at a time). No drive-by `git mv`.
5. Shared/core stays where it already lives. Do not duplicate theme, network, or DI.

Do **not**: bulk-migrate; split one feature across both trees; ask greenfield orientation questions on an app that already has a layout.

### L4 (UNIVERSAL)

```text
packages/
  core_network/  core_ui/  feature_chat/  feature_products/ ...
apps/
  mobile/
melos.yaml | pubspec workspace
```

### Cross-cutting rules

- **Directories `snake_case`** (UNIVERSAL, HIGH). Legacy apps often mix `chatDetailsScreen` and `profile_setting`; new directories must be snake_case, existing ones are LEGACY and renamed only in dedicated hygiene PRs.
- **One widgets folder name**: `widgets/` (not `widget/`).
- **Barrel files** (RECOMMENDED): a barrel may export **one layer or one feature only**. A barrel that re-exports Flutter, third-party packages and multiple layers (`utils/exports.dart`) hides layer violations and is discouraged for new code.
- **Generated files** (`*.g.dart`, `*.freezed.dart`, `*.gr.dart`): commit them (RECOMMENDED — simpler CI, reviewable diffs) or ignore them, but never mix.
- **Vendored packages** live in `packages/<name>` with a `path:` dependency, never under `lib/` (ANTI-PATTERN: a package copied under `lib/` with its own `ios/` and `.github/`).
- **Assets**: only `assets/**` (and package flag folders). Source directories must not be listed under `flutter.assets` (ANTI-PATTERN).
- **Root**: no scratch files. Remove `0`, `inspect_picker.dart`, `test_empty_notification.dart` style leftovers before merging.
- **Tests mirror `lib/`**: `test/<same path>/<file>_test.dart`.

## Recommended implementation

- Add a `tool/` or `scripts/` folder for repeatable commands (`build_runner`, format, analyze) instead of documenting them only in README.
- Keep `lib/layers/utils` (or `core/utils`) for pure Dart helpers only; anything importing Flutter widgets belongs in presentation (`views/` / `widgets/` / `controller/`, or `presentation/` in Layer First).

## Examples

Good (Feature First): `lib/features/product_list/controller/product_list_cubit.dart` beside `product_list_state.dart` and generated files.

Good (Layer First): `lib/layers/presentation/cubit/foo_list_cubit/{foo_list_cubit.dart, foo_list_state.dart, foo_list_state.freezed.dart}` — cohesive, generated file beside source.

Bad: `lib/layers/presentation/cubit/bar_cubit.dart` loose at the cubit root while every other cubit has a folder.

Bad: screen in `lib/features/foo/views/` and cubit in `lib/layers/presentation/cubit/foo` — one feature split across trees.

## Anti-patterns

- Same concept in two folders (`commonWidgets/`, `shared/`, `core/widgets/` all holding shared widgets). Pick one home per kind.
  - Feature First: `lib/shared/widgets` for design-system and cross-feature widgets; feature-only widgets stay in `features/<x>/widgets/`.
  - Layer First: default `core/widgets` for design-system primitives, `presentation/commonWidgets` for domain-aware shared widgets, retire `shared/`.
- Files named after the wrong class (`webview_page.dart` containing `WebViewScreen`).
- Bulk-moving an existing tree to Feature First "because the SOP recommends it".
- Introducing `lib/features/` on a Stay project, or putting a new file for an existing feature into the other tree on a Strangler project.

## Exceptions

Renaming existing camelCase directories is exempt from the snake_case rule until a hygiene PR is scheduled; do not rename in feature PRs.
