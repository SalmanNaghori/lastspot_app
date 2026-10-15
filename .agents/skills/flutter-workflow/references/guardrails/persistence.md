# Guardrails: Persistence, Cache and Offline

SOP: `sop/persistence-and-offline.md`. Security of stored secrets: `security.md` SEC-6, SEC-8, SEC-9.

**STORE-1** — Local storage (key-value, DB, files) MUST be accessed only through the project's storage abstractions (data sources) registered at composition roots; widgets and state holders MUST NOT open boxes/tables/files directly.
Check: `rg -n "$STORAGE|openBox|openDatabase|getApplicationDocumentsDirectory" $PRES` → must be empty.

**STORE-2** — Exactly one key-value store and one structured store per project (recorded in the storage ADR); a second package for the same capability MUST NOT be added (DEP-2).

**STORE-3** — Persisted schemas MUST be versioned. Changing a persisted model (fields, adapter type id, table columns) MUST ship a migration or an explicit, documented wipe-and-refetch for cache-only data in the same PR.
Check: diff touching `@HiveType`/`@DriftDatabase`/`@Entity`/table classes → migration or schema-version bump present.

**STORE-4** — Every cache MUST declare its policy: source of truth, max age / staleness rule, size bound, and eviction. Unbounded caches MUST NOT be added (PERF-6).

**STORE-5** — Offline write queues MUST persist across restarts, MUST be idempotent (client-generated id / idempotency key), MUST retry with backoff, and MUST surface permanent failures to the user.

**STORE-6** — Logout and account deletion MUST clear user-scoped stores, queues and caches (SEC-8); multi-account apps MUST namespace stores per user.

**STORE-7** — Storage keys and box/table names MUST be constants in one place; magic strings MUST NOT be used at call sites.
Check: `rg -n "openBox\('|\.get\('|\.put\('" lib` → only in the storage module.
