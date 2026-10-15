# agent.md — Flutter Architecture Governance: Master Entry Point

Read [REPOSEED.md](REPOSEED.md) first for scope, file ownership and applicability. RepoSeed manages standards updates and tracks the installed revision in `.reposeed/config.json` (DOC-8).

You are working in a Flutter repository governed by `.agents/skills/flutter-workflow/references/`. This file is the first thing to read. It tells you what the standards are, in which order they apply, what you must never do, and the exact workflow to follow for every task.

**Other AI account / greenfield:** read [`ADOPT.md`](ADOPT.md). Active project brain = `docs/project/flutter/` only. Do **not** load `.agents/skills/flutter-workflow/references/profiles/` unless the user asks.

## 1. Purpose

`.agents/skills/flutter-workflow/references/` is an engineering governance layer. It exists so that every change — by a junior developer, a senior developer, or an AI agent — lands in the same architecture, with the same conventions, tested the same way.

- **Reusable kit:** `.agents/skills/flutter-workflow/references/sop/`, `.agents/skills/flutter-workflow/references/guardrails/`, `.agents/skills/flutter-workflow/references/rules/`, `.agents/skills/flutter-workflow/references/checklists/`, this file.
- **Active project profile:** `docs/project/flutter/` (stubs for greenfield; filled for a real app).
- **Optional examples:** `profiles/reference/` incl. example ADRs in `profiles/reference/adr/` (not default context).
- **Root entry sources:** `.agents/skills/flutter-workflow/assets/templates/`, `.cursor/`, `.github/` — RepoSeed installs selected adapters; preserve its root managed blocks. Standalone adoption uses the source templates.

Stack choices (orientation first, then state, DI, routing, HTTP, storage) come from **ADRs + `docs/project/flutter/project-rules.md`**, not from example profiles.

## 2. What is where

| Folder | Answers | Read when |
|--------|---------|-----------|
| `.agents/skills/flutter-workflow/references/sop/` | How do we build Flutter software? | designing a feature, unsure why a rule exists |
| `.agents/skills/flutter-workflow/references/guardrails/` | What must never be violated? | reviewing or self-checking |
| `.agents/skills/flutter-workflow/references/rules/` | Compact imperative rules for agents | **always** — load files matching the task |
| `docs/adr/` | Why *this* project chose its stack | before structural change |
| `docs/project/flutter/` | This project's overrides, map, inventory | **always** before first edit |
| `.agents/skills/flutter-workflow/references/profiles/` | Optional historical snapshots | only if user asks |
| `.agents/skills/flutter-workflow/references/checklists/` | kickoff, brownfield audit, new feature, DoD, compliance matrix, PR review, release, exceptions | before scaffolding; before reporting done; before a release |
| `.agents/skills/flutter-workflow/assets/templates/`, `.cursor/`, `.github/` | Root entry files (CLAUDE.md, AGENTS.md, Cursor rule, Copilot, PR template, CHANGELOG) | standalone adoption; RepoSeed installs selected entrypoints |
| `ADOPT.md` | How to install in another repo/account | adopting or greenfield setup |

```text
.agents/skills/flutter-workflow/
├── SKILL.md       workflow router
├── references/    agent.md, ADOPT.md, SOPs, guardrails, rules, checklists, examples
├── assets/        project/ADR seeds, root templates and adapter sources
└── scripts/       compliance checker
.claude/skills/flutter-workflow/  complete mirror when selected
docs/project/flutter/            active app profile and inventories
docs/adr/                        app decisions or index to the existing ADR location
```

SOP, guardrail, rule, checklist and example paths in these references are relative
to this `references/` directory. Paths starting with `docs/` and application code
paths are relative to the app root. Templates and scripts are siblings of
`references/` inside the skill. Read and edit active app records in `docs/`,
leaving packaged seeds in `assets/` unchanged.


## 3. Hierarchy and conflict resolution

This hierarchy resolves Flutter technical rules within the user's authorized
task. It does not override explicit user/host instructions, credential handling,
file ownership or the task-mode boundaries in `REPOSEED.md`.

```text
1. guardrails/  MUST / MUST NOT          — absolute; overridden only by approved exception + ADR
2. docs/adr/         accepted decisions       — this project's stack
3. docs/project/flutter/project-rules.md              — may relax SHOULD/MAY, never MUST
4. sop/         standard + recommended   — SHOULD-level
5. rules/       compressed form of 1–4
6. General Flutter/Dart best practice    — where 1–5 are silent
```

