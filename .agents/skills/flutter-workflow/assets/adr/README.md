# Architectural Decision Records

An ADR records one significant, hard-to-reverse decision: what was decided, why, what else was considered, and what it costs.

## When an ADR is required

- Choosing or replacing: state management, routing, DI, HTTP client, persistence, serialization, realtime transport, authentication flow, **project structure orientation** (Feature First, Layer First, or brownfield mixed/Strangler).
- Any approved exception to a `.agents/skills/flutter-workflow/references/guardrails/` MUST / MUST NOT.
- Any migration touching more than one layer or more than ~20 files. A whole-tree folder move is not the default upgrade path — see Stay vs Strangler in `sop/project-structure.md`.
- Adding an **architectural** dependency (one that will be imported from more than one layer).

## Rules

- Reuse an existing canonical ADR directory (such as `docs/adr/`) and link its records in this index. Do not duplicate decisions or restart existing numbering. If none exists, use this directory.
- One decision per ADR. Numbered `NNNN-kebab-title.md`.
- Status is one of `Proposed`, `Accepted`, `Deprecated`, `Superseded by NNNN`.
- **Never invent history.** If the original reasoning is not recoverable from the repository, write `Reason: Not determinable from repository evidence.` and record only what the code demonstrates.
- ADRs are immutable once Accepted; to change a decision, write a new ADR that supersedes it.
- Every project-specific override in `docs/project/flutter/project-rules.md` must cite an ADR.

## Index

| ADR | Title | Status | Role |
|-----|-------|--------|------|
| TEMPLATE | — | — | Use for every new decision |
| _(none yet)_ | Add one row per ADR this project writes, starting at ADR-0001 (orientation) | | |

Example ADRs from the reference snapshot (L3 layer-first / Bloc / get_it / auto_route) live in [`../../references/profiles/reference/adr`](../../references/profiles/reference/adr). They are **examples only**, never active decisions, and their numbers do not collide with this folder.

Greenfield: run `checklists/greenfield-kickoff.md`, then write ADRs from `TEMPLATE.md` after filling `docs/project/flutter/README.md`. Do not copy the reference examples unless this app chose the same stack **and** you rewrite them for this app.
