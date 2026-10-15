<!-- Copy to <repo-root>/CLAUDE.md (Claude Code). Keep it short: it is loaded on every session. -->

# Project instructions

This repository is governed by `.agents/skills/flutter-workflow/references/`.

1. Before the first edit of a session, read `.agents/skills/flutter-workflow/references/agent.md` and follow its workflow (READ → INSPECT → SEARCH → DESIGN → IMPLEMENT → VERIFY → REPORT).
2. Read `docs/project/flutter/README.md` and `docs/project/flutter/project-rules.md`. If something the task needs is `_TBD_`, ask. Do not invent a stack.
3. Load the `rules/*.rules` files that `agent.md` §4 lists for the task.
4. Do not load `.agents/skills/flutter-workflow/references/profiles/` unless asked.
5. A task that conflicts with a guardrail or ADR → output the `GUARDRAIL CONFLICT` block and wait.
6. Toolchain: <!-- e.g. prefix flutter/dart with `fvm` if the project pins with FVM (CI-2) -->
7. Living docs: in the same change as the code, keep `CHANGELOG.md` (`[Unreleased]`), `CONTRIBUTING.md` and `docs/project/flutter/features.md` current. Greenfield creates them at kickoff; brownfield initialises them from repository evidence first — never invent history, features or commands (`agent.md` → MAINTAIN LIVING DOCS, DOC-1..7).
