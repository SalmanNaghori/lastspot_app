# Guardrails

Guardrails answer **"What must never be violated?"** They are the enforceable boundary of the standard. Each guardrail is a single testable statement using RFC-2119 keywords:

| Keyword | Meaning | Violation handling |
|---------|---------|--------------------|
| **MUST / MUST NOT** | Absolute. No PR merges with a violation unless an approved exception (`checklists/exception-request.md`) and ADR exist. | Block |
| **SHOULD / SHOULD NOT** | Strong default. Deviation requires a stated reason in the PR. | Reviewer decides |
| **MAY** | Permitted option. | — |

Every guardrail carries an ID (`ARCH-1`, `DEP-3`, ...) used in compliance reports and code review comments, and where possible a **Check** — an `rg` pattern or analyzer rule that detects violations mechanically.

## Files

| File | Domain | IDs |
|------|--------|-----|
| [architecture.md](architecture.md) | Layers, DI, structure | `ARCH-*`, `DI-*`, `STRUCT-*` |
| [dependencies.md](dependencies.md) | Packages | `DEP-*` |
| [state-management.md](state-management.md) | Bloc/Cubit, state shape | `STATE-*` |
| [networking.md](networking.md) | HTTP, gateway, errors, realtime | `NET-*`, `ERR-*` |
| [routing.md](routing.md) | Navigation, deep links | `ROUTE-*` |
| [ui.md](ui.md) | Screens, widgets, tokens | `UI-*` |
| [testing.md](testing.md) | Required tests | `TEST-*` |
| [performance.md](performance.md) | Rebuilds, lists, leaks | `PERF-*`, `ASYNC-*` |
| [security.md](security.md) | Secrets, tokens, logs, build | `SEC-*` |
| [ai-development.md](ai-development.md) | Rules for AI coding agents | `AI-*` |

## Relationship to SOP and rules

```text
SOP        explains the why and the how          (long form)
Guardrail  states the boundary + how to check    (this folder)
Rule       compresses both for AI agents         (rules/*.rules)
```

Every guardrail maps to a SOP section and to at least one line in `rules/`. The cross-reference is verified in `checklists/architecture-compliance.md`.

## Project overrides

A project MAY relax a SHOULD via `project/project-rules.md`. A project MUST NOT relax a MUST without an exception record and ADR. Approved deviations for *this* app are listed in `project/project-rules.md`. Optional historical examples: `profiles/reference/project-rules.md`.
