# Guardrails: Testing

SOP: `sop/testing.md`.

**TEST-1** — Every new or modified state holder MUST have a unit test (e.g. `bloc_test` for Bloc/Cubit, `ProviderContainer` tests for Riverpod) covering at minimum: success emission sequence, failure emission, and (where applicable) no-internet and pagination stop conditions.
Check: for each changed state-holder file in `$STATE`, a `test/**/<name>_test.dart` exists and is non-empty.

**TEST-2** — Every new or modified repository implementation MUST have tests that mock the API gateway and cover: successful parse, gateway failure pass-through, malformed payload → `Failure`.
Check: `test/**/<name>_repository_impl_test.dart` exists.

**TEST-3** — Every new shared/design-system widget MUST have a widget test covering render, callbacks, and visual states (disabled/loading/error).

**TEST-4** — Every bug fix MUST include a regression test that fails before the fix.

**TEST-5** — Tests MUST NOT depend on the real DI container, network, storage, or wall-clock sleeps (`Future.delayed`). Mocks are constructed per test in `setUp`.
Check: `rg -n "$LOOKUP|Future.delayed|Dio\(|http\.Client\(" test` → must be empty (except boot smoke tests explicitly named).

**TEST-6** — Tests MUST NOT be deleted or skipped (`skip:`) to make CI pass. A skipped test MUST carry a reason and a ticket.
Check: `rg -n "skip:" test`.

**TEST-7** — Test files MUST mirror the `lib/` path and use the `<source>_test.dart` name; groups named after the class under test; test names describe behaviour.

**TEST-8** — Fixtures MUST be real or realistic API payloads in `test/fixtures/`, not inline multi-hundred-line JSON.

**TEST-9** — CI MUST run `flutter analyze` and `flutter test`; a PR MUST NOT merge with failing or absent test runs.

**TEST-10** — Coverage SHOULD be measured on changed files (target ≥ 70 %); whole-repo coverage thresholds SHOULD NOT block PRs in projects with a legacy untested baseline.

**TEST-11** — The test dependencies (the stack recorded in PR-H1, e.g. `bloc_test`, `mocktail`) MUST be under `dev_dependencies`.

**TEST-20** — Critical user journeys listed in `docs/project/flutter/project-rules.md` §H (e.g. sign-in, checkout) MUST have an `integration_test` that runs in CI on at least one platform before a release build (REL-*).

**TEST-21** — Golden tests, when used, MUST pin fonts and device size and MUST be regenerated only in a dedicated commit with reviewed image diffs.

**TEST-22** — Projects with a legacy untested baseline MUST apply TEST-1..4 to every new and modified file immediately; backfill is tracked in `docs/project/flutter/remediation-backlog.md`, never used as a reason to skip tests on new code.
