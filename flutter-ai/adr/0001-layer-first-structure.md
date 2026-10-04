> **EXAMPLE ADR** (reference profile). Greenfield: write your own from TEMPLATE.md; do not copy these decisions unless this is that stack.

# ADR-0001: Layer-first project structure

- **Status:** Accepted (documents the existing state)
- **Date:** 2026-09-08 (reconstructed)
- **Decision owner:** Not determinable from repository evidence
- **Classification:** PROJECT-SPECIFIC

## Context

This is a ~1160-file Flutter app with chat, feeds, connections, notifications, background location and realtime sockets. The code is organised by **technical layer** under `lib/layers/` rather than by feature.

## Problem

Should the project keep its layer-first layout or migrate to the universal recommendation (feature-first at Level 2+)?

## Decision

Keep layer-first. All new code follows the existing placement (`project/project-rules.md` PR-A2). Feature-first migration is not undertaken without a dedicated ADR and PR series.

## Evidence

- `lib/layers/{app,base,core,data,domain,presentation,utils}` with features spread across `domain/repositories`, `data/repositoryImpl`, `presentation/cubit/<x>Cubit`, `presentation/ui/<x>`.
- 20 abstract/impl repository pairs and ~82 blocs/cubits already follow this placement.
- Reason for the original choice: **Not determinable from repository evidence.**

## Alternatives considered

| Alternative | Why not |
|-------------|---------|
| Migrate to `lib/features/<feature>/{data,domain,presentation}` | Touches >1000 files, no tests to protect the move, high merge-conflict cost across 9 active branches. |
| Hybrid (new features feature-first, old layer-first) | Two mental models in one tree; violates "one way to do it". |

## Consequences

- Positive: zero migration cost; existing team knowledge preserved; DI modules already mirror layers.
- Negative: feature boundaries are implicit; deleting a feature requires touching 5+ folders; barrel files (`exports.dart`) hide cross-layer imports.
- Rules: `sop/project-structure.md` documents layer-first as an accepted Level-3 variant; `guardrails/architecture.md` layer-direction rules still apply.

## Migration

None.

## Review trigger

Revisit if (a) a test suite exists covering blocs/repos, or (b) the app is split into packages (Level 4), at which point feature packages become the natural boundary.
