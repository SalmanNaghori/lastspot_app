# ADR-0005: Supabase Gateway and Result Boundary Pattern

- **Status:** Accepted
- **Date:** 2026-10-14
- **Decision owner:** Salman Naghori / Tech Lead
- **Classification:** PROJECT-SPECIFIC

## Context

The backend infrastructure utilizes Supabase (PostgreSQL, PostgREST, Auth, Storage, Edge Functions, and Realtime). Client writes for sensitive operations (such as joining a match, decrementing open spots, session activation) must be strictly atomic and secure against race conditions.

## Problem

How should data queries and backend operations be isolated from presentation to guarantee security, error boundaries, and future API flexibility?

## Decision

1. **Isolation:** The UI layer NEVER calls Supabase directly. All queries pass through:
   `UI → BLoC/Cubit → Use Case → Repository Interface → Repository Implementation → Remote DataSource → Supabase Client`
2. **Error Boundary:** Repositories extend `BaseRepository` in `lib/core/network/base/base_repository.dart` and return a sealed `Result<T, Exception>` (`Success` or `Failure`).
3. **Atomic Operations:** Sensitive operations (joining activities, session verification, post expiry) execute via Supabase RPCs/Edge Functions, never direct client writes.
4. **Data Transfer Models:** JSON mapping and Supabase row parsing is confined to `*Model` classes in `data/models/` implementing `*Entity` classes from `domain/entities/`.

## Evidence

- `lib/core/network/base/base_repository.dart`
- `lib/core/utils/result.dart`
- `lib/features/spot/data/datasources/spot_remote_datasource.dart`
- `lib/features/spot/data/repositories/spot_repository_impl.dart`
- GEMINI.md Rule 9 & `lastspot_master_spec.md`.

## Alternatives Considered

| Alternative | Why Not |
|-------------|---------|
| Dio + Custom REST | Current backend is Supabase; direct REST would bypass Supabase Auth, RLS, and Realtime advantages. |
| Throwing Uncaught Exceptions | Replaced by `Result<T, Exception>` boundary to guarantee safe error handling in BLoCs. |

## Consequences

- **Positive:** Repositories can easily swap Supabase for REST/GraphQL in the future without changing domain use cases or UI.
- **Negative / Costs:** Requires mapping layer between Supabase responses, models, and domain entities.
- **Rules Enforced:** PR-D1, PR-D2, PR-D3, PR-D4.
