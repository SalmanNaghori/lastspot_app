# Feature catalogue

What the app does, one row per user-facing feature. Kept current in the **same PR** as the code (DOC-2). Long form: `sop/living-docs.md`.

- **Greenfield:** starts empty; a row is added when a feature is planned or scaffolded (`checklists/new-feature.md`).
- **Brownfield:** initialised from the existing code during the audit (`checklists/brownfield-audit.md` §1), with evidence paths. Unknown fields are `_TBD_`, never guessed (AI-9).

Status values: `observed` (source evidence only; runtime/release unverified) · `planned` · `in-progress` · `live` · `flagged` (behind a feature flag) · `deprecated` · `retired`.

## Features

| Feature | Description (user view) | Status | Owner | Tree / folder | Route(s) | State holder | Repository | Flag (REL-6) | Critical journey (TEST-20) | Permissions / push (PLAT-*) | Since |
|---------|-------------------------|--------|-------|---------------|----------|--------------|------------|--------------|----------------------------|-----------------------------|-------|
| _(none yet)_ | | | | | | | | | | | |

Column notes:
- **Tree / folder:** e.g. `lib/features/checkout/` or the legacy layer folders (ARCH-7).
- **Since:** the app version that first shipped it (from `CHANGELOG.md`); `pre-adoption` for brownfield features that existed before `.agents/skills/flutter-workflow/references/` was adopted.

## Retired

| Feature | Removed in | Replaced by / notes |
|---------|------------|---------------------|
