# Adopt `flutter-ai/` in another project or AI account

## A. Greenfield (recommended)

1. Copy this whole folder into the repo root (or `docs/flutter-ai/`).
2. Keep `project/` stubs; **omit `profiles/` from AI context**.
3. Optionally delete `profiles/` and example ADRs `adr/0001`–`0008` if you want zero leakage (keep `adr/TEMPLATE.md` + `adr/README.md`). Example ADR-0001 is Layer First only — not the default for a new app.
4. Wire the agent — copy [`.cursor/rules/flutter-ai.mdc`](.cursor/rules/flutter-ai.mdc) or point Claude/Cursor at `agent.md`.
5. Run [`checklists/greenfield-kickoff.md`](checklists/greenfield-kickoff.md) **before** filling `project/` or creating `lib/` files.
   - Ask **orientation first**: Feature First (recommended for new L2+) vs Layer First.
   - Then: level, state, DI, routing, HTTP, storage.
6. Write **this project's** ADR-0001 from `adr/TEMPLATE.md`. Fill `project/README.md` + `project/project-rules.md` PR-A1/PR-A2 with the matching placement table. Delete the unused stub.
7. Fill remaining `project/project-rules.md` `_TBD_` fields and ADRs for state, DI, routing, HTTP, storage, config.
8. Build the first thin feature per `sop/feature-architecture.md` in the chosen tree only.

Until orientation and steps 6–7 are done, the agent must **ask** — never invent a tree or packages.

## B. Existing app (not greenfield)

1. Copy `flutter-ai/` in.
2. Replace `project/` stubs by auditing per `sop/architecture.md` → "Auditing an existing project".
3. Detect the current tree (`lib/layers/`, `lib/features/`, or other). Run kickoff **section 2** — ask **Stay** vs **Strangler** once. Do not run the greenfield Feature First vs Layer First ask. Do not bulk-move folders.
4. Write ADRs for choices the code already made (do not invent history). Stay: one tree. Strangler: `Orientation: mixed`, name legacy root + new-feature root, keep a feature→tree map (or "all legacy until listed").
5. Soften or delete example ADRs `0001`–`0008` if they contradict this app. Do not copy Feature First over an existing `lib/layers/` tree.
6. Wire `agent.md` as in A.4.

Optional: read `profiles/reference/` for how a dense audit looks — then write *your* files, don't copy class names.

## C. What is universal vs not

| Load always | Load only if active project | Optional examples |
|-------------|-----------------------------|-------------------|
| `agent.md`, `sop/`, `guardrails/`, `rules/` (without inventing missing types), `checklists/` | `project/*` | `profiles/`, example `adr/0001`–`0008` |

## D. Strip checklist (other AI account)

- [ ] Kickoff run: greenfield orientation **or** brownfield Stay/Strangler recorded
- [ ] `project/*.md` have no `_TBD_` left (or agent is told to ask)
- [ ] ADRs match *this* pubspec (example ADR-0001 used only if this app is Layer First)
- [ ] `profiles/` not in always-on rules
- [ ] Cursor/Claude entry → `agent.md`
- [ ] No references to classes that are not in *this* `lib/`
- [ ] No bulk `lib/layers` → `lib/features` migration planned as "adopting the SOP"
