# ADR-NNNN: <Title>

- **Status:** Proposed | Accepted | Deprecated | Superseded by ADR-NNNN
- **Date:** YYYY-MM-DD
- **Decision owner:** <name / role>
- **Classification:** UNIVERSAL | PROJECT-SPECIFIC | RECOMMENDED | OPTIONAL | LEGACY

## Context

What situation forced a decision? Which constraints (team, timeline, platform, backend contract) applied?

## Problem

The specific question being answered. One sentence if possible.

## Decision

What we do. Imperative, concrete, with the file paths / package names involved.

### Orientation fill-in (when this ADR is ADR-0001 for structure)

Pick one. Greenfield: Feature First (recommended for L2+) or Layer First. Existing app: Stay (keep current tree) or Strangler (`Orientation: mixed`).

- **Feature First:** `lib/features/<name>/{views,widgets,controller,models,services}` + `lib/core/` + `lib/shared/`.
- **Layer First:** `lib/layers/{app,base,core,data,domain,presentation,utils}` (or this app's layer roots).
- **Mixed (Strangler):** legacy root = `_`; new-feature root = `lib/features/`; feature→tree map = all legacy until listed / `_`. One orientation per feature. No bulk move.

Do not copy `adr/0001-layer-first-structure.md` unless Layer First was chosen for *this* app.

## Evidence (for decisions reconstructed from code)

Files and patterns that demonstrate the decision is in force. If reconstructing, state:
`Reason: Not determinable from repository evidence.` where the original rationale is unknown.

## Alternatives considered

| Alternative | Why not |
|-------------|---------|
| | |

## Consequences

- Positive:
- Negative / costs:
- Rules this creates or changes (link to `sop/`, `guardrails/`, `rules/`, `project/project-rules.md`):

## Migration

Steps if this changes existing code. "None" if greenfield.

## Review trigger

Under what conditions should this be revisited? (e.g. team size, feature count, package deprecation)