Resolution:

- **Task vs MUST guardrail** → stop; `GUARDRAIL CONFLICT` block (`guardrails/ai-development.md` AI-15); wait; record exception.
- **Task vs ADR** → same; need superseding ADR to change.
- **Universal SOP vs project rule** → project rule wins.
- **`docs/project/flutter/` has `_TBD_` affecting the task** → ask; do not invent a stack or copy `profiles/reference/`. Orientation is asked **first** on greenfield (`checklists/greenfield-kickoff.md`).
- **Existing app with no orientation recorded** → detect the tree; ask Stay vs Strangler; do not run the greenfield Feature First vs Layer First ask.
- **NEEDS-DECISION with no default** → ask.
- **Existing code vs guardrail** → new code follows guardrail; list PRE-EXISTING in report.
- **Uncovered** → closest SOP principle + state assumption in report.

## 4. Mandatory workflow

The complete sequence below applies to authorized implementation. For review,
diagnosis, explanation or planning alone, inspect and report without edits,
formatting, adoption writes or mandatory kickoff. An empty profile does not block
a read-only answer unless its missing facts are necessary to answer the question.
Reuse recorded choices and answers; do not repeat resolved kickoff questions.

```text
READ  →  INSPECT  →  SEARCH  →  DESIGN  →  IMPLEMENT  →  VERIFY  →  MAINTAIN DOCS  →  REPORT
```

### READ
1. This file.
2. `docs/project/flutter/project-rules.md` + `docs/project/flutter/README.md` (and `architecture-map.md` if unfamiliar).
3. If Orientation is `_TBD_` **and** `lib/` has no app tree → run [`checklists/greenfield-kickoff.md`](checklists/greenfield-kickoff.md) section 1; **stop** until orientation is answered; do not create `lib/` files.
4. If `lib/` already has a tree and orientation is unset → run kickoff section 2 (Stay vs Strangler) and `checklists/brownfield-audit.md`; do not bulk-move files. The audit **initialises** the living docs from repository evidence (DOC-7).
5. If any other `_TBD_` blocks the task → ask the user; do not proceed with a guessed stack.
6. Matching `rules/*.rules` (table below).
7. This project's ADRs in `docs/adr/`. Example ADRs live in `profiles/reference/adr/` and are never active decisions.

| Task touches | Load rules |
|--------------|-----------|
| any code | `ai-agent.rules`, `architecture.rules`, `naming.rules`, `flutter.rules` |
| state | `state.rules`, (+ `bloc.rules` only if ADR chose flutter_bloc) , `testing.rules` |
| repository/model/API | `networking.rules`, `error.rules`, `testing.rules` |
| screen/widget | `ui.rules`, `routing.rules`, `performance.rules`, `accessibility.rules`, `localization.rules` |
| form | `ui.rules` (Forms), `accessibility.rules`, `localization.rules` |
| local storage / cache / offline | `persistence.rules`, `security.rules` |
| pubspec / DI | `dependency.rules` |
| config, auth, build | `security.rules`, `error.rules` |
| logging, crash reporting, analytics | `observability.rules`, `security.rules` |
| permissions, push, platform channels, native config | `platform.rules`, `security.rules` |
| CI, flavors, versioning, store, flags | `release.rules` |
| any user-visible change, new feature, ADR | `docs.rules` |

### INSPECT
Read the existing screen, state holder, repository, composition-root wiring, route entry, and **one sibling feature**. Note patterns actually in use. Search which tree **this feature** already occupies (`lib/features/<name>/` vs `lib/layers/...`) and place new files there.

### SEARCH
Before creating anything, `rg` for existing repositories, endpoints, models, shared widgets, events, helpers. Record searches in the report.

### DESIGN
**REUSE > EXTEND > REFACTOR > CREATE** (justify CREATE). Check guardrails before coding.

### IMPLEMENT
- Place files per `sop/project-structure.md` + `docs/project/flutter/project-rules.md` §A. Never split one feature across `lib/features/` and `lib/layers/`. Never bulk-move a tree.
- Follow loaded `.agents/skills/flutter-workflow/references/rules/`.
- Required tests in the same change.
- Regenerate codegen; never hand-edit generated files.
- No drive-by scope.

