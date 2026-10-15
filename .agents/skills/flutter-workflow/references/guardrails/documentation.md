# Guardrails: Living Documentation

SOP: `sop/living-docs.md`. Docs are updated in the **same change** as the code they describe.

**DOC-1** — A user-visible change MUST add an entry under `## [Unreleased]` in `CHANGELOG.md` (Added / Changed / Fixed / Removed / Security), written for users, not developers.

**DOC-2** — Adding, renaming, moving, flagging or retiring a feature MUST update its row in `docs/project/flutter/features.md` (description, status, tree, route, state holder, repository, flag, critical journey, since). Retired features move to `## Retired`, not deleted.

**DOC-3** — An architectural decision (ADR triggers in `docs/adr/README.md`) MUST add or supersede an ADR and update the `docs/adr/README.md` index in the same PR.

**DOC-4** — Changing a shared/design-system widget's public API MUST update its documentation (dartdoc on the public constructor + the shared-widget catalogue, if the project keeps one) in the same PR.

**DOC-5** — Changing a project default (state, DI, routing, HTTP, storage, string source, test stack, flags) MUST update `docs/project/flutter/project-rules.md` and `docs/project/flutter/dependency-inventory.md` in the same PR. `_TBD_` MUST NOT be reintroduced once filled.

**DOC-6** — Changing developer setup or workflow (toolchain pin, codegen/l10n commands, config files, flavors, branch or PR rules, release owner) MUST update the app's `CONTRIBUTING.md` in the same PR. Commands in it MUST be ones the repo actually uses.

**DOC-7** — The living docs MUST exist from adoption onward, initialised per mode:
- **Greenfield:** at kickoff, copy `.agents/skills/flutter-workflow/assets/templates/CHANGELOG.md` and `.agents/skills/flutter-workflow/assets/templates/CONTRIBUTING.md` to the repo root (CONTRIBUTING filled from the kickoff answers) and keep `docs/project/flutter/features.md` empty until the first feature is planned. From then on, maintain them with every change (DOC-1, DOC-2, DOC-6).
- **Brownfield:** during the audit, initialise them from repository evidence: `docs/project/flutter/features.md` gets one row per existing feature (from the route table, feature folders, screens), status `live`/`flagged`, `Since: pre-adoption`, unknowns `_TBD_`; an existing `CHANGELOG.md` / `CONTRIBUTING.md` is kept and only missing sections are added; a missing `CHANGELOG.md` is created with `[Unreleased]` + a baseline section for the current `pubspec.yaml` version, without reconstructing past entries (AI-9); a missing `CONTRIBUTING.md` is created from the template with the commands the repo actually uses. Then maintain them like greenfield.

## Kit changes

**DOC-8** — RepoSeed manages updates to the workflow standards and records the installed revision in `.reposeed/config.json`. Standards changes are recorded in `.agents/skills/flutter-workflow/references/CHANGELOG.md`. Application work updates the app-owned `docs/project/flutter/`, `docs/adr/` and root living documents; it MUST NOT rewrite managed standards or their revision. See `../REPOSEED.md` for ownership and sync behavior.
