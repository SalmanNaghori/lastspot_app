<!-- Copy to <repo-root>/AGENTS.md (Codex, Windsurf, Antigravity, Jules and other agents that read AGENTS.md). -->

# Agent instructions

This repository is governed by `.agents/skills/flutter-workflow/references/`. Its entry point is `.agents/skills/flutter-workflow/references/agent.md`. Read it first and follow it.

- Project-specific choices: `docs/project/flutter/` (ask on any `_TBD_` the task needs).
- Compact rules: `rules/*.rules` (which files to load per task: `agent.md` §4).
- Hard boundaries: `.agents/skills/flutter-workflow/references/guardrails/`.
- Definition of done: `checklists/definition-of-done.md`.
- Never load `.agents/skills/flutter-workflow/references/profiles/` unless asked.
- Living docs: in the same change as the code, keep `CHANGELOG.md` (`[Unreleased]`), `CONTRIBUTING.md` and `docs/project/flutter/features.md` current. Greenfield creates them at kickoff; brownfield initialises them from repository evidence first — never invent history, features or commands (`agent.md` → MAINTAIN LIVING DOCS, DOC-1..7).
