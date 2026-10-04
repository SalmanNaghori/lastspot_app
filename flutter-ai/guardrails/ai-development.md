# Guardrails: AI-Assisted Development

Applies to every AI coding agent (Cursor, Claude Code, Copilot, Codex, custom) working in a repository that contains `flutter-ai/`. Master workflow: `../agent.md`.

## Before writing code

**AI-1** — The agent MUST read `flutter-ai/agent.md`, the relevant `rules/*.rules` files, and `project/project-rules.md` before its first edit in a session.

**AI-2** — The agent MUST inspect the existing implementation of the area it is changing (at least: the screen, its state holder, the repository, the DI registration, and one sibling feature) before proposing a design. If Orientation is `_TBD_` and `lib/` has no app tree, the agent MUST stop and run `checklists/greenfield-kickoff.md` (orientation first) before scaffolding. If `lib/` already has a tree and orientation is unset, the agent MUST ask Stay vs Strangler — not the greenfield Feature First vs Layer First question — and MUST NOT bulk-move folders.

**AI-3** — The agent MUST search for existing code that already solves part of the task (widgets, repositories, models, endpoints, helpers, events) and MUST report what it found and reused. Search evidence (`rg` patterns or file paths) MUST appear in the final report.

**AI-4** — The agent MUST follow the priority **REUSE > EXTEND > REFACTOR > CREATE**. Creating a new abstraction, pattern, folder convention, or dependency MUST be the last option and MUST be justified in the report.

## While writing code

**AI-5** — The agent MUST NOT introduce a new architectural pattern, state-management approach, DI mechanism, routing style, serialization stack, or folder convention that differs from the project's recorded decisions (ADRs, `project/project-rules.md`).

**AI-6** — The agent MUST NOT add a dependency without producing the justification block from `guardrails/dependencies.md` DEP-1 and MUST NOT add an architectural dependency without flagging that an ADR is required.

**AI-7** — The agent MUST NOT modify files outside the task's scope: no drive-by refactors, formatting-only changes to untouched files, renames of unrelated directories, or deletion of code it did not fully trace.

**AI-8** — The agent MUST NOT silently bypass, disable, or weaken any guardrail (e.g. adding `// ignore:`, removing a guard, changing a lint rule, loosening a test) to make its change pass.

**AI-9** — The agent MUST NOT invent project history, ADR rationale, API contracts, backend behaviour, or the intent behind existing code. When unknown, it MUST write "Not determinable from repository evidence" and, if the gap blocks the task, stop and ask.

**AI-10** — The agent MUST NOT hardcode secrets, environment values, design values (colors/sizes), or user-facing strings; it MUST use the project's config, tokens, and string constants.

**AI-11** — The agent MUST place new files according to `sop/project-structure.md` and the project's orientation. A feature MUST NOT be split across `lib/features/` and `lib/layers/`. The agent MUST NOT bulk-move a legacy tree. On a Strangler project, new files for an existing feature go in that feature's current tree.

**AI-12** — The agent MUST include the tests required by `guardrails/testing.md` in the same change set. "Tests to follow" is not acceptable.

**AI-13** — The agent MUST NOT modify generated files by hand; it MUST regenerate them with the project's build command.

**AI-14** — The agent MUST NOT delete or comment out code it cannot prove unused (search for references, routes, DI registrations, reflection/JSON keys).

## Conflicts and exceptions

**AI-15** — When the task conflicts with a guardrail or ADR, the agent MUST stop, report the conflict using the format below, and MUST NOT proceed with the violating approach unless the user explicitly approves an exception. The agent MUST then record the exception via `checklists/exception-request.md`.

```text
GUARDRAIL CONFLICT
Rule:        <ID> — <statement>
Task asks:   <what the request requires>
Conflict:    <why it violates the rule>
Options:     (a) compliant alternative ... (b) exception (needs approval + ADR) ... (c) narrow the task ...
Recommendation: <a|b|c> because ...
```

**AI-16** — When the codebase itself violates a guardrail in the area being changed, the agent MUST NOT extend the violation. It MUST follow the guardrail for new code, leave the existing violation untouched (unless the task is to fix it), and list the pre-existing violation in the report.

**AI-17** — When two project patterns coexist (NEEDS-DECISION items), the agent MUST use the one designated as default in `project/project-rules.md`; if none is designated, it MUST ask, not choose.

## After writing code

**AI-18** — The agent MUST run `dart format`, `flutter analyze`, and the relevant tests, and MUST report the results. If it cannot run them, it MUST say so explicitly.

**AI-19** — The agent MUST self-review against `checklists/architecture-compliance.md` and include the PASS/FAIL matrix in its report.

**AI-20** — The final report MUST contain: files created/modified, reuse evidence, dependency changes (or "none"), architectural impact (or "none"), tests added, compliance matrix, pre-existing violations observed, open questions. The format is in `agent.md`.

## Mechanical checks an agent can run on its own diff

```sh
git diff --name-only | rg "^lib/"                       # scope
git diff -U0 | rg "^\+.*sl<" | rg -v "BlocProvider|wrappedRoute|create:"   # DI-2 / UI-1
git diff -U0 | rg "^\+.*(Colors\.(?!transparent)|Color\(0x|fontSize:)"   # UI-3
git diff -U0 | rg "^\+.*Text\('[A-Za-z]"                                  # UI-5
git diff -U0 | rg "^\+.*(print\(|Future.delayed|catch \(_\))"             # ERR-6 / ASYNC-5 / ERR-3
git diff -U0 | rg "^\+.*(Navigator\.push|CupertinoPageRoute|MaterialPageRoute)"  # ROUTE-1
git diff -U0 | rg "^\+.*(AIza|token=|Bearer )"                            # SEC-1 / SEC-7
git diff --name-only | rg "pubspec.yaml"                                  # DEP-1 needed?
git diff --name-only | rg "\.(g|freezed|gr)\.dart$"                       # STRUCT-5 regenerated, not hand-edited
```
