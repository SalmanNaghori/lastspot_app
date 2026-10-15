# Architecture Compliance Check

Run on every PR that touches `lib/`. Mandatory (with the matrix attached) for PRs marked "architectural impact" and for every AI-agent change. Each row cites a guardrail ID; the **Check** column is the mechanical test where one exists — run it against the diff (`git diff -U0 | rg "^\+" | ...`) so pre-existing violations do not count against the change.

## Result matrix

| # | Area | Guardrail | Check (on added lines unless noted) | Result |
|---|------|-----------|--------------------------------------|--------|
| 1 | Layers | ARCH-1 | no presentation/views/widgets/controller imports added in data/domain/services/models/core (except composition) | PASS / FAIL / N/A |
| 2 | Layers | ARCH-2 | no Flutter UI / `BuildContext` / `Navigator` / overlay loader / dialog in `$DOMAIN` or `$DATA` | |
| 3 | Layers | ARCH-4, UI-1 | no repository/gateway/storage/container lookups in widgets outside composition roots | |
| 4 | Logic placement | ARCH-5, UI-2 | no business rules / decrypt / await-repository in `build`/`initState` | |
| 5 | Abstractions | ARCH-6 | every new interface/base/use case/data source justified in PR | |
| 6 | Structure | STRUCT-1..6, ARCH-7 | new dirs snake_case; no vendored pkgs under lib/; no root scratch; generated files regenerated; feature not split across trees; Stay forbids new `lib/features/` unless that is already the tree | |
| 7 | DI | DI-1, DI-2, STATE-7 | no mid-layer container lookups in state holders / repositories (per project map) | |
| 8 | DI | DI-3, DI-4, DI-6 | registrations match project rules (long-lived repos; per-route state) | |
| 9 | Dependencies | DEP-1..3, DEP-5 | pubspec unchanged, or justification present, no duplicate capability, architectural dep wrapped | |
| 10 | State paradigm | STATE-1, STATE-2 | one paradigm per ADR; no second feature-level paradigm | |
| 11 | State shape | STATE-3, STATE-4 | immutable state; shared status/sealed model; no flag soup | |
| 12 | Emit safety | STATE-5 | closed/disposed/mounted guard after each `await` before update | |
| 13 | Holder purity | STATE-6, STATE-8 | no UI imports, no `BuildContext`, no holder→holder calls | |
| 14 | Subscriptions | STATE-9, ASYNC-1, ASYNC-2 | every `.listen`/debounce/controller has a cancel/dispose | |
| 15 | Events | STATE-10, STATE-11 | if Bloc: sealed events + handlers; else N/A | |
| 16 | Side effects | STATE-12 | navigation/toast/loader only in listeners | |
| 17 | Pagination | STATE-13 | skip/limit/hasMore/paginating contract; in-flight guard | |
| 18 | Networking | NET-1..5 | gateway only; request value object; endpoints centralised; interceptors for auth/401/retry/log | |
| 19 | TLS / tokens | NET-8, NET-9, SEC-7 | no cert bypass reachable in release; no token in URL | |
| 20 | Repository contract | ERR-1, REPO-3, REPO-8 | PR-D2 result type; no UI imports; no `dynamic`/`Map` returns | |
| 21 | Catch discipline | ERR-2, ERR-3, ERR-4 | no try/catch around repository calls in cubits; no empty catches; no stack traces in `error` | |
| 22 | Global handlers | ERR-5 | `FlutterError.onError` assigned once (whole file) | |
| 23 | Logging | ERR-6, SEC-10, SEC-11 | no `print`; no tokens/PII/payloads logged | |
| 24 | Models | ERR-8, ERR-9, MODEL-1 | PR-D3 serializer; tolerant parsing; naming convention | |
| 25 | Routing | ROUTE-1..5, ROUTE-10 | typed route registered; no `Navigator.push` for screens; guard; typed args; generated router regenerated | |
| 26 | Deep links / notifications | ROUTE-6, ROUTE-7, SEC-15 | payload validated; session required | |
| 27 | UI states | UI-6, UI-7 | loading/error/empty/no-internet; one loader style | |
| 28 | Design tokens | UI-3 | no `Colors.*`/`Color(0x`/`fontSize:`/inline `TextStyle` added | |
| 29 | Shared widgets | UI-4, UI-13 | no duplicate button/text field/loader/image wrapper; images via wrapper | |
| 30 | Strings | UI-5 | no `Text('literal')` added | |
| 31 | Widget hygiene | UI-9..12, UI-14 | size limits; no commented-out widgets; controllers disposed; no `Future.delayed` readiness; no global context | |
| 32 | Performance | PERF-1, PERF-2, PERF-4, PERF-7 | builder lists; no heavy work in build; const; keys | |
| 33 | Async | ASYNC-3..6 | `mounted` checks; no dropped futures; no `Future.delayed` sync; stale-result guard | |
| 34 | Tests | TEST-1..4, TEST-5 | required tests present; no real DI/network/sleep in tests | |
| 35 | Security config | SEC-1..3 | no secrets; dart-define only; config gitignored | |
| 36 | Security storage | SEC-6, SEC-8, SEC-9 | no new sensitive keys in weak storage; logout clears; caches encrypted | |
| 37 | Build | SEC-17, SEC-19 | no debug signing; debug paths guarded | |
| 38 | Scope | AI-7 | only task-related files changed | |
| 39 | ADR / project rules | ARCH-7, DEP-4 | architectural change has ADR; orientation recorded; project defaults respected (NEEDS-DECISION defaults); greenfield did not invent a tree | |
| 40 | Pre-existing violations | AI-16 | listed below, not extended | |
| 41 | Forms / theming | UI-24..29 | validation in state; input types; no double submit; theme colors (light+dark); no fixed sizes; no asset path strings | |
| 42 | Accessibility | A11Y-1..8 | labels on icon-only controls; 48dp targets; 1.3× text scale without overflow; contrast; focus order | |
| 43 | Localization | I18N-1..6 | strings via l10n/constants; plurals; locale-aware dates/numbers/currency; RTL-safe paddings | |
| 44 | Persistence | STORE-1..7 | storage behind interface; schema version + migration; cache policy; offline queue idempotent; cleared on logout | |
| 45 | Observability | OBS-1..6 | logger levels; crash reporter once; no PII in analytics; consent respected | |
| 46 | Platform | PLAT-1..6 | permission purpose strings + just-in-time requests; denied/permanently-denied handled; push payload validated | |
| 47 | Release / CI | CI-1..6, REL-1..8 | CI green; version bumped per policy; flavors; flags have owner + removal date | |
| 48 | Living docs | DOC-1..7 | CHANGELOG `[Unreleased]`; `docs/project/flutter/features.md`; ADR; project profile; component docs; CONTRIBUTING | |

