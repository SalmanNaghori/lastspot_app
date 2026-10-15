# Platform support

The initializer uses the open Agent Skills format: a skill directory containing
`SKILL.md` with `name` and `description` frontmatter, plus optional scripts,
references, assets, and product metadata.

## Portable layout

`.agents/skills/<skill-name>/SKILL.md` is the canonical project library because
it is discovered by Codex, Cursor, and Antigravity. Claude Code currently uses
`.claude/skills/<skill-name>/SKILL.md`, so the initializer creates a managed
mirror when Claude is selected.

Repository-wide behavior lives in `AGENTS.md`. Claude receives the same baseline
through a small `CLAUDE.md` bridge that imports `AGENTS.md` and
`AGENTS.local.md`. Project-specific commands and selected profile pointers stay
in `AGENTS.local.md` so the shared baseline remains reusable.

The `node-mongodb`, `node-postgres`, and `react` profiles use this same layout:
each skill's relative references and interface metadata are copied completely
to both libraries. Profile descriptions and the root guidance scope each rule
set to its matching application.

Verify skill discovery with the adapter tests before releasing platform changes.
Review added external skills like dependencies: inspect instructions and scripts,
pin a revision, confirm the license, and keep one owner per workflow.