### VERIFY
Export the PR-A6 check variables first (`guardrails/README.md` → Check variables). Run Flutter/Dart through the project's pin (e.g. `fvm flutter …`, CI-2).
```sh
dart format .
flutter analyze
flutter test <relevant paths>
# Partial static checks; choose the reviewed base commit for a PR:
python3 .agents/skills/flutter-workflow/scripts/check_compliance.py --base HEAD
```

Complete `checklists/architecture-compliance.md`. Never claim a check you did not run.

### MAINTAIN LIVING DOCS (authorized changes — DOC-1..8)

You own these documents. Update them in the **same change** as the code; never leave them for later.

| Document | Update when | Greenfield start | Brownfield start |
|----------|-------------|------------------|------------------|
| `CHANGELOG.md` (repo root) | any user-visible change → `[Unreleased]` | created from `.agents/skills/flutter-workflow/assets/templates/CHANGELOG.md` at kickoff | keep existing; if missing create with `[Unreleased]` + baseline for the current `pubspec.yaml` version — never reconstruct history |
| `docs/project/flutter/features.md` | feature planned, built, renamed, flagged, retired | empty until the first feature | one row per existing feature from routes / feature folders / screens, `Since: pre-adoption`, unknowns `_TBD_` |
| `CONTRIBUTING.md` (repo root) | setup or workflow changes (pin, codegen, config, flavors, branches, PR rules) | created from `.agents/skills/flutter-workflow/assets/templates/CONTRIBUTING.md`, filled from kickoff answers | keep existing and add missing sections; if missing create with the commands the repo actually uses |
| `docs/adr/` + `docs/adr/README.md` | architectural decision | ADR-0001+ at kickoff | ADRs for choices the code already made |
| `docs/project/flutter/*.md` | project default or dependency changes | filled at kickoff | filled by the audit |
| `.agents/skills/flutter-workflow/references/CHANGELOG.md` + installed revision | managed by RepoSeed sync, not application edits | — | — |

If a document the task needs does not exist yet, create it per the start column — do not skip the update.

### REPORT
```text
TASK: <one line>

FILES
  created:   <paths>
  modified:  <paths>
  deleted:   <paths or none>

REUSE EVIDENCE
  searched:  <rg patterns / folders>
  reused:    <...>
  extended:  <...>
  created:   <...> — justification: <...>

DEPENDENCIES: none | <DEP-1 justification block>
ARCHITECTURAL IMPACT: none | <description + ADR needed? yes/no>

TESTS ADDED: <files + coverage>
LIVING DOCS: CHANGELOG <entry | none — internal>, features.md <row | n/a>, CONTRIBUTING <updated | n/a>, ADR <id | none>
VERIFICATION: format <ok/not run>, analyze <...>, tests <...>

COMPLIANCE
  <matrix from checklists/architecture-compliance.md>
  <VIOLATION blocks if any>

PRE-EXISTING VIOLATIONS OBSERVED: <IDs + locations, or none>
OPEN QUESTIONS / ASSUMPTIONS: <...>
```

## 5. What you MUST NOT do

1. Introduce a new architectural pattern, state paradigm, DI, routing, serializer, or folder convention without an approved ADR (AI-5).
2. Add a dependency without DEP-1; add an architectural dependency without flagging ADR need (AI-6).
3. Resolve the DI container outside composition roots (DI-2).
4. Put business logic, repository/storage access, or container lookups in widgets (UI-1, UI-2, ARCH-5).
5. Import Flutter UI into `domain/` or `data/` (ARCH-2).
6. Use `Navigator.push`/`MaterialPageRoute` for app screens; hardcode route strings (ROUTE-1, ROUTE-2).
7. Add boolean flag-soup async state or per-feature status enums (STATE-4).
8. Emit/update state after `await` without a closed/mounted/disposed guard (STATE-5).
9. Empty or log-only catches; show stack traces to users; use `print` (ERR-3, ERR-4, ERR-6).
10. Hardcode secrets, env values, colors, sizes, or user-facing strings (SEC-1, UI-3, UI-5).
11. Put tokens in URLs or logs; store secrets in weak storage (SEC-6, SEC-7, SEC-10).
12. Use `Future.delayed` to wait for another component (ASYNC-5).
13. Leave subscriptions, timers, or controllers undisposed (ASYNC-1, ASYNC-2).
14. Modify files outside task scope; hand-edit generated files; delete unproven-unused code (AI-7, AI-13, AI-14).
15. Bypass or `// ignore:` a guardrail to make a change pass (AI-8).
16. Invent project history or backend behaviour — write "Not determinable from repository evidence" (AI-9).
17. Skip required tests (AI-12).
18. Declare done without compliance matrix + report (AI-19, AI-20).
19. Copy `profiles/reference/` types into a greenfield app, or follow example ADRs that contradict filled `docs/project/flutter/` rules (AI-26).
20. Scaffold `lib/` on greenfield before orientation is answered; bulk-migrate an existing tree; split one feature across two trees (ARCH-7, AI-11).
21. Finish a task without updating `CHANGELOG.md`, `docs/project/flutter/features.md` or `CONTRIBUTING.md` when the change requires it; invent changelog history, features or setup commands on a brownfield app (DOC-1..7, AI-9).

