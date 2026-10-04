# Architectural Decision Records

An ADR records one significant, hard-to-reverse decision: what was decided, why, what else was considered, and what it costs.

## When an ADR is required

- Choosing or replacing: state management, routing, DI, HTTP client, persistence, serialization, realtime transport, authentication flow, **project structure orientation** (Feature First, Layer First, or brownfield mixed/Strangler).
- Any approved exception to a `guardrails/` MUST / MUST NOT.
- Any migration touching more than one layer or more than ~20 files. A whole-tree folder move is not the default upgrade path — see Stay vs Strangler in `sop/project-structure.md`.
- Adding an **architectural** dependency (one that will be imported from more than one layer).

## Rules

- One decision per ADR. Numbered `NNNN-kebab-title.md`.
- Status is one of `Proposed`, `Accepted`, `Deprecated`, `Superseded by NNNN`.
- **Never invent history.** If the original reasoning is not recoverable from the repository, write `Reason: Not determinable from repository evidence.` and record only what the code demonstrates.
- ADRs are immutable once Accepted; to change a decision, write a new ADR that supersedes it.
- Every project-specific override in `project/project-rules.md` must cite an ADR.

## Index

| ADR | Title | Status | Role |
|-----|-------|--------|------|
| TEMPLATE | — | — | Use for every new decision |
| 0001–0008 | Example L3 layer-first / Bloc / get_it / auto_route set | Accepted (historical) | **Examples only** — not the greenfield default. Example ADR-0001 is Layer First. Greenfield writes a **new** ADR-0001 from TEMPLATE for Feature First, Layer First, or mixed (Strangler). Delete or supersede 0001–0008 if `project/` chooses a different stack. |

Greenfield: run `checklists/greenfield-kickoff.md`, then write ADRs from `TEMPLATE.md` after filling `project/README.md`. Do not treat 0001–0008 as mandatory. Do not copy example ADR-0001 unless this app chose Layer First **and** it matches.
