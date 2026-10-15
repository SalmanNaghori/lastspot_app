# SOP: Persistence, Caching and Offline

## Purpose

Decide where data lives on the device, how long it stays valid, how it survives schema changes, and what the app does without a network.

## Scope

Key-value storage, structured local DB, files, secure storage (pointer to `security.md`), cache policy, offline reads, offline write queues, migrations, logout cleanup. Guardrails: `../guardrails/persistence.md` (STORE-*), SEC-6, SEC-8, SEC-9, PERF-6. Decision: ND-6 (storage).

## Principles

1. Pick the **smallest** storage that fits; one package per capability.
2. Every cached thing has a source of truth and a staleness rule.
3. Schemas are versioned from day one.

## Standard

### Choosing storage (ND-6 — record in an ADR)

| Need | Typical choice | Notes |
|------|----------------|-------|
| Small preferences, flags | `shared_preferences` (async API) | no secrets |
| Tokens, keys | `flutter_secure_storage` | SEC-6 |
| Structured / queryable data, relations | `drift` (SQLite) or another DB recorded in the ADR | migrations built in |
| Document/blob cache, simple objects | `hive_ce` / `isar` / files | check maintenance status (DEP-*) before adopting |
| Large files / media | app documents/cache dir via `path_provider` | track size; clear cache dir on logout |

### Layering (UNIVERSAL, HIGH)

- `XLocalDataSource` (data layer) wraps the package; the repository combines remote + local and is the only thing state holders see.
- Box/table/key names are constants (STORE-7). Adapters/type ids are registered once at bootstrap.

### Cache policy (UNIVERSAL)

Declare per cached resource (in code doc or `architecture-map.md`):

| Field | Example |
|-------|---------|
| Source of truth | server |
| Strategy | stale-while-revalidate / cache-first / network-first |
| Max age | 10 min |
| Bound | last 200 messages per chat |
| Invalidation | on logout, on push `orders_updated`, on pull-to-refresh |

The UI shows cached data immediately with a `syncing`/refresh indicator rather than a blocking loader where the strategy allows.

### Offline (UNIVERSAL when the app supports offline)

- Reads: serve cache, show an offline banner and the cached-at time where it matters.
- Writes: an outbox (persistent queue) with client-generated ids/idempotency keys, exponential backoff, and a user-visible permanent-failure state. Conflicts resolved by the rule recorded in the ADR (server wins / last-write-wins / merge).
- Connectivity is a hint, not truth — a request can still fail when "online".

### Migrations (UNIVERSAL, HIGH)

- Schema version constant per store. Every persisted model change ships a migration step (drift `MigrationStrategy`, Hive adapter field defaults + new type ids, never reused ids).
- Cache-only data may be wiped instead of migrated — explicitly, with a comment and a version bump.
- Migrations get a unit test with a fixture of the previous schema when the data is user-generated.

### Cleanup (UNIVERSAL)

- Logout/account deletion clears every user-scoped store, the outbox, media caches and in-memory caches (SEC-8, STORE-6).

## Recommended implementation

- One `StorageModule` in DI that opens stores in order and exposes data sources; heavy stores open lazily after first frame (PERF-10).
- A `clearUserData()` on each local data source, called by one `SessionService.logout()`.

## Anti-patterns

- `Hive.box('x')` / `SharedPreferences.getInstance()` called from widgets or state holders.
- Reusing a Hive `typeId` or deleting a field without a default.
- Infinite in-memory maps used as caches.

## Exceptions

Throwaway prototypes (L1) may use `shared_preferences` directly from a single service class.
