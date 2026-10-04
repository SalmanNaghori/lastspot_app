# Rules (AI-ready)

Compact, imperative rules for AI coding agents and quick human reference. Each `.rules` file compresses one SOP + its guardrails into one-line statements grouped by tag. Load the files relevant to the task (see `../agent.md`).

Format per line:

```text
[TAG] [ID] Imperative statement. (ref: guardrail-id | sop-section)
```

Tags: `MUST`, `MUST-NOT`, `SHOULD`, `MAY`, `PROJECT` (see `../project/project-rules.md`), `LEGACY` (do not extend), `DECISION` (open; use the stated default or ask).

Historical PROJECT/LEGACY overlays from the reference app live in `../profiles/reference/rules-overlay.md` — not loaded by default.

IDs: an ID that also appears in `../guardrails/` (e.g. `DI-2`, `SEC-7`) is an enforceable boundary; violations block. IDs that appear only here (e.g. `BLOC-3`, `NAME-16`, `FL-20`, `REPO-5`) are SOP-level conventions compressed for agents; they carry the tag's weight (`MUST` = required by the SOP standard, `SHOULD` = recommended) but are enforced in review, not by the compliance matrix. Every guardrail ID has at least one rule line (verified in the cross-check).

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

How to use in an AI environment: copy the needed `.rules` files (or reference their paths) into the agent's context. `agent.md` is always loaded first.
