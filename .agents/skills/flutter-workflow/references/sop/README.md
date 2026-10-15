# Standard Operating Procedures (SOP)

SOPs answer **"How should we build Flutter software?"** They explain the reasoning, the standard, the recommended implementation, and the exceptions. Guardrails (`../guardrails`) state the hard boundaries; rules (`../rules`) compress both for AI agents.

Every SOP follows the same sections: Purpose, Scope, Principles, Standard, Recommended implementation, Examples, Anti-patterns, Exceptions. Each significant statement carries a classification tag:

`UNIVERSAL` · `RECOMMENDED` · `OPTIONAL` · `PROJECT-SPECIFIC` · `LEGACY` · `ANTI-PATTERN` · `NEEDS-DECISION`

and, where derived from audit evidence, a confidence (`HIGH` / `MEDIUM` / `LOW`). Rules with LOW confidence are never mandatory.

## Reading order

Start here, then read what your task touches.

Orientation (Feature First vs Layer First, or Stay vs Strangler on an existing app) is decided at kickoff — [`../checklists/greenfield-kickoff.md`](../checklists/greenfield-kickoff.md) — before any `lib/` scaffolding. Do not invent a tree.

| # | SOP | Answers |
|---|-----|---------|
| 1 | [architecture.md](architecture.md) | Which architecture level? Where does code belong? Greenfield vs brownfield |
| 2 | [project-structure.md](project-structure.md) | Directory layout, Feature First vs Layer First, Stay vs Strangler |
| 3 | [feature-architecture.md](feature-architecture.md) | How to build one feature end to end |
| 4 | [naming-conventions.md](naming-conventions.md) | How to name files, classes, events, routes |
| 5 | [state-management.md](state-management.md) | Bloc vs Cubit vs other; state shape; pagination |
| 6 | [bloc.md](bloc.md) | flutter_bloc specifics |
| 7 | [dependency-management.md](dependency-management.md) | When and how to add packages |
| 8 | [dependency-injection.md](dependency-injection.md) | Composition root, constructor injection |
| 9 | [networking.md](networking.md) | HTTP gateway, interceptors, errors |
| 10 | [repository.md](repository.md) | Repository responsibilities |
| 11 | [models-and-data.md](models-and-data.md) | DTO / entity / serialization |
| 12 | [routing.md](routing.md) | Typed routes, guards, deep links |
| 13 | [ui-architecture.md](ui-architecture.md) | Screens, widgets, design tokens |
| 14 | [error-handling.md](error-handling.md) | Failure model end to end |
| 15 | [async-programming.md](async-programming.md) | Futures, streams, cancellation |
| 16 | [testing.md](testing.md) | What to test and how |
| 17 | [performance.md](performance.md) | Required vs recommended vs premature |
| 18 | [security.md](security.md) | Secrets, tokens, logs, storage |
| 19 | [configuration.md](configuration.md) | Environments, dart-define |
| 20 | [code-quality.md](code-quality.md) | Lints, formatting, dead code |
| 21 | [git-and-pr.md](git-and-pr.md) | Branches, commits, review |
| 22 | [definition-of-done.md](definition-of-done.md) | Completion checklist (pointer) |
| 23 | [accessibility.md](accessibility.md) | Semantics, targets, text scale, contrast, motion |
| 24 | [localization.md](localization.md) | ARB / gen-l10n, plurals, formatting, RTL |
| 25 | [theming-and-responsive.md](theming-and-responsive.md) | Tokens, ThemeData, dark mode, breakpoints, assets |
| 26 | [forms-and-validation.md](forms-and-validation.md) | Validation in state, submission, inputs, autofill |
| 27 | [persistence-and-offline.md](persistence-and-offline.md) | Storage choice, cache policy, outbox, migrations |
| 28 | [observability.md](observability.md) | Logger, crash reporting, analytics, consent |
| 29 | [platform-integration.md](platform-integration.md) | Permissions, push, platform channels, background |
| 30 | [ci-cd.md](ci-cd.md) | Toolchain pin, PR pipeline, release pipeline, secrets |
| 31 | [release-and-versioning.md](release-and-versioning.md) | Versions, flavors, store compliance, rollout, flags, forced update |
| 32 | [living-docs.md](living-docs.md) | CHANGELOG, CONTRIBUTING, features.md, ADRs — create or initialise, then maintain in the same PR |

## Reference implementation

SOPs were stress-tested against a real L3 app (snapshot in [`../profiles/reference`](../profiles/reference)). SOPs keep only anonymised examples; evidence, counts and class names from that snapshot live in `profiles/reference/` (audit report, rules overlay, example ADRs). Active choices live in [`../../../../../docs/project/flutter`](../../../../../docs/project/flutter) + ADRs. Patterns were promoted to UNIVERSAL only when sound in isolation; harmful ones became LEGACY or ANTI-PATTERN.
