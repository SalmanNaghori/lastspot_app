# Architecture Compliance Check

Run on every PR that touches `lib/`. Mandatory (with the matrix attached) for PRs marked "architectural impact" and for every AI-agent change. Each row cites a guardrail ID; the **Check** column is the mechanical test where one exists — run it against the diff (`git diff -U0 | rg "^\+" | ...`) so pre-existing violations do not count against the change.

## Result matrix

| # | Area | Guardrail | Check (on added lines unless noted) | Result |
|---|------|-----------|--------------------------------------|--------|
| 1 | Layers | ARCH-1 | no presentation/views/widgets/controller imports added in data/domain/services/models/core (except composition) | PASS / FAIL / N/A |
| 2 | Layers | ARCH-2 | no `BuildContext`/`Navigator`/`EasyLoading`/dialog in `domain/`, `data/`, or Feature First `services/`/`models/` | |
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
| 18 | Networking | NET-1..5 | gateway only; `ApiRequest`; endpoints centralised; interceptors for auth/401/retry/log | |
| 19 | TLS / tokens | NET-8, NET-9, SEC-7 | no cert bypass reachable in release; no token in URL | |
| 20 | Repository contract | ERR-1, REPO-3, REPO-8 | `Either<Failure,T>`; no UI imports; no `dynamic`/`Map` returns | |
| 21 | Catch discipline | ERR-2, ERR-3, ERR-4 | no try/catch around repository calls in cubits; no empty catches; no stack traces in `error` | |
| 22 | Global handlers | ERR-5 | `FlutterError.onError` assigned once (whole file) | |
| 23 | Logging | ERR-6, SEC-10, SEC-11 | no `print`; no tokens/PII/payloads logged | |
| 24 | Models | ERR-8, ERR-9, MODEL-1 | freezed + json_serializable; tolerant parsing; naming convention | |
| 25 | Routing | ROUTE-1..5, ROUTE-10 | typed route registered; no `Navigator.push` for screens; guard; typed args; `.gr.dart` regenerated | |
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

Result key: **PASS** — no violation in the diff. **FAIL** — violation introduced (must fix or file exception). **N/A** — area untouched. **PRE-EXISTING** — violation exists in touched code but was not introduced; listed in section 3.

## Mechanical check script (run from repo root)

Adapt paths to the recorded orientation (`project/README.md`). Layer First uses `lib/layers/...`. Feature First uses `lib/features/...` and `lib/core`.

```sh
D='git diff -U0 origin/main...HEAD'   # adjust base
ORIENT=$(rg -N "Orientation:" project/README.md | head -1)   # Feature First | Layer First | mixed

$D -- lib | rg "^\+.*sl<" | rg -v "BlocProvider|wrappedRoute|create:" && echo "FAIL DI-2/UI-1"
$D -- lib | rg "^\+.*(^\s*print\(|catch \(_\)\s*\{\s*\})" && echo "FAIL ERR-3/ERR-6"
$D -- lib | rg "^\+.*Future.delayed" && echo "REVIEW ASYNC-5"
$D -- lib android ios | rg "^\+.*(AIza[0-9A-Za-z_-]{30,}|token=|Bearer [A-Za-z0-9._-]{20,})" && echo "FAIL SEC-1/SEC-7"
$D -- lib | rg "^\+.*package:dio/" | rg -v "core/network|core/di" && echo "FAIL NET-1"
$D --name-only | rg "lib/generated/json/" && echo "FAIL ERR-8"
$D --name-only | rg "^pubspec.yaml" && echo "CHECK DEP-1 block"
rg -c "FlutterError.onError =" lib | rg -v ":1$" && echo "FAIL ERR-5"

# ARCH-7: Stay must not add lib/features/ unless that is already the tree
# Strangler / mixed: a feature name must not appear as new files under BOTH trees
$D --name-only -- lib | rg "^lib/features/" > /tmp/ff_paths || true
$D --name-only -- lib | rg "^lib/layers/" > /tmp/lf_paths || true
# fail if the same feature stem is new in both lists (manual review if both files nonempty)

# Layer First UI/data checks (skip if this project is Feature First only)
$D -- lib/layers/domain lib/layers/data | rg "^\+.*(BuildContext|Navigator\.|EasyLoading|Fluttertoast|showDialog|showModalBottomSheet)" && echo "FAIL ARCH-2"
$D -- lib/layers/presentation | rg "^\+.*(Colors\.(?!transparent)|Color\(0x|fontSize:)" && echo "FAIL UI-3"
$D -- lib/layers/presentation | rg "^\+.*Text\(\s*'[A-Za-z]" && echo "FAIL UI-5"
$D -- lib/layers/presentation | rg "^\+.*(Navigator\.push|CupertinoPageRoute|MaterialPageRoute)" && echo "FAIL ROUTE-1"
$D -- lib/layers/presentation/cubit lib/layers/presentation/bloc | rg "^\+.*(BuildContext|context\.read|Navigator|EasyLoading)" && echo "FAIL STATE-6"
$D -- lib/layers/domain/repositories | rg "^\+.*Future<(?!Either)" && echo "FAIL ERR-1"

# Feature First UI/data checks (skip if this project is Layer First Stay)
$D -- lib/features | rg "^\+.*(Colors\.(?!transparent)|Color\(0x|fontSize:)" && echo "FAIL UI-3"
$D -- lib/features | rg "^\+.*Text\(\s*'[A-Za-z]" && echo "FAIL UI-5"
$D -- lib/features | rg "^\+.*(Navigator\.push|CupertinoPageRoute|MaterialPageRoute)" && echo "FAIL ROUTE-1"
$D -- 'lib/features/**/views' 'lib/features/**/widgets' | rg "^\+.*(Repository|DataSource|Dio\()" && echo "FAIL ARCH-4"
$D -- 'lib/features/**/services' 'lib/features/**/models' | rg "^\+.*(BuildContext|Navigator\.|showDialog|showModalBottomSheet)" && echo "FAIL ARCH-2"
$D -- 'lib/features/**/controller' | rg "^\+.*(BuildContext|Navigator|EasyLoading)" && echo "FAIL STATE-6"
```

## Violation report format

Use this for every FAIL or PRE-EXISTING row.

```text
VIOLATION
ID:          <guardrail id>            e.g. DI-2
Severity:    BLOCK | WARN              (MUST/MUST-NOT = BLOCK; SHOULD = WARN)
Location:    <path>:<line>
Evidence:    <the offending line or pattern>
Rule:        <one-line statement of the guardrail>
Introduced:  YES | NO (pre-existing)
Fix:         <compliant alternative, or "tracked in project/remediation-backlog.md R<n>">
Exception:   NONE | <link to filled checklists/exception-request.md + ADR>
```

Example:

```text
VIOLATION
ID:          DI-2
Severity:    BLOCK
Location:    lib/layers/presentation/ui/orbits/widgets/orbit_image.dart:43
Evidence:    final referer = sl<AppConfiguration>().awsReferer;
Rule:        Container resolution only at composition roots; widgets take values from state/params.
Introduced:  NO (pre-existing)
Fix:         Expose `awsReferer` via a config-aware image wrapper constructed at the composition root; tracked R14.
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
