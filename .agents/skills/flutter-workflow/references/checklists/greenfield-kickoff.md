# Greenfield and brownfield kickoff

Run **before** creating any `lib/` files or inventing a folder tree. The agent MUST stop and wait for answers. Do not copy `profiles/reference/` or its example ADRs.

Detect first:

- **Greenfield:** no real application code exists yet. An unfilled Orientation does not imply greenfield. Inspect code, not just directory names; an ambiguous or untouched starter needs a context question.
- **Brownfield:** `lib/` already has a real tree. Do **not** run section 1. Run section 2.

## 1. Greenfield — ask in this order

Stop. Ask. Do not scaffold until answered.

1. **Orientation (blocking, ND-0).** Feature First (recommended for new L2+) vs Layer First.
   - Feature First → `lib/features/<name>/{views,widgets,controller,models,services}` plus `lib/core/` and `lib/shared/`.
   - Layer First → `lib/layers/{app,base,core,data,domain,presentation,utils}` (or the project's documented layer roots).
2. **Architecture level.** L1 / L2 / L3 / L4.
3. **State paradigm.** Riverpod / flutter_bloc / other (ND-1).
4. **DI.** Riverpod overrides / get_it / constructor-only (ND-2).
5. **Routing.** go_router / auto_route / other (ND-3).
6. **HTTP.** dio / http + gateway (ND-4).
7. **Storage.** key-value / secure / structured (ND-6).
8. **Models and errors.** Serializer (ND-7) and repository result type (ND-8).
9. **Strings.** gen-l10n `.arb` vs constants class; supported locales; RTL (ND-5).
10. **Platforms and UI scope.** Android / iOS / web / desktop; tablets; dark mode; orientation (ND-16).
11. **Tests.** Test stack (ND-9) and the critical journeys that need integration tests (PR-H2).
12. **Observability.** Logger, crash reporter, analytics, consent (ND-11).
13. **Delivery.** Flavors (ND-10), toolchain pin (ND-13), CI/CD provider (ND-15), branching (ND-14), lint set (ND-12).

Questions 2–13 MAY be asked together in one message after orientation is answered. Offer the documented defaults (`docs/project/flutter/project-rules.md` §I) so the user can accept them in one reply. Never assume an answer that has no default.

Orientation chooses grouping, not architecture depth. For L1, Feature First may
group the few required screens/services inside feature folders; Layer First may
use simple `screens/`, `widgets/`, and `services/` roots. Do not create unused
layers or require a container, router, repository, or serializer package because
of the orientation examples. Finalize the placement table after level and
capabilities are answered; “not needed” is valid for an absent capability.

After orientation is answered:

- Write **this project's** ADR-0001 from `docs/adr/TEMPLATE.md`. Do not copy `profiles/reference/adr/0001-layer-first-structure.md` unless Layer First was chosen **and** you rewrite it for this app.
- Fill `docs/project/flutter/README.md` Orientation.
- Fill `docs/project/flutter/project-rules.md` PR-A1 + PR-A2 with the matching placement table. Delete the unused placement stub.
- Record orientation-derived PR-A6 paths as planned; fill package-specific symbols
  only after their choices and real implementations exist. Never run searches
  with empty or `_TBD_` variables. Mark absent capabilities N/A.
- After questions 2–13: write one ADR per architectural choice (state, DI, routing, HTTP, storage, serializer/result type, l10n if multi-language), fill confirmed choices in `docs/project/flutter/*.md`; leave unobserved facts explicitly unknown and defer architecture-map symbols until implementation exists, add the rows to `docs/adr/README.md`.
- RepoSeed already installed the selected root entrypoints. Preserve their managed blocks; do not overwrite them from templates. Fill the seeded living docs (DOC-7), preserving the root changelog format and existing CONTRIBUTING content. Leave `docs/project/flutter/features.md` empty until the first feature is planned. See `REPOSEED.md`.
- Scaffold **only** that tree, and only when the user says so.

## 2. Brownfield — ask Stay vs Strangler once

Do not ask Feature First vs Layer First as if the tree were empty. Detect the current layout (`lib/layers/`, `lib/features/`, or something else).

Ask **once**:

| Choice | Meaning |
|--------|---------|
| **Stay** (default if the team does not want two trees) | Keep the current layout forever. New files go next to siblings. Do not introduce `lib/features/` if it does not already exist. |
| **Strangler** | Brand-new features go under `lib/features/<name>/{views,widgets,controller,models,services}`. Existing features keep receiving files in the legacy tree. |

After the answer:

- Write an ADR (orientation). Stay: record the existing tree as the only tree. Strangler: `Orientation: mixed` — name **legacy root** and **new-feature root**.
- Fill PR-A1 / PR-A2. Strangler keeps **both** placement tables and a feature→tree map (or "all legacy until listed").
- Fill PR-A6 (check variables) for the tree(s) that exist — Strangler lists both.
- For questions 3–13 of section 1: **detect** the answer from `pubspec.yaml` and the code; record what exists (ADR "Reason: Not determinable from repository evidence" where needed). Ask only where the code shows two competing choices or nothing at all.
- Follow `checklists/brownfield-audit.md` for the audit itself.
- Shared/core stays where it already lives. Do not duplicate theme, network, or DI.

Never:

- Bulk-move `lib/layers/` → `lib/features/`
- Split one feature across both trees
- Relocate a feature unless it is already being rewritten (dedicated PR, tests in the same change)

Placement rule after kickoff: before creating a file, search which tree **that feature** already occupies; put the file there. Use `lib/features/` only for a feature that does not exist yet (Strangler) or for every new feature (greenfield Feature First).
