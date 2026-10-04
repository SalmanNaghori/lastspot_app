# Guardrails: Dependencies

SOP: `sop/dependency-management.md`.

**DEP-1** — A PR that adds a dependency MUST include the justification block (problem, existing-code check, existing-dependency check, SDK alternative, maturity, license, platforms, size, security, maintenance owner, wrapped or direct).
Check: PR template section present and filled.

**DEP-2** — A new dependency MUST NOT duplicate a capability already provided by an existing dependency or by project code (e.g. second HTTP client, second connectivity checker, second serializer, second HTML renderer).
Check: compare against `profiles/reference/dependency-inventory.md`.

**DEP-3** — Architectural dependencies (HTTP, DI, state, routing, storage, logging, analytics, realtime) MUST be wrapped behind a project abstraction and MUST NOT be imported outside the wrapping module and the DI module.
Check: `rg -l "package:dio/" lib --glob '!**/core/network/**' --glob '!**/core/di/**'`; `rg -l "package:get_storage/" lib --glob '!**/core/storage/**' --glob '!**/core/di/**'`; `rg -l "package:socket_io_client/" lib --glob '!**/core/realtime/**'`.

**DEP-4** — Adding, replacing, or removing an architectural dependency MUST be recorded in an ADR.

**DEP-5** — Transitive dependencies MUST NOT be imported directly; `// ignore: depend_on_referenced_packages` MUST NOT be used.
Check: `rg -n "depend_on_referenced_packages" lib`.

**DEP-6** — Git dependencies MUST pin a `ref` and carry a comment with the upstream issue and removal condition. `dependency_overrides` MUST carry a reason comment and MUST be reviewed each release.
Check: `rg -A3 "git:" pubspec.yaml` shows `ref:`; `rg -B1 -A2 "dependency_overrides" pubspec.yaml`.

**DEP-7** — Path dependencies MUST live under `packages/`, never under `lib/`.
Check: `find lib -name pubspec.yaml`.

**DEP-8** — A dependency with no remaining import MUST be removed in the PR that removes its last usage.
Check: for each `pubspec.yaml` dependency `<name>`: `rg -l "package:<name>/" lib` → non-empty, or a documented native-only reason.

**DEP-9** — Dependencies with GPL/AGPL licenses MUST NOT be added without explicit legal approval recorded in the PR.

**DEP-10** — Dev-only tooling (codegen, lints, test packages) MUST be under `dev_dependencies`.

**DEP-11** — The Flutter/Dart SDK constraint in `pubspec.yaml` and the version pin file(s) MUST agree; there SHOULD be exactly one pin file.
Check: compare `.fvmrc`, `.tool-versions`, `pubspec.yaml environment`.

## Reference project status

Known violations (tracked, not yet fixed): `connectivity_plus` duplicate (DEP-2), `background_location` / `aws_*` unused (DEP-8), `country_code_picker` vendored in `lib/` (DEP-7), `depend_on_referenced_packages` ignores (DEP-5), pin mismatch (DEP-11). See `profiles/reference/remediation-backlog.md`.
