# Rules (AI-ready)

Compact, imperative rules for AI coding agents and quick human reference. Each `.rules` file compresses one SOP + its guardrails into one-line statements grouped by tag. Load the files relevant to the task (see `../agent.md`).

Format per line:

```text
[TAG] [ID] Imperative statement. (ref: guardrail-id | sop-section)
```

Tags: `MUST`, `MUST-NOT`, `SHOULD`, `MAY`, `PROJECT` (see `../../../../../docs/project/flutter/project-rules.md`), `LEGACY` (do not extend), `DECISION` (open; use the stated default or ask).

Historical PROJECT/LEGACY overlays from the reference app live in `../profiles/reference/rules-overlay.md` — not loaded by default.

IDs: an ID that also appears in `../guardrails` (e.g. `DI-2`, `SEC-7`) is an enforceable boundary; violations block. IDs that appear only here (e.g. `BLOC-3`, `NAME-16`, `FL-20`, `REPO-5`) are SOP-level conventions compressed for agents; they carry the tag's weight (`MUST` = required by the SOP standard, `SHOULD` = recommended) but are enforced in review, not by the compliance matrix. Every guardrail ID has at least one rule line (verified in the cross-check).

| File | Covers |
|------|--------|
| `flutter.rules` | general Dart/Flutter code quality, formatting, lints, git |
| `architecture.rules` | layers, structure, DI resolution |
| `naming.rules` | files, classes, events, models, routes, tests |
| `dependency.rules` | packages, DI registration |
| `state.rules` | Cubit/Bloc selection, state shape, pagination |
| `bloc.rules` | flutter_bloc mechanics, emit safety, providing/consuming |
| `networking.rules` | gateway, ApiRequest, interceptors, models, repositories |
| `routing.rules` | typed routes, guards, deep links |
| `ui.rules` | screens, widgets, tokens, strings, states |
| `error.rules` | Failure, catch discipline, crash reporting, logging |
| `testing.rules` | required tests, structure |
| `performance.rules` | rebuilds, lists, async, lifecycle |
| `security.rules` | secrets, tokens, logs, build |
| `ai-agent.rules` | agent workflow, conflicts, reporting |
| `accessibility.rules` | semantics, targets, text scale, contrast, motion |
| `localization.rules` | string source, ARB, plurals, formatting, RTL |
| `persistence.rules` | local storage, cache policy, outbox, migrations |
| `observability.rules` | logger, crash reporting, analytics, consent |
| `platform.rules` | permissions, push, platform channels, background |
| `release.rules` | CI, toolchain pin, versioning, flavors, store, flags, forced update |
| `docs.rules` | living docs in the same change |

Rule lines use the check variables (`$UI`, `$LOOKUP`, …) defined in `../guardrails/README.md` and filled per project in `../../../../../docs/project/flutter/project-rules.md` PR-A6. Stack-specific names (classes, packages) only appear as "e.g." examples; the active names come from `docs/project/flutter/`.

How to use in an AI environment: copy the needed `.rules` files (or reference their paths) into the agent's context. `agent.md` is always loaded first.
