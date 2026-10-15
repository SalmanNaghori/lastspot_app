# Guardrails

Guardrails answer **"What must never be violated?"** They are the enforceable boundary of the standard. Each guardrail is a single testable statement using RFC-2119 keywords:

| Keyword | Meaning | Violation handling |
|---------|---------|--------------------|
| **MUST / MUST NOT** | Absolute. No PR merges with a violation unless an approved exception (`checklists/exception-request.md`) and ADR exist. | Block |
| **SHOULD / SHOULD NOT** | Strong default. Deviation requires a stated reason in the PR. | Reviewer decides |
| **MAY** | Permitted option. | — |

Every guardrail carries an ID (`ARCH-1`, `DEP-3`, ...) used in compliance reports and code review comments, and where possible a **Check** — an `rg` pattern or analyzer rule that detects violations mechanically.

Guardrails are **universal**: they never name a specific app's classes, file:line evidence or backlog ids. Evidence from the reference snapshot lives in `../profiles/reference/rules-overlay.md`.

## Check variables

Checks never hardcode a folder tree. They use the shell variables below, which each project defines once in `docs/project/flutter/project-rules.md` **PR-A6** (Strangler: list both trees). Export them before running checks:

```sh
# Feature First example
export UI="lib/features/*/views lib/features/*/widgets lib/shared/widgets"
export STATE="lib/features/*/controller"
export PRES="$UI $STATE"
export DATA="lib/features/*/services lib/features/*/models"
export DOMAIN="lib/features/*/domain lib/features/*/services/*_repository.dart"   # interfaces are domain contracts
export REPO_IF="lib/features/*/services/*_repository.dart"                         # repository interfaces
export CORE="lib/core"
export DI="lib/core/di"
export TOKENS="lib/core/theme"                                    # design tokens, allowed to hold raw values
export STRINGS="lib/core/l10n"                                    # string source (ARB / constants)

# Layer First example
# UI="lib/layers/presentation/ui lib/layers/presentation/widgets"  STATE="lib/layers/presentation/cubit lib/layers/presentation/bloc"
# PRES="lib/layers/presentation"  DATA="lib/layers/data"  DOMAIN="lib/layers/domain"  REPO_IF="lib/layers/domain/repositories"
# CORE="lib/layers/core"  DI="lib/layers/core/di"  TOKENS="lib/layers/core/theme"  STRINGS="lib/layers/core/l10n"

# Stack-specific regexes (from the ADRs)
export LOOKUP='sl<|GetIt\.I'                 # container lookup. Riverpod: 'ref\.(read|watch)\(\w*(Repository|Service|Api)\w*Provider'
export ROOT_ALLOW='BlocProvider\(|create:|wrappedRoute|ProviderScope|overrides:'   # composition-root call sites
export GATEWAY='ApiClient|ApiGateway'        # the project's single HTTP gateway type(s)
export STORAGE='AppStorage|Hive\.|SharedPreferences|GetStorage|FlutterSecureStorage'
export LOGGER='AppLogger|log\.'              # the project logger
```

Unquoted `$UI` etc. are intentional (word splitting into several paths). If a glob matches nothing, `rg` reports it — fix PR-A6, do not delete the check.

## Files

| File | Domain | IDs |
|------|--------|-----|
| [architecture.md](architecture.md) | Layers, DI, structure | `ARCH-*`, `DI-*`, `STRUCT-*` |
| [dependencies.md](dependencies.md) | Packages | `DEP-*` |
| [state-management.md](state-management.md) | Bloc/Cubit, state shape | `STATE-*` |
| [networking.md](networking.md) | HTTP, gateway, errors, realtime | `NET-*`, `ERR-*` |
| [routing.md](routing.md) | Navigation, deep links | `ROUTE-*` |
| [ui.md](ui.md) | Screens, widgets, tokens | `UI-*` |
| [testing.md](testing.md) | Required tests | `TEST-*` |
| [performance.md](performance.md) | Rebuilds, lists, leaks | `PERF-*`, `ASYNC-*` |
| [security.md](security.md) | Secrets, tokens, logs, build | `SEC-*` |
| [ai-development.md](ai-development.md) | Rules for AI coding agents | `AI-*` |
| [accessibility.md](accessibility.md) | Semantics, targets, text scale, contrast | `A11Y-*` |
| [localization.md](localization.md) | Strings, ARB, plurals, RTL, formatting | `I18N-*` |
| [persistence.md](persistence.md) | Local storage, cache, offline, migrations | `STORE-*` |
| [observability.md](observability.md) | Logging, crash reporting, analytics | `OBS-*` |
| [platform.md](platform.md) | Permissions, push, platform channels | `PLAT-*` |
| [release.md](release.md) | CI, flavors, versioning, store, flags, force update | `CI-*`, `REL-*` |
| [documentation.md](documentation.md) | Living docs in the same change | `DOC-*` |

## Relationship to SOP and rules

```text
SOP        explains the why and the how          (long form)
Guardrail  states the boundary + how to check    (this folder)
Rule       compresses both for AI agents         (rules/*.rules)
```

Every guardrail maps to a SOP section and to at least one line in `.agents/skills/flutter-workflow/references/rules/`. The cross-reference is verified in `checklists/architecture-compliance.md`.

## Project overrides

A project MAY relax a SHOULD via `docs/project/flutter/project-rules.md`. A project MUST NOT relax a MUST without an exception record and ADR. Approved deviations for *this* app are listed in `docs/project/flutter/project-rules.md`. Optional historical examples: `profiles/reference/project-rules.md`.
