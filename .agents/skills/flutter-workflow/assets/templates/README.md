# Templates

For RepoSeed installations, read `../../references/REPOSEED.md`: selected entrypoints are already installed. Preserve managed blocks and existing app docs. The table below describes standalone adoption sources.

Files to copy to the **repository root** when adopting `.agents/skills/flutter-workflow/references/` (see `../../references/ADOPT.md`). Tools only read them from the root.

| Source | Copy to | Tool |
|--------|---------|------|
| `CLAUDE.md` | `<root>/CLAUDE.md` | Claude Code |
| `AGENTS.md` | `<root>/AGENTS.md` | Codex, Windsurf, Antigravity, other AGENTS.md readers |
| `../.cursor/rules/flutter-ai.mdc` | `<root>/.cursor/rules/flutter-ai.mdc` | Cursor |
| `../.github/copilot-instructions.md` | `<root>/.github/copilot-instructions.md` | GitHub Copilot |
| `../.github/pull_request_template.md` | `<root>/.github/pull_request_template.md` | GitHub PRs |
| `CHANGELOG.md` | `<root>/CHANGELOG.md` (if none exists) | Living docs (`sop/living-docs.md`) |
| `CONTRIBUTING.md` | `<root>/CONTRIBUTING.md` (if none exists; otherwise merge the missing sections) | Living docs — human onboarding |

The app's feature catalogue is not a root file: it lives in `docs/project/flutter/features.md`.

## Greenfield vs brownfield

| File | Greenfield | Brownfield |
|------|------------|------------|
| `CHANGELOG.md` | copy the template at kickoff; entries start with the first feature | keep an existing changelog untouched; if none, create it with `[Unreleased]` + a baseline section for the current `pubspec.yaml` version ("Baseline at flutter-ai adoption — earlier history: git log / tags"). Never reconstruct old entries. |
| `CONTRIBUTING.md` | copy and fill from `docs/project/flutter/project-rules.md` answers | fill from what the repo actually uses (pin file, scripts, CI, branch names); if one exists, add only missing sections |
| `docs/project/flutter/features.md` | empty; add rows as features are planned | initialise one row per existing feature from routes / feature folders, with evidence |
