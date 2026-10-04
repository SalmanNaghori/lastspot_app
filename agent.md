# agent.md — Flutter Architecture Governance: Master Entry Point

You are working in a Flutter repository governed by `flutter-ai/`. This file is the first thing to read. It tells you what the standards are, in which order they apply, what you must never do, and the exact workflow to follow for every task.

**Other AI account / greenfield:** read [`ADOPT.md`](flutter-ai/ADOPT.md). Active project brain = `project/` only. Do **not** load `profiles/` unless the user asks.

## 1. Purpose

`flutter-ai/` is an engineering governance layer. It exists so that every change — by a junior developer, a senior developer, or an AI agent — lands in the same architecture, with the same conventions, tested the same way.

- **Reusable kit:** `sop/`, `guardrails/`, `rules/`, `checklists/`, this file.
- **Active project profile:** `project/` (stubs for greenfield; filled for a real app).
- **Optional examples:** `profiles/reference/` + example ADRs `0001`–`0008` (not default context).

Stack choices (orientation first, then state, DI, routing, HTTP, storage) come from **ADRs + `project/project-rules.md`**, not from example profiles.

## 2. What is where

| Folder | Answers | Read when |
|--------|---------|-----------|
| `sop/` | How do we build Flutter software? | designing a feature, unsure why a rule exists |
| `guardrails/` | What must never be violated? | reviewing or self-checking |
| `rules/` | Compact imperative rules for agents | **always** — load files matching the task |
| `adr/` | Why *this* project chose its stack | before structural change; ignore example ADRs if they contradict `project/` |
| `project/` | This project's overrides, map, inventory | **always** before first edit |
| `profiles/` | Optional historical snapshots | only if user asks |
| `checklists/` | DoD, compliance matrix, exceptions, **kickoff** | before reporting done; **before scaffolding** on greenfield/brownfield |
| `ADOPT.md` | How to install in another repo/account | adopting or greenfield setup |

```text
flutter-ai/
├── agent.md
├── ADOPT.md
├── sop/
├── guardrails/
├── rules/
├── adr/           TEMPLATE + README; 0001–0008 = optional examples
├── project/       ACTIVE profile (stubs until filled)
├── profiles/      optional reference snapshots
└── checklists/
```

## 3. Hierarchy and conflict resolution

```text
1. guardrails/  MUST / MUST NOT          — absolute; overridden only by approved exception + ADR
2. adr/         accepted decisions       — this project's stack (not example ADRs if superseded by project/)
3. project/project-rules.md              — may relax SHOULD/MAY, never MUST
4. sop/         standard + recommended   — SHOULD-level
5. rules/       compressed form of 1–4
6. General Flutter/Dart best practice    — where 1–5 are silent
```

Resolution:

- **Task vs MUST guardrail** → stop; `GUARDRAIL CONFLICT` block (`guardrails/ai-development.md` AI-15); wait; record exception.
- **Task vs ADR** → same; need superseding ADR to change.
- **Universal SOP vs project rule** → project rule wins.
- **`project/` still has `_TBD_`** → ask; do not invent a stack or copy `profiles/reference/`. Orientation is asked **first** on greenfield (`checklists/greenfield-kickoff.md`).
- **Existing app with no orientation recorded** → detect the tree; ask Stay vs Strangler; do not run the greenfield Feature First vs Layer First ask.
- **NEEDS-DECISION with no default** → ask.
- **Existing code vs guardrail** → new code follows guardrail; list PRE-EXISTING in report.
- **Uncovered** → closest SOP principle + state assumption in report.

## 4. Mandatory workflow

```text
READ  →  INSPECT  →  SEARCH  →  DESIGN  →  IMPLEMENT  →  VERIFY  →  REPORT
```

### READ
1. This file.
2. `project/project-rules.md` + `project/README.md` (and `architecture-map.md` if unfamiliar).
3. If Orientation is `_TBD_` **and** `lib/` has no app tree → run [`checklists/greenfield-kickoff.md`](flutter-ai/checklists/greenfield-kickoff.md) section 1; **stop** until orientation is answered; do not create `lib/` files.
4. If `lib/` already has a tree and orientation is unset → run kickoff section 2 (Stay vs Strangler); do not bulk-move files.
5. If any other `_TBD_` blocks the task → ask the user; do not proceed with a guessed stack.
6. Matching `rules/*.rules` (table below).
7. ADRs that apply to *this* project (skip example ADRs that conflict with filled project rules). Example ADR-0001 is Layer First only — not the greenfield default.

