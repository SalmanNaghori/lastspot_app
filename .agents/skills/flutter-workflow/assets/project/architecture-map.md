# Architecture Map (as implemented)

Describe what **exists**, not the ideal. Replace this stub after the first vertical slice ships.

## 1. Layer / feature layout

Orientation: `_TBD_` (Feature First / Layer First / mixed). See `docs/project/flutter/README.md` + ADR-0001.

```text
lib/
  main.dart
  # _TBD_ — paste the real tree
  # Feature First: features/<name>/{views,widgets,controller,models,services}
  # Layer First: layers/{app,base,core,data,domain,presentation,utils}
```

## 2. Composition root

- Bootstrap: `_TBD_`
- DI / provider registration: `_TBD_`
- Allowed resolution points: `_TBD_`

## 3. Vertical slice (one happy path)

Name: `_TBD_`

```text
UI → state holder → repository → gateway → model
```

List real file paths once they exist.

## 4. Cross-cutting

| Concern | Where |
|---------|-------|
| Auth / session | `_TBD_` |
| Routing / guards | `_TBD_` |
| Errors / Failure | `_TBD_` |
| Logging / crash | `_TBD_` |
| Config / env | `_TBD_` |
| Realtime (if any) | `_TBD_` |
| Local storage / cache | `_TBD_` |
| Analytics | `_TBD_` |
| Push / permissions | `_TBD_` |
| Feature flags / remote config | `_TBD_` |

## 5. Key project types (used by guardrail checks)

| Role | Type / file | Check variable |
|------|-------------|----------------|
| HTTP gateway | `_TBD_` | `$GATEWAY` |
| Call-and-parse helper (REPO-1) | `_TBD_` | — |
| Request value object (NET-4) | `_TBD_` | — |
| Result / failure type (PR-D2) | `_TBD_` | — |
| Storage interface(s) | `_TBD_` | `$STORAGE` |
| Logger | `_TBD_` | `$LOGGER` |
| Container lookup | `_TBD_` | `$LOOKUP` |

DI initialisation order (DI-4): `_TBD_`

## 6. Features

The feature list lives in [`features.md`](../../../../../docs/project/flutter/features.md) (DOC-2). Do not duplicate it here.