## 6. Quick reference — fill from *this* project

Read `docs/project/flutter/README.md` and the ADRs it cites. Until stubs are filled, this section is intentionally empty of package names.

| Concern | Source of truth |
|---------|-----------------|
| Level + orientation | `docs/project/flutter/README.md` + ADR |
| State / DI / routing / HTTP / storage | ADRs + `docs/project/flutter/project-rules.md` |
| File placement | `docs/project/flutter/project-rules.md` §A + `sop/project-structure.md` |
| UI tokens / strings | `docs/project/flutter/project-rules.md` §F |
| Tests | `docs/project/flutter/project-rules.md` §H + `guardrails/testing.md` |
| Storage / offline | `docs/project/flutter/project-rules.md` §J + `guardrails/persistence.md` |
| Logging / crash / analytics | `docs/project/flutter/project-rules.md` §K + `guardrails/observability.md` |
| Flavors / CI / release | `docs/project/flutter/project-rules.md` §L + `guardrails/release.md` |
| Check variables for `rg` checks | `docs/project/flutter/project-rules.md` PR-A6 |

Apply the chosen architecture level and capabilities (see `REPOSEED.md`): inward dependencies where layers exist, no UI in domain/data, consistent immutable state, the selected routing approach, one HTTP boundary when networking exists, no credentials in source, and tests proportionate to the change.

## 7. Links

- Adopt: [`ADOPT.md`](ADOPT.md)
- SOP: [`sop/README.md`](sop/README.md)
- Guardrails: [`guardrails/README.md`](guardrails/README.md)
- Rules: [`rules/README.md`](rules/README.md)
- ADR: [`docs/adr/README.md`](../../../../docs/adr/README.md)
- Project: [`docs/project/flutter/README.md`](../../../../docs/project/flutter/README.md)
- Profiles (optional): [`profiles/README.md`](profiles/README.md)
- Checklists: [`.agents/skills/flutter-workflow/references/checklists/`](checklists) — kickoff: [`greenfield-kickoff.md`](checklists/greenfield-kickoff.md), [`brownfield-audit.md`](checklists/brownfield-audit.md), [`new-feature.md`](checklists/new-feature.md), [`pr-review.md`](checklists/pr-review.md), [`release.md`](checklists/release.md)
- Root entry templates: [`.agents/skills/flutter-workflow/assets/templates/README.md`](../assets/templates/README.md)

## 8. Adopting in another Flutter project / AI account

Follow [`ADOPT.md`](ADOPT.md). Short version:

1. Copy `.agents/skills/flutter-workflow/references/`; keep greenfield `docs/project/flutter/` stubs; leave `.agents/skills/flutter-workflow/references/profiles/` out of agent context.
2. Run [`checklists/greenfield-kickoff.md`](checklists/greenfield-kickoff.md): orientation first (or Stay vs Strangler on an existing app). Write ADRs + fill `docs/project/flutter/*` `_TBD_` fields. Do not copy example ADR-0001 unless Layer First was chosen for this app.
3. In RepoSeed, keep the installed selected entrypoints and managed blocks. For standalone adoption, use the source table in `.agents/skills/flutter-workflow/assets/templates/README.md`; merge existing root instructions.
