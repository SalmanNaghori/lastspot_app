# Project profile (active)

This folder is the **only** project-specific brain the agent should load by default.

| Mode | What to do |
|------|------------|
| **Greenfield** (new / clean app) | Run [`../../references/checklists/greenfield-kickoff.md`](../../references/checklists/greenfield-kickoff.md) section 1. Ask **orientation first**. Fill the stub files below. Write ADRs. Do **not** load `profiles/reference/`. Do not create `lib/` files until orientation is answered. |
| **Existing app** | Run the audit in `sop/architecture.md`, detect the tree, then kickoff section 2 (**Stay** vs **Strangler**). Do not bulk-migrate. Do not copy class names from `profiles/reference/` unless using it only as an audit-shape example. |

## Required files

| File | Status |
|------|--------|
| `README.md` (this file) | Fill architecture level + orientation |
| `project-rules.md` | Fill overrides + open decisions |
| `architecture-map.md` | Sketch real layout + one vertical slice |
| `audit-report.md` | Optional on day 1; required once code exists |
| `dependency-inventory.md` | Fill from `pubspec.yaml` |
| `remediation-backlog.md` | Empty until audit finds debt |
| `features.md` | Greenfield: empty until the first feature. Brownfield: initialised from existing routes/folders during the audit (DOC-7) |

Root living docs (outside `.agents/skills/flutter-workflow/references/`, from `../templates`): `CHANGELOG.md`, `CONTRIBUTING.md`. Greenfield creates them at kickoff; brownfield keeps existing ones and initialises missing ones from repository evidence (DOC-7). Every change maintains them (DOC-1, DOC-2, DOC-6).

## This project (fill in)

- **App name / package:** `_TBD_`
- **Architecture level:** L1 / L2 / L3 / L4 — `_TBD_`
- **Orientation:** `_TBD_` — Feature First (recommended for new L2+) / Layer First / mixed (Strangler). ND-0: **ask**, do not invent. Record in ADR-0001.
- **Legacy root (brownfield):** `_TBD_` or n/a (e.g. `lib/layers/`)
- **New-feature root (Strangler only):** `_TBD_` or n/a (`lib/features/`)
- **State:** `_TBD_` (one paradigm; ADR required)
- **DI:** `_TBD_` (ADR required)
- **Routing:** `_TBD_` (ADR required)
- **HTTP:** `_TBD_` (ADR required)
- **Storage:** `_TBD_` (ADR required)
- **Serializer / result type:** `_TBD_` (ND-7, ND-8)
- **Strings / locales:** `_TBD_` (ND-5)
- **Test stack:** `_TBD_` (ND-9)
- **Logging / crash / analytics:** `_TBD_` (ND-11)
- **Flavors / toolchain pin / CI:** `_TBD_` (ND-10, ND-13, ND-15)
- **Platforms / form factors / themes:** `_TBD_` (ND-16)

Until `_TBD_` fields and ADRs exist, the agent MUST ask before inventing a stack. Orientation is the first greenfield question. Do not copy class names from `profiles/reference/` into a greenfield app. Example ADR-0001 is Layer First only — not the default.
