# Adopt the Flutter workflow in a project or AI IDE

**RepoSeed installations:** selected entrypoints already exist. Preserve their managed blocks and existing app documents; do not copy standalone templates over them. See [REPOSEED.md](REPOSEED.md).

## A. Greenfield (recommended)

1. Select Flutter in RepoSeed to install the complete `flutter-workflow` skill and the selected IDE entrypoints. Read `REPOSEED.md`. The reference files remain inside the skill; active app documents are seeded under `docs/`.
2. Keep `docs/project/flutter/` stubs; **omit `.agents/skills/flutter-workflow/references/profiles/` from AI context**.
3. Keep `.agents/skills/flutter-workflow/references/profiles/` out of default context; RepoSeed manages these optional historical examples and restores missing managed files on sync. `docs/adr/` ships with only `TEMPLATE.md` + `README.md`, so this project's ADR-0001 is free.
4. RepoSeed has already wired the selected agent entrypoints. For standalone adoption only, copy the entry files in [`.agents/skills/flutter-workflow/assets/templates/README.md`](../assets/templates/README.md) to the repo root (`CLAUDE.md`, `AGENTS.md`, [`.cursor/rules/flutter-ai.mdc`](../assets/.cursor/rules/flutter-ai.mdc), `.github/copilot-instructions.md`, `.github/pull_request_template.md`).
5. Run [`checklists/greenfield-kickoff.md`](checklists/greenfield-kickoff.md) **before** filling `docs/project/flutter/` or creating `lib/` files.
   - Ask **orientation first**: Feature First (recommended for new L2+) vs Layer First.
   - Then: level, state, DI, routing, HTTP, storage.
6. Write **this project's** ADR-0001 from `docs/adr/TEMPLATE.md`. Fill `docs/project/flutter/README.md` + `docs/project/flutter/project-rules.md` PR-A1/PR-A2 with the matching placement table. Delete the unused stub.
7. Fill remaining `docs/project/flutter/project-rules.md` `_TBD_` fields and ADRs for state, DI, routing, HTTP, storage, config.
8. Create the root living docs (DOC-7): `CHANGELOG.md` and `CONTRIBUTING.md` from `.agents/skills/flutter-workflow/assets/templates/` (CONTRIBUTING filled from the kickoff answers). `docs/project/flutter/features.md` stays empty until the first feature.
9. Stop after showing the profile. When the user authorizes scaffolding, build the first thin feature per `sop/feature-architecture.md` in the chosen tree only; add its `features.md` row and CHANGELOG entry in the same change.

Until orientation and steps 6–7 are done, the agent must **ask** — never invent a tree or packages.

## B. Existing app (not greenfield)

1. Select Flutter in RepoSeed to install the complete skill and selected IDE entrypoints, preserving existing app documents.
2. Replace `docs/project/flutter/` stubs by auditing per `checklists/brownfield-audit.md` (long form: `sop/architecture.md` → "Auditing an existing project").
3. Detect the current tree (`lib/layers/`, `lib/features/`, or other). Run kickoff **section 2** — ask **Stay** vs **Strangler** once. Do not run the greenfield Feature First vs Layer First ask. Do not bulk-move folders.
4. Write ADRs for choices the code already made (do not invent history). Stay: one tree. Strangler: `Orientation: mixed`, name legacy root + new-feature root, keep a feature→tree map (or "all legacy until listed").
5. Ignore the reference example ADRs (`profiles/reference/adr/`) if they contradict this app. Do not copy Feature First over an existing `lib/layers/` tree.
6. Initialise the living docs from repository evidence (DOC-7, `checklists/brownfield-audit.md` §5): fill `docs/project/flutter/features.md` from the existing routes/feature folders; keep an existing `CHANGELOG.md`/`CONTRIBUTING.md` and add missing sections; create missing ones without inventing history or commands.
7. Wire `agent.md` as in A.4.

Only if the user requests it, read `profiles/reference/` for how a dense audit looks — then write *your* files, don't copy class names.

## C. What is universal vs not

| Load always | Load only if active project | Optional examples |
|-------------|-----------------------------|-------------------|
| `agent.md` and task-relevant SOPs, guardrails, rules and checklists (load progressively) | `docs/project/flutter/*` | `.agents/skills/flutter-workflow/references/profiles/` (incl. `profiles/reference/adr/`) |

## D. Strip checklist (other AI account)

- [ ] Kickoff run: greenfield orientation **or** brownfield Stay/Strangler recorded
- [ ] Task-relevant choices in `docs/project/flutter/*.md` are confirmed; unobserved facts remain explicitly unknown
- [ ] `docs/adr/` contains only this project's ADRs, and they match *this* pubspec
- [ ] `.agents/skills/flutter-workflow/references/profiles/` not in always-on rules
- [ ] Living docs exist: root `CHANGELOG.md`, root `CONTRIBUTING.md`, `docs/project/flutter/features.md` (greenfield: created; brownfield: initialised from evidence)
- [ ] Selected root entrypoints reach `flutter-workflow` / `agent.md`; RepoSeed managed blocks preserved
- [ ] No references to classes that are not in *this* `lib/`
- [ ] No bulk `lib/layers` → `lib/features` migration planned as "adopting the SOP"
