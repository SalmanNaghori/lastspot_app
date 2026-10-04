# Project-Specific Rules (greenfield stub)

Fill this file before the first feature. Until then, treat every `_TBD_` as blocking.

These rules may override universal RECOMMENDED/OPTIONAL items. They never override a universal MUST/MUST NOT without `checklists/exception-request.md` + an ADR.

## A. Structure

- PR-A1. Orientation: `_TBD_`. Options: Feature First (recommended for new L2+) / Layer First / mixed (Strangler). Record in ADR-0001. **ND-0: ask — do not invent.**
- PR-A2. New code placement: keep **one** table below after kickoff. Keep **both** only when Strangler is chosen.
- PR-A3. New directories: `snake_case`.
- PR-A4. Brownfield map (Strangler only): legacy root `_TBD_`; new-feature root `lib/features/`; feature→tree: all legacy until listed / `_TBD_`.
- PR-A5. One orientation per feature. Never split a feature across trees. Never bulk-move.

### PR-A2 Feature First (keep if chosen or if Strangler)

| Artifact | Path |
|----------|------|
| Screen | `lib/features/<feature>/views/<feature>_screen.dart` |
| Widgets | `lib/features/<feature>/widgets/` |
| Controller | `lib/features/<feature>/controller/` |
| Models | `lib/features/<feature>/models/` |
| Service / repository | `lib/features/<feature>/services/` |
| Shared widget | `lib/shared/widgets/` |
| Tests | `test/features/<feature>/...` |

### PR-A2 Layer First (keep if chosen, or as the legacy table under Strangler)

| Artifact | Path |
|----------|------|
| Screen | `lib/layers/presentation/ui/<feature>/<feature>_screen.dart` |
| Widgets | `lib/layers/presentation/ui/<feature>/widgets/` |
| Cubit | `lib/layers/presentation/cubit/<feature>_cubit/` |
| Models | `lib/layers/data/models/...` |
| Repository interface | `lib/layers/domain/repositories/` |
| Repository impl | `lib/layers/data/repositoryImpl/` |
| Tests | `test/` mirroring `lib/layers/` |

After kickoff: delete the unused table unless Orientation is mixed.

## B. Dependency injection

- PR-B1. Container / approach: `_TBD_` (ADR).
- PR-B2. Resolution only at composition roots (bootstrap, route/provider wrappers). Never inside widgets' business paths, repositories, or state-holder bodies.

## C. State management

- PR-C1. Single feature-level paradigm: `_TBD_` (ADR). No second paradigm.
- PR-C2. Async shape: one shared status model (or sealed states) — no `isLoading`/`isSuccess`/`hasError` flag soup.
- PR-C3. Side effects (nav, toast, dialog, blocking loader) only in listeners / UI edge — not in state holders.

## D. Networking and data

- PR-D1. Single HTTP gateway abstraction: `_TBD_`.
- PR-D2. Repositories return a single failure-success boundary type: `_TBD_` (e.g. `Either<Failure, T>` or equivalent).
- PR-D3. Endpoints centralised; models: `_TBD_` serializer.

## E. Routing

- PR-E1. Typed routes only: `_TBD_` package/approach (ADR). No string route names for screens.

## F. UI

- PR-F1. Design tokens only (colors, spacing, typography). No raw `Colors.*` / magic font sizes in features.
- PR-F2. User-facing strings: `_TBD_` (`AppString` / l10n).
- PR-F3. Every async screen: loading / error / empty / no-internet.

## G. Security

- PR-G1. Secrets via dart-define / env files → typed config. Never in source.
- PR-G2. Tokens not in URLs or logs. Session storage behind one abstraction.

## H. Testing

- PR-H1. Every new state holder + repository ships tests with the chosen test stack: `_TBD_`.

## I. Open decisions

| ID | Decision | Options | Default until decided |
|----|----------|---------|-----------------------|
| ND-0 | Orientation | Feature First / Layer First / mixed (Strangler, existing apps only) | **ask** — do not invent. Greenfield: Feature First recommended for L2+. Existing app: Stay vs Strangler (`checklists/greenfield-kickoff.md`) |
| ND-1 | State paradigm | Riverpod / flutter_bloc / other | **ask** — do not invent |
| ND-2 | DI | riverpod overrides / get_it / constructor-only | **ask** |
| ND-3 | Routing | go_router / auto_route / other | **ask** |
| ND-4 | HTTP client | dio / http + gateway | **ask** |
| ND-5 | Localization | l10n / constants class | **ask** |
