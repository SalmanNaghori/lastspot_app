# Greenfield and brownfield kickoff

Run **before** creating any `lib/` files or inventing a folder tree. The agent MUST stop and wait for answers. Do not copy example ADR-0001 or `profiles/reference/`.

Detect first:

- **Greenfield:** `lib/` has no app tree yet (`screens/`, `features/`, `layers/` all absent or empty), **or** `project/README.md` Orientation is `_TBD_`.
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
7. **Storage.** as needed (ADR).

After orientation is answered:

- Write **this project's** ADR-0001 from `adr/TEMPLATE.md`. Do not copy example `adr/0001-layer-first-structure.md` unless Layer First was chosen **and** it matches this app.
- Fill `project/README.md` Orientation.
- Fill `project/project-rules.md` PR-A1 + PR-A2 with the matching placement table. Delete the unused placement stub.
- Scaffold **only** that tree.

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
- Shared/core stays where it already lives. Do not duplicate theme, network, or DI.

Never:

- Bulk-move `lib/layers/` → `lib/features/`
- Split one feature across both trees
- Relocate a feature unless it is already being rewritten (dedicated PR, tests in the same change)

Placement rule after kickoff: before creating a file, search which tree **that feature** already occupies; put the file there. Use `lib/features/` only for a feature that does not exist yet (Strangler) or for every new feature (greenfield Feature First).
