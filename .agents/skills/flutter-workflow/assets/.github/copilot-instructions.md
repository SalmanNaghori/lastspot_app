<!-- Copy to <repo-root>/.github/copilot-instructions.md (GitHub Copilot). -->

This repository is governed by `.agents/skills/flutter-workflow/references/`. Follow `.agents/skills/flutter-workflow/references/agent.md`, the project profile in `docs/project/flutter/`, and the rule files in `.agents/skills/flutter-workflow/references/rules/` that match the task. Do not invent stack choices that `docs/project/flutter/project-rules.md` leaves `_TBD_`; ask instead. Do not use `.agents/skills/flutter-workflow/references/profiles/` as a source of truth.

Living docs: in the same change as the code, keep `CHANGELOG.md` (`[Unreleased]`), `CONTRIBUTING.md` and `docs/project/flutter/features.md` current. Greenfield creates them at kickoff; brownfield initialises them from repository evidence first — never invent history, features or commands (`agent.md` → MAINTAIN LIVING DOCS, DOC-1..7).
