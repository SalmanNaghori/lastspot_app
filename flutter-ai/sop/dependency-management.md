# SOP: Dependency Management

## Purpose

Every package is a long-term liability: build time, binary size, security surface, upgrade work, and one more way to do something. This SOP makes adding one a deliberate decision.

## Scope

`pubspec.yaml` dependencies, dev dependencies, overrides, git/path dependencies, vendored code, version policy.

## Principles

1. **Capability before package.** Prefer, in order: existing project code → existing dependency → Dart/Flutter SDK → new package.
2. **One package per concern.** Two connectivity checkers, two HTML renderers, three serializers are defects.
3. **Architectural packages are wrapped.** Anything imported from more than one layer (HTTP, storage, DI, routing, logging, analytics) sits behind a project abstraction so it can be swapped or mocked.
4. **Feature packages may be used directly** inside the feature that owns them.
5. **Every dependency has a documented purpose** (the reference project's commented `pubspec.yaml` groups are a good practice — keep it).

## Standard

### Before adding a dependency (UNIVERSAL, HIGH)

Answer in the PR description:

```text
Problem being solved:
Existing project code that could solve it:      (searched: yes/no, where)
Existing dependency that could solve it:        (checked pubspec: yes/no)
Flutter/Dart SDK alternative:
Package: name, version, pub.dev score, last release date, publisher
Maintenance: issues open/closed ratio, last commit
License: (MIT/BSD/Apache OK; GPL/AGPL need approval)
Platforms: iOS / Android / web / desktop as required by the project
Binary size impact / native code:
Security: native permissions requested, network access, known CVEs
Transitive dependencies added:
Long-term cost: who owns upgrades?
Wrapped behind abstraction? (required if architectural)
```

A PR that adds a dependency without this block is not mergeable.

### Classification (UNIVERSAL)

| Class | Definition | Rule |
|-------|------------|------|
| Architectural | Used across layers or by infrastructure (dio, get_it, flutter_bloc, hive, auto_route, logger, firebase_*) | Wrapped; change requires ADR |
| Feature | Used by one feature (just_audio, emoji_picker_flutter, wheel_picker) | Direct use inside the feature; still justified |
| Utility | Pure Dart helpers (path, mime, equatable) | Direct use |
| Dev | build_runner, freezed, json_serializable, lints, test packages | Direct |

### Version policy (RECOMMENDED)

- Caret ranges (`^x.y.z`) in `pubspec.yaml`; `pubspec.lock` committed for apps.
- `dependency_overrides` are temporary; each carries a comment with the reason and the removal condition. Review every release.
- Git dependencies pin a `ref` (commit or tag) and carry a comment with the upstream issue; plan for removal when upstream fixes land.
- Path dependencies live in `packages/`, never inside `lib/`.
- Upgrade cadence: `flutter pub outdated` once per sprint; major upgrades in dedicated PRs.

### Removal (UNIVERSAL)

Unused dependencies are removed in the PR that removes the last usage. Periodic check: for each dependency, `rg "package:<name>/" lib` — zero hits means remove (or document a native-only reason).

## Recommended implementation

Keep `pubspec.yaml` grouped by category with a one-line purpose comment per package (reference project does this). Add a `## Dependencies` section to the project README linking to `profiles/reference/dependency-inventory.md`.

## Examples

From the reference inventory (`profiles/reference/dependency-inventory.md`):

- Correctly wrapped: `dio` behind `BaseApiService`; `get_it` behind `sl`; `socket_io_client` behind `SocketClient`; `fluttertoast` behind `AppConstant.showToast`.
- Duplicate to remove: `connectivity_plus` alongside `internet_connection_checker_plus`.
- Dead: `aws_rekognition_api`, `aws_client` (code commented out), `background_location` git fork (no Dart usage found).
- Vendored incorrectly: `country_code_picker` inside `lib/layers/app/custom/`.
- Overlap to review: five media pickers (`image_picker`, `wechat_assets_picker`, `file_picker`, `camera`, `camerawesome`); two HTML renderers.

## Anti-patterns

- "There's a package for that" as the sole justification.
- Importing a transitive dependency directly with `// ignore: depend_on_referenced_packages` (reference: `photo_manager`, `google_maps_flutter_platform_interface`). Declare it or don't use it.
- Leaving dependencies whose usage was deleted or commented out.
- Wrapping a feature-only package in an abstraction with a single implementation "for testability" when the feature is UI-only.

## Exceptions

Emergency forks (git dependency) to unblock a Flutter upgrade are allowed with a pinned ref, an upstream issue link, and a backlog item to remove the fork.