Result key: **PASS** — no violation in the diff. **FAIL** — violation introduced (must fix or file exception). **N/A** — area untouched. **PRE-EXISTING** — violation exists in touched code but was not introduced; listed in section 3.

## Mechanical checks (run from the Flutter application root)

```sh
# Compare a chosen commit/ref with staged, unstaged and untracked app changes.
python3 .agents/skills/flutter-workflow/scripts/check_compliance.py --base HEAD
# For a PR, use its reviewed base commit, not an assumed origin/main branch.
```

Requires Git and Python 3.10+. Exit 0 means no candidates in this limited check;
1 means review candidates; 2 means the check could not run. Missing Git, invalid
bases and unreadable inputs do not count as success. No PCRE-enabled rg is needed.
The script reports paths and rule IDs without echoing possible credential values.

Automated scope: added non-generated Dart lines for print, single-line empty
catch and obvious credential patterns; project-wide error-handler assignment
count when a handler is added. Comments, strings, multiline code and generated
files limit these heuristics. This is not a Dart analyzer or a complete secret
scanner. Review candidates before classifying a guardrail violation.

Review **all remaining matrix rows** against the changed paths and actual code.
Use the app's PR-A6 map for layer, DI, token, storage and routing boundaries;
compare file paths rather than filtering only matching source lines. Verify
return types, disposal, existing handler setup, permissions, living docs and
Stay/Strangler placement manually. An untouched area can be N/A; an unperformed
required check must be reported as not run. A zero exit code does not make the
full matrix PASS. The original shell snippet was replaced because its pipelines
could print FAIL yet exit successfully and hide tool errors.

## Violation report format

Use this for every FAIL or PRE-EXISTING row.

```text
VIOLATION
ID:          <guardrail id>            e.g. DI-2
Severity:    BLOCK | WARN              (MUST/MUST-NOT = BLOCK; SHOULD = WARN)
Location:    <path>:<line>
Evidence:    <path, line number and redacted description; never secret values>
Rule:        <one-line statement of the guardrail>
Introduced:  YES | NO (pre-existing)
Fix:         <compliant alternative, or "tracked in docs/project/flutter/remediation-backlog.md #<n>">
Exception:   NONE | <link to filled checklists/exception-request.md + ADR>
```

Example:

```text
VIOLATION
ID:          DI-2
Severity:    BLOCK
Location:    lib/features/profile/widgets/avatar_image.dart:43
Evidence:    final cdnHost = sl<AppConfig>().cdnHost;
Rule:        Container resolution only at composition roots; widgets take values from state/params.
Introduced:  NO (pre-existing)
Fix:         Pass `cdnHost` in through a config-aware image wrapper built at the composition root; tracked in docs/project/flutter/remediation-backlog.md.
Exception:   NONE
```

## Output summary (attach to PR / agent report)

```text
COMPLIANCE SUMMARY
PASS: <n>   FAIL: <n>   N/A: <n>   PRE-EXISTING: <n>
Blocking failures: <list of IDs or "none">
Exceptions requested: <list or "none">
Pre-existing violations observed: <IDs + locations, for backlog>
```