| Task touches | Load rules |
|--------------|-----------|
| any code | `ai-agent.rules`, `architecture.rules`, `naming.rules`, `flutter.rules` |
| state | `state.rules`, (+ `bloc.rules` only if ADR chose flutter_bloc) , `testing.rules` |
| repository/model/API | `networking.rules`, `error.rules`, `testing.rules` |
| screen/widget | `ui.rules`, `routing.rules`, `performance.rules` |
| pubspec / DI | `dependency.rules` |
| config, storage, logging, auth, build | `security.rules`, `error.rules` |

### INSPECT
Read the existing screen, state holder, repository, composition-root wiring, route entry, and **one sibling feature**. Note patterns actually in use. Search which tree **this feature** already occupies (`lib/features/<name>/` vs `lib/layers/...`) and place new files there.

### SEARCH
Before creating anything, `rg` for existing repositories, endpoints, models, shared widgets, events, helpers. Record searches in the report.

### DESIGN
**REUSE > EXTEND > REFACTOR > CREATE** (justify CREATE). Check guardrails before coding.

### IMPLEMENT
- Place files per `sop/project-structure.md` + `project/project-rules.md` §A. Never split one feature across `lib/features/` and `lib/layers/`. Never bulk-move a tree.
- Follow loaded `rules/`.
- Required tests in the same change.
- Regenerate codegen; never hand-edit generated files.
- No drive-by scope.

### VERIFY
```sh
dart format .
flutter analyze
flutter test <relevant paths>
# adapt DI check to the project (examples):
# get_it:   git diff -U0 | rg "^\+.*sl<" | rg -v "BlocProvider|wrappedRoute|create:"
# tokens:   git diff -U0 | rg "^\+.*(Colors\.(?!transparent)|Color\(0x|fontSize:|Text\('[A-Za-z])"
# hygiene:  git diff -U0 | rg "^\+.*(print\(|catch \(_\)|Future.delayed|Navigator\.push|MaterialPageRoute)"
# secrets:  git diff -U0 | rg "^\+.*(AIza|token=|Bearer )"
# tree:     Stay — no new lib/features/ unless that is already the tree
#           Strangler — feature name not new under both lib/features and lib/layers
```

Complete `checklists/architecture-compliance.md`. Never claim a check you did not run.

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
19. Copy `profiles/reference/` types into a greenfield app, or follow example ADRs that contradict filled `project/` rules (AI-26).
20. Scaffold `lib/` on greenfield before orientation is answered; bulk-migrate an existing tree; split one feature across two trees (ARCH-7, AI-11).

## 6. Quick reference — fill from *this* project

Read `project/README.md` and the ADRs it cites. Until stubs are filled, this section is intentionally empty of package names.

| Concern | Source of truth |
|---------|-----------------|
| Level + orientation | `project/README.md` + ADR |
| State / DI / routing / HTTP / storage | ADRs + `project/project-rules.md` |
| File placement | `project/project-rules.md` §A + `sop/project-structure.md` |
| UI tokens / strings | `project/project-rules.md` §F |
| Tests | `project/project-rules.md` §H + `guardrails/testing.md` |

Universal always: inward dependencies, no UI in domain/data, one state paradigm, immutable state, typed routes, single HTTP gateway, secrets not in source, tests with the change.

## 7. Links

- Adopt: [`ADOPT.md`](flutter-ai/ADOPT.md)
- SOP: [`sop/README.md`](flutter-ai/sop/README.md)
- Guardrails: [`guardrails/README.md`](flutter-ai/guardrails/README.md)
- Rules: [`rules/README.md`](flutter-ai/rules/README.md)
- ADR: [`adr/README.md`](flutter-ai/adr/README.md)
- Project: [`project/README.md`](flutter-ai/project/README.md)
- Profiles (optional): [`profiles/README.md`](flutter-ai/profiles/README.md)
- Checklists: [`checklists/`](checklists/) — kickoff: [`checklists/greenfield-kickoff.md`](flutter-ai/checklists/greenfield-kickoff.md)

## 8. Adopting in another Flutter project / AI account

Follow [`ADOPT.md`](flutter-ai/ADOPT.md). Short version:

1. Copy `flutter-ai/`; keep greenfield `project/` stubs; leave `profiles/` out of agent context.
2. Run [`checklists/greenfield-kickoff.md`](flutter-ai/checklists/greenfield-kickoff.md): orientation first (or Stay vs Strangler on an existing app). Write ADRs + fill `project/*` `_TBD_` fields. Do not copy example ADR-0001 unless Layer First was chosen for this app.
3. Point Cursor/Claude at `agent.md` (see `.cursor/rules/flutter-ai.mdc`).
