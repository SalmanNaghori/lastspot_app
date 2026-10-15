# ADR-0001: Feature-First Clean Architecture Structure (Stay)

- **Status:** Accepted
- **Date:** 2026-10-14
- **Decision owner:** Salman Naghori / Tech Lead
- **Classification:** PROJECT-SPECIFIC

## Context

LastSpot is a Flutter mobile application built as a social activity discovery and participation platform. The codebase currently comprises 14 feature modules, each partitioned into Clean Architecture layers: data, domain, and presentation. During the brownfield architectural audit, the team evaluated whether to maintain the unified feature-first layout or migrate incrementally.

## Problem

How should the codebase directory tree and feature boundary be governed to maintain scalability and prevent layer pollution?

## Decision

**Stay on the current Feature-First Clean Architecture layout.**

All existing and new features are located under `lib/features/<feature_name>/` containing:
- `data/`: `datasources/`, `models/`, `repositories/`
- `domain/`: `entities/`, `repositories/`, `usecases/`
- `presentation/`: `bloc/`, `pages/`, `widgets/`

Shared and cross-cutting modules live under `lib/core/` (`constants/`, `di/`, `extension/`, `l10n/`, `network/`, `services/`, `theme/`, `utils/`, `widgets/`).

No `lib/layers/` directory exists or will be introduced.

## Evidence

- `lib/features/activities/`, `lib/features/auth/`, `lib/features/chat/`, `lib/features/spot/`, etc. (all 14 features follow this exact three-layer structure).
- Kickoff decision: **Stay** selected.

## Alternatives Considered

| Alternative | Why Not |
|-------------|---------|
| Layer First (`lib/layers/`) | The codebase already has 14 mature feature packages under `lib/features/`. Splitting or reorganizing would cause immense merge friction without architectural benefit. |
| Strangler (Mixed) | Not necessary because there is no legacy layer tree; the entire project already follows a uniform feature-first structure. |

## Consequences

- **Positive:** Feature encapsulation, clear ownership, modular testing, high cohesion.
- **Negative / Costs:** Boilerplate per feature (data, domain, presentation folders).
- **Rules Enforced:** PR-A1, PR-A2, PR-A4.

## Review Trigger

Revisit if the project transitions to a multi-package mono-repo (`melos`).
