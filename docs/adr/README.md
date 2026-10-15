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

## Index — LastSpot

| ADR | Title | Status | Scope |
|-----|-------|--------|-------|
| [TEMPLATE](TEMPLATE.md) | Standard ADR Template | — | Use for any new architectural decisions |
| [0001](0001-feature-first-clean-architecture.md) | Feature-First Clean Architecture Structure (Stay) | Accepted | Orientation & Directory Tree |
| [0002](0002-get-it-service-locator.md) | Dependency Injection via GetIt Service Locator | Accepted | DI & Composition Root |
| [0003](0003-flutter-bloc-state-management.md) | State Management with flutter_bloc and ValueNotifier | Accepted | State & Ephemeral UI State |
| [0004](0004-go-router-declarative-routing.md) | Declarative Routing with go_router | Accepted | Navigation & Auth Redirection |
| [0005](0005-supabase-gateway-and-result-boundary.md) | Supabase Gateway and Result Boundary Pattern | Accepted | Backend, DataSources & BaseRepository |
| [0006](0006-shared-preferences-local-storage.md) | Local Storage with SharedPreferences | Accepted | Preferences & Local Persistence |
| [0007](0007-supabase-realtime-messaging.md) | Realtime Messaging via Supabase Realtime Channels | Accepted | Realtime Chat & Participation |
| [0008](0008-compile-time-environment-config.md) | Compile-Time Environment Configuration and AppConstants | Accepted | Environment, Secrets & Constants |

