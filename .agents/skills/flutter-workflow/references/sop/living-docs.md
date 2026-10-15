# SOP: Living Documentation

## Purpose

Keep the documents that people and agents rely on true, by updating them in the same change as the code.

## Scope

`CHANGELOG.md`, `CONTRIBUTING.md`, `docs/project/flutter/features.md` (feature catalogue), `docs/project/flutter/architecture-map.md`, `docs/adr/`, `docs/project/flutter/project-rules.md`, `docs/project/flutter/dependency-inventory.md`, shared-widget docs, `docs/project/flutter/remediation-backlog.md`. Guardrails: `../guardrails/documentation.md` (DOC-*).

## Principles

1. Docs change with the code, in the same PR — never "later".
2. Each fact has one home; others link to it.
3. Write for the reader of that file (users for CHANGELOG, developers/agents for the map).

## Standard

### Trigger table (UNIVERSAL, HIGH)

| Change | Update |
|--------|--------|
| User-visible behaviour (feature, fix, removal) | `CHANGELOG.md` `[Unreleased]` (DOC-1) |
| New / renamed / moved / flagged / retired feature | `docs/project/flutter/features.md` row (DOC-2) |
| Setup / workflow change (pin, codegen, config, flavors, branches, PR rules) | `CONTRIBUTING.md` (DOC-6) |
| Managed workflow standards update | RepoSeed sync maintains `.agents/skills/flutter-workflow/references/CHANGELOG.md` and the installed revision in `.reposeed/config.json` (DOC-8) |
| Architectural decision (state, DI, routing, HTTP, storage, structure, exception) | new ADR + `docs/adr/README.md` index (DOC-3) |
| Shared widget public API | dartdoc + catalogue (DOC-4) |
| Project default / dependency | `docs/project/flutter/project-rules.md`, `docs/project/flutter/dependency-inventory.md` (DOC-5) |
| Debt found but not fixed | `docs/project/flutter/remediation-backlog.md` |
| Release | CHANGELOG section promoted (REL-2) |

### CHANGELOG (UNIVERSAL)

- Format: Keep a Changelog; sections Added / Changed / Fixed / Removed / Security. Template: `../../assets/templates/CHANGELOG.md`.
- Entries describe the user impact: "Checkout now remembers your last payment method", not "Refactor PaymentCubit".

### Feature catalogue (UNIVERSAL)

`docs/project/flutter/features.md` is the single list of what the app does (description, status, owner, tree, routes, state holder, repository, flag, critical journey, permissions/push, since). Retired features move to `## Retired` with the version they were removed in. `architecture-map.md` links to it instead of duplicating it.

### CONTRIBUTING (UNIVERSAL)

Root `CONTRIBUTING.md` (template: `../../assets/templates/CONTRIBUTING.md`) is the practical onboarding page: setup commands through the pin, where things go, branches/commits, PR flow, how to change the rules, release owner. It links into `.agents/skills/flutter-workflow/references/` rather than copying it.

### Initialising the docs (UNIVERSAL — DOC-7)

| | Greenfield | Brownfield |
|---|---|---|
| `CHANGELOG.md` | copy template at kickoff | keep existing; else create with `[Unreleased]` + baseline section for the current version. Never reconstruct history. |
| `CONTRIBUTING.md` | copy template, fill from kickoff answers | keep existing and add missing sections; else create from template with the commands the repo really uses |
| `docs/project/flutter/features.md` | empty until the first feature | one row per existing feature from routes / feature folders / screens, `Since: pre-adoption`, unknowns `_TBD_` |

After initialisation both modes maintain them identically with every change.

## Recommended implementation

- PR template checklist item (already in `../../assets/.github/pull_request_template.md`).
- Compliance script warns when `lib/` changed without a CHANGELOG change (`checklists/architecture-compliance.md`).

## Anti-patterns

- A `docs/` folder that nobody updates; duplicate feature lists in several READMEs.
- Changelog entries copied from commit messages.

## Exceptions

Pure refactors and test-only changes need no CHANGELOG entry (state "none — internal" in the PR).
