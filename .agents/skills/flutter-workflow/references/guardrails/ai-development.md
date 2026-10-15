# Guardrails: AI-Assisted Development

Applies to every AI coding agent (Cursor, Claude Code, Copilot, Codex, custom) working in a repository that contains `.agents/skills/flutter-workflow/references/`. Master workflow: `../agent.md`.

Apply `../REPOSEED.md` first: these coding obligations do not authorize edits or
kickoff during read-only reviews, diagnoses, explanations or planning. Report
violations with paths, line numbers and redacted descriptions, never secret values.

## Before writing code

**AI-1** — The agent MUST read `.agents/skills/flutter-workflow/references/agent.md`, the relevant `rules/*.rules` files, and `docs/project/flutter/project-rules.md` before its first edit in a session.

**AI-2** — The agent MUST inspect the existing implementation of the area it is changing (at least: the screen, its state holder, the repository, the DI registration, and one sibling feature) before proposing a design. If Orientation is `_TBD_` and `lib/` has no app tree, the agent MUST stop and run `checklists/greenfield-kickoff.md` (orientation first) before scaffolding. If `lib/` already has a tree and orientation is unset, the agent MUST ask Stay vs Strangler — not the greenfield Feature First vs Layer First question — and MUST NOT bulk-move folders.

**AI-3** — The agent MUST search for existing code that already solves part of the task (widgets, repositories, models, endpoints, helpers, events) and MUST report what it found and reused. Search evidence (`rg` patterns or file paths) MUST appear in the final report.

**AI-4** — The agent MUST follow the priority **REUSE > EXTEND > REFACTOR > CREATE**. Creating a new abstraction, pattern, folder convention, or dependency MUST be the last option and MUST be justified in the report.

## While writing code

**AI-5** — The agent MUST NOT introduce a new architectural pattern, state-management approach, DI mechanism, routing style, serialization stack, or folder convention that differs from the project's recorded decisions (ADRs, `docs/project/flutter/project-rules.md`).

**AI-6** — The agent MUST NOT add a dependency without producing the justification block from `guardrails/dependencies.md` DEP-1 and MUST NOT add an architectural dependency without flagging that an ADR is required.

**AI-7** — The agent MUST NOT modify files outside the task's scope: no drive-by refactors, formatting-only changes to untouched files, renames of unrelated directories, or deletion of code it did not fully trace.

**AI-8** — The agent MUST NOT silently bypass, disable, or weaken any guardrail (e.g. adding `// ignore:`, removing a guard, changing a lint rule, loosening a test) to make its change pass.

**AI-9** — The agent MUST NOT invent project history, ADR rationale, API contracts, backend behaviour, or the intent behind existing code. When unknown, it MUST write "Not determinable from repository evidence" and, if the gap blocks the task, stop and ask.

**AI-10** — The agent MUST NOT hardcode secrets, environment values, design values (colors/sizes), or user-facing strings; it MUST use the project's config, tokens, and string constants.

**AI-11** — The agent MUST place new files according to `sop/project-structure.md` and the project's orientation. A feature MUST NOT be split across two trees (e.g. `lib/features/` and a legacy layer-first root). The agent MUST NOT bulk-move a legacy tree. On a Strangler project, new files for an existing feature go in that feature's current tree.

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

**AI-17** — When two project patterns coexist (NEEDS-DECISION items), the agent MUST use the one designated as default in `docs/project/flutter/project-rules.md`; if none is designated, it MUST ask, not choose.

## After writing code

**AI-18** — The agent MUST run `dart format`, `flutter analyze`, and the relevant tests, and MUST report the results. If it cannot run them, it MUST say so explicitly.

**AI-19** — The agent MUST self-review against `checklists/architecture-compliance.md` and include the PASS/FAIL matrix in its report.

**AI-20** — The final report MUST contain: files created/modified, reuse evidence, dependency changes (or "none"), architectural impact (or "none"), tests added, compliance matrix, pre-existing violations observed, open questions. The format is in `agent.md`.

## Diff self-checks

Choose an explicit reviewed base commit. Inspect staged, unstaged and untracked
changes too. The portable partial checker is
`python3 .agents/skills/flutter-workflow/scripts/check_compliance.py --base <commit>`; its success does
not prove the manual checks below. A missing tool or failed command is not PASS.

**AI-21** — The diff MUST NOT add container lookups outside composition roots.
Check manually using the project's selected lookup syntax and allowlisted file
paths (`guardrails/README.md`). Filtering diff content by a path pattern cannot
establish which file contains a lookup. Mark N/A when no container is selected.

**AI-22** — The diff MUST NOT add raw design values or literal user-facing strings outside the token/string files.
Review added lines against the selected token/string files, including new files.
Distinguish user-facing strings from internal identifiers; no PCRE tool is required.

**AI-23** — The diff MUST NOT add `print`, swallowed catches, readiness `Future.delayed`, or untyped navigation; any hit MUST be justified in the report.
Run the partial checker for print/empty-catch candidates, then review delays and
navigation against the selected architecture level and routing ADR. L1 Navigator
use is allowed when selected; do not introduce a router solely to satisfy an example.

**AI-24** — The diff MUST NOT add secrets or tokens in URLs.
Use location-only findings from the partial checker and the project's established
secret scanner. Never echo matching source or raw credentials into output. Follow
the credential exposure gate before further task tools if a value is exposed.

**AI-25** — If `pubspec.yaml` changed, the report MUST contain the DEP-1 block.
Check: `git diff --name-only | rg "pubspec.yaml"`.

**AI-26** — The agent MUST NOT load `.agents/skills/flutter-workflow/references/profiles/` or copy types, paths or decisions from the reference snapshot or its example ADRs (`profiles/reference/adr/`) into a project unless the user explicitly asked for that profile.

Also check: `git diff --name-only | rg "\.(g|freezed|gr|config)\.dart$"` → regenerated, not hand-edited (STRUCT-5, AI-13).
