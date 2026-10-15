# New feature checklist

Use for every new feature (agent or human). Long form: `sop/feature-architecture.md`.

## Before code

- [ ] Requirement restated in one paragraph; acceptance criteria listed.
- [ ] Row added to `docs/project/flutter/features.md` with status `planned` (DOC-2).
- [ ] Orientation and placement known (`docs/project/flutter/project-rules.md` PR-A1/PR-A2); feature lives in one tree (ARCH-7).
- [ ] Searched for reusable repositories, endpoints, models, shared widgets, events (AI-3). Search terms recorded.
- [ ] API contract known (endpoint, request, response, errors). If not available yet: agreed fake (fixture JSON + DI override at the composition root), never invented backend behaviour (AI-9).
- [ ] Design available for all states: loading, empty, error, no-internet, populated (UI-6); light/dark; large text.
- [ ] Strings listed for the ARB / constants file (I18N-1). Analytics events from the tracking plan (OBS-5). Feature flag needed? owner + removal date (REL-6).
- [ ] Permissions / push / storage needs identified (PLAT-*, STORE-*). New dependency? DEP-1 block; ADR if architectural.
- [ ] Material architectural choices resolved within the user's authorization; reuse confirmed answers. File count alone does not require another approval.

## Build order

Use this as dependency order for authorized implementation. When TDD is requested,
write and run the failing test before each implementation step, then refactor;
the test row below checks coverage, not a requirement to write tests last.
Planning-only requests do not create feature records or application files unless
saving those artifacts was requested.

1. [ ] Models (PR-D3 serializer) + endpoint constants.
2. [ ] Repository interface + impl returning the PR-D2 result type; local data source if cached.
3. [ ] State holder + immutable state with the shared status model.
4. [ ] DI registration with the right lifetime (DI-3).
5. [ ] Typed route (+ guard), screen, widgets (list items are widget classes), listeners for side effects.
6. [ ] Tests: state holder, repository, new shared widgets (TEST-1..3); integration test if it is a critical journey (TEST-20).

## Before PR

- [ ] `dart format`, `flutter analyze`, tests green; codegen regenerated.
- [ ] Accessibility pass (labels, 48dp, 1.3× text, contrast) and dark mode.
- [ ] `checklists/architecture-compliance.md` matrix + `checklists/definition-of-done.md`.
- [ ] Living docs: CHANGELOG `[Unreleased]`; `docs/project/flutter/features.md` row completed (status, routes, state holder, repository, flag, since); `CONTRIBUTING.md` if setup changed; ADR if any (DOC-1..3, DOC-6).
