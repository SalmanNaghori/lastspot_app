# Brownfield audit checklist

Run when `.agents/skills/flutter-workflow/references/` is added to an existing app (ADOPT.md §B), **before** any feature work. Output goes into `docs/project/flutter/*`. No application code is modified during the audit (AI-7). Method: `sop/architecture.md` → "Auditing an existing project".

## 1. Inventory (facts only)

- [ ] `pubspec.yaml`: list every direct dependency in `docs/project/flutter/dependency-inventory.md` with category, where used, verdict (KEEP / REVIEW / REMOVE / LEGACY).
- [ ] Flutter/Dart pin: `.fvmrc` / `.tool-versions` / `pubspec.yaml environment` / CI — record mismatches (DEP-11, CI-2).
- [ ] Composition root: `main.dart`, bootstrap, DI setup, allowed resolution points → `docs/project/flutter/architecture-map.md` §2.
- [ ] Tree: `lib/` top two levels → `architecture-map.md` §1. Detect orientation (Feature First / Layer First / other).
- [ ] Inspect 2–3 representative vertical slices (screen → state → repository → gateway → model where those layers exist) with real paths → §3. If fewer flows exist, inspect all available and report the coverage limit; never invent layers or flows.
- [ ] Cross-cutting: auth/session, routing/guards, errors, logging/crash, config/env, storage, analytics, push/permissions, flags → §4.
- [ ] Key project types (gateway, request object, result type, storage, logger, container lookup) → §5, and PR-A6 check variables.
- [ ] Feature list → initialise `docs/project/flutter/features.md` (DOC-7): one row per existing feature from the route table, feature folders and screens; status based on evidence (`live`/`flagged` only if established, otherwise `observed` with runtime/release status unknown); `Since: pre-adoption`; owner and unknown fields `_TBD_`; evidence path in the Tree column.
- [ ] Tests: count of test files, what they cover, whether CI runs them.
- [ ] CI/CD and release: provider, pipeline stages, signing location, flavors.

## 2. Ask once

- [ ] Stay vs Strangler (`greenfield-kickoff.md` §2). Record in an ADR. No bulk move.

## 3. Pattern drift (counts with evidence)

Resolve applicable PR-A6 paths first; omit unsupported capabilities instead of passing empty or _TBD_ variables. These are candidate searches, not a pass/fail script. Check each command's exit status (rg 1 means no matches; >1 means tool/input error), and never treat a failed search as zero findings. Adapt patterns to the selected stack:

```sh
rg -c "$LOOKUP" $UI | awk -F: '{s+=$2} END {print "container lookups in UI:", s}'
rg -c "Navigator\.push|MaterialPageRoute" lib | awk -F: '{s+=$2} END {print "untyped navigation:", s}'
rg -n "Colors\.|Color\(0x" $PRES # review transparent and token definitions as exclusions
rg -c "Text\(\s*'[A-Za-z]" $PRES | awk -F: '{s+=$2} END {print "literal strings:", s}'
rg -c "print\(|catch \(_\)" lib | awk -F: '{s+=$2} END {print "print/swallowed catches:", s}'
rg -c "Future.delayed" lib | awk -F: '{s+=$2} END {print "Future.delayed:", s}'
rg -c "FlutterError.onError =" lib
rg -n "badCertificateCallback|token=|AIza" lib android ios
```

- [ ] Each pattern classified UNIVERSAL / PROJECT-SPECIFIC / LEGACY / ANTI-PATTERN / NEEDS-DECISION with evidence paths in `docs/project/flutter/audit-report.md`.
- [ ] Two coexisting patterns for one concern → NEEDS-DECISION row in `docs/project/flutter/project-rules.md` §I with a proposed default (AI-17).

## 4. Risk sweep (security / release)

- [ ] Secrets in source, manifest, plist (SEC-1). Token storage (SEC-6). Tokens in URLs/logs (SEC-7, SEC-10).
- [ ] Release signing (SEC-17), TLS bypass (SEC-14), cleartext (SEC-13).
- [ ] Store compliance: privacy manifest, data safety, account deletion (REL-4).
- [ ] Accessibility spot check: text scale 1.3×, TalkBack/VoiceOver on one critical journey (A11Y-*).

## 5. Output

- [ ] `docs/project/flutter/README.md`, `docs/project/flutter/project-rules.md` (all `_TBD_` filled or marked NEEDS-DECISION), `docs/project/flutter/architecture-map.md`, `docs/project/flutter/audit-report.md`, `docs/project/flutter/dependency-inventory.md`.
- [ ] `docs/project/flutter/remediation-backlog.md`: P0 (security/crash), P1 (correctness), P2 (consistency) — proposals only.
- [ ] ADRs for choices the code already made (never invented history — AI-9).
- [ ] Root living docs (DOC-7): keep an existing `CHANGELOG.md`; if missing, create it from `.agents/skills/flutter-workflow/assets/templates/CHANGELOG.md` with `[Unreleased]` + `## [<pubspec version>] — baseline at flutter-ai adoption (earlier history: git log / tags)`. Keep an existing `CONTRIBUTING.md` and add only missing sections; if missing, create it from `.agents/skills/flutter-workflow/assets/templates/CONTRIBUTING.md` using the commands this repo actually uses (pin file, scripts, CI). No invented commands or history.
- [ ] Stop. Present the profile and open NEEDS-DECISION items; no feature work until approved.
