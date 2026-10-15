# Project-Specific Rules (greenfield stub)

Fill this file before the first feature. Only unresolved choices needed for the requested task are blocking; preserve unknown evidence explicitly.

These rules may override universal RECOMMENDED/OPTIONAL items. They never override a universal MUST/MUST NOT without `checklists/exception-request.md` + an ADR.

## A. Structure

- PR-A1. Orientation: `_TBD_`. Options: Feature First (recommended for new L2+) / Layer First / mixed (Strangler). Record in ADR-0001. **ND-0: ask — do not invent.**
- PR-A2. New code placement: keep **one** table below after kickoff. Keep **both** only when Strangler is chosen.
- PR-A3. New directories: `snake_case`.
- PR-A4. Brownfield map (Strangler only): legacy root `_TBD_`; new-feature root `lib/features/`; feature→tree: all legacy until listed / `_TBD_`.
- PR-A5. One orientation per feature. Never split a feature across trees. Never bulk-move.
- PR-A6. Check paths and regexes for guardrail checks (`guardrails/README.md` → Check variables). Fill after kickoff; Strangler lists both trees:

```sh
export UI="_TBD_"  STATE="_TBD_"  PRES="_TBD_"  DATA="_TBD_"  DOMAIN="_TBD_"  REPO_IF="_TBD_"
export CORE="_TBD_"  DI="_TBD_"  TOKENS="_TBD_"  STRINGS="_TBD_"
export LOOKUP='_TBD_'  ROOT_ALLOW='_TBD_'  GATEWAY='_TBD_'  STORAGE='_TBD_'  LOGGER='_TBD_'
```

### PR-A2 Feature First (keep if chosen or if Strangler)

| Artifact | Path |
|----------|------|
| Screen | `lib/features/<feature>/views/<feature>_screen.dart` |
| Widgets | `lib/features/<feature>/widgets/` |
| Controller | `lib/features/<feature>/controller/` |
| Models | `lib/features/<feature>/models/` |
| Repository interface | `lib/features/<feature>/services/<feature>_repository.dart` (imports `models/` only) |
| Repository impl / data sources | `lib/features/<feature>/services/` |
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
- PR-D2. Repositories return a single failure-success boundary type: `_TBD_` (e.g. `Either<Failure, T>` or a sealed `Result<T>`) (ND-8).
- PR-D3. Endpoints centralised; models: `_TBD_` serializer (ND-7).

## E. Routing

- PR-E1. Typed routes only: `_TBD_` package/approach (ADR). No string route names for screens.

## F. UI

- PR-F1. Design tokens only (colors, spacing, typography). Token class names: `_TBD_`. No raw `Colors.*` / magic font sizes in features.
- PR-F2. User-facing strings: `_TBD_` (gen-l10n `.arb` / constants class) (ND-5). Supported locales: `_TBD_`. RTL: yes / no.
- PR-F3. Every async screen: loading / error / empty / no-internet.
- PR-F4. Supported platforms and form factors: `_TBD_` (Android / iOS / web / desktop; phone / tablet / foldable). Themes: light / dark / system. Orientation lock: `_TBD_` (ND-16).
- PR-F5. Accessibility target: WCAG 2.2 AA (A11Y-*) unless an ADR says otherwise.

## G. Security

- PR-G1. Public client configuration via dart-define / ignored env files → typed config. Values shipped in an app binary are extractable; keep privileged secrets on the server. Never commit credentials.
- PR-G2. Tokens not in URLs or logs. Session storage behind one abstraction.

## H. Testing

- PR-H1. Every new state holder + repository ships tests with the chosen test stack: `_TBD_` (ND-9).
- PR-H2. Critical journeys with integration tests (TEST-20): `_TBD_`.

## J. Persistence and offline

- PR-J1. Key-value / secure / structured storage packages: `_TBD_` (ND-6, ADR).
- PR-J2. Offline support level: none / read cache / read + write outbox — `_TBD_`.

## K. Observability

- PR-K1. Logger / crash reporter / analytics: `_TBD_` (ND-11). Consent required: yes / no.

## L. Configuration, CI and release

- PR-L1. Flavors / environments: `_TBD_` (ND-10).
- PR-L2. Toolchain pin: `_TBD_` (`.fvmrc` / `.tool-versions`) and Flutter version (ND-13).
- PR-L3. CI/CD provider and release tooling: `_TBD_` (ND-15).
- PR-L4. Branching model: `_TBD_` (ND-14).
- PR-L5. Lint set: `_TBD_` (`flutter_lints` + extras / `very_good_analysis`) (ND-12).

## I. Open decisions

| ID | Decision | Options | Default until decided |
|----|----------|---------|-----------------------|
| ND-0 | Orientation | Feature First / Layer First / mixed (Strangler, existing apps only) | **ask** — do not invent. Greenfield: Feature First recommended for L2+. Existing app: Stay vs Strangler (`checklists/greenfield-kickoff.md`) |
| ND-1 | State paradigm | Riverpod / flutter_bloc / other | **ask** — do not invent |
| ND-2 | DI | riverpod overrides / get_it / constructor-only | **ask** |
| ND-3 | Routing | go_router / auto_route / other | **ask** |
| ND-4 | HTTP client | dio / http + gateway | **ask** |
| ND-5 | Localization / string source | gen-l10n `.arb` / constants class | **ask** |
| ND-6 | Storage | shared_preferences / flutter_secure_storage / drift / hive_ce / isar | **ask**; secure storage for tokens is not optional (SEC-6) |
| ND-7 | Serializer | freezed + json_serializable / json_serializable / dart_mappable | **ask** |
| ND-8 | Result / failure type | `Either` (fpdart/dartz) / sealed `Result<T>` | **ask** |
| ND-9 | Test stack | bloc_test + mocktail / mocktail only / mockito | follows ND-1; **ask** if unclear |
| ND-10 | Config / flavors | dart-define-from-file + flavors (`sop/configuration.md`) | dart-define-from-file (UNIVERSAL); flavor set **ask** |
| ND-11 | Logging / crash / analytics | logger + Crashlytics / Sentry / none; analytics vendor | **ask** |
| ND-12 | Lint set | flutter_lints + extras / very_good_analysis | flutter_lints + `rules/flutter.rules` FL-3 extras |
| ND-13 | Toolchain pin | FVM (`.fvmrc`) / asdf-mise (`.tool-versions`) | **ask**; exactly one |
| ND-14 | Branching | trunk-based / GitFlow-lite (`sop/git-and-pr.md`) | trunk-based |
| ND-15 | CI/CD | GitHub Actions / Codemagic / Bitrise / fastlane | **ask** |
| ND-16 | Platforms, form factors, themes | see PR-F4 | **ask** |
