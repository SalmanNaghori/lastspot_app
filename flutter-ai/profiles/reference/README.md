# Reference profile (L3, layer-first)

Snapshot of the audited app that originally informed many SOPs. Stack documented in `adr/0001`–`0008` (kept as **examples**; greenfield projects write their own ADRs).

| File | Purpose |
|------|---------|
| `audit-report.md` | Pattern classification with evidence |
| `architecture-map.md` | Layout + traced flows |
| `project-rules.md` | Overrides for this stack (BaseCubit, `sl<>`, auto_route, …) |
| `dependency-inventory.md` | pubspec classification |
| `remediation-backlog.md` | Unapplied debt proposals |
| `rules-overlay.md` | PROJECT/LEGACY/DECISION lines that used to live in `rules/*.rules` |

Do not apply these class names (`BaseApiService`, `OrbitListCubit`, …) to an unrelated app.
