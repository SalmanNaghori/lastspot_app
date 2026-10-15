# Reference profile (L3, layer-first)

Optional L3 example profile. Stack documented in [`docs/adr/`](adr) 0001–0008 (kept as **examples**; projects write their own ADRs in the top-level `docs/adr/`). ADR, `ND-*` and `R*` numbers in this folder are local to the snapshot and do not refer to the active project's ids.

| File | Purpose |
|------|---------|
| `audit-report.md` | Pattern classification with evidence |
| `architecture-map.md` | Layout + traced flows |
| `project-rules.md` | Overrides for this stack (BaseCubit, `sl<>`, auto_route, …) |
| `dependency-inventory.md` | pubspec classification |
| `remediation-backlog.md` | Unapplied debt proposals |
| `rules-overlay.md` | PROJECT/LEGACY/DECISION lines and example evidence and status notes |
| `docs/adr/` | Example ADRs 0001–0008 for this stack |

Do not apply these class names (`BaseApiService`, `OrbitListCubit`, …) to an unrelated app.
