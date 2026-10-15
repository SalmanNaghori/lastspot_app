# PR review checklist (reviewer)

Author-side checks live in `definition-of-done.md` and `architecture-compliance.md`. This list is for the **reviewer** and focuses on what tools cannot catch. Comment with guardrail IDs (`DI-2: …`) so findings are traceable.

## 1. Intent and scope

- [ ] PR description explains what and why; linked ticket; screenshots for UI (light/dark, large text).
- [ ] Only task-related files changed (AI-7); no drive-by refactors; generated files regenerated, not edited.
- [ ] CI green; compliance matrix attached for architectural or agent-authored PRs.

## 2. Design

- [ ] Simplest thing that works: no new abstraction without a second implementation, test double need, or orchestration (ARCH-6).
- [ ] Reuse evidence is real — the reviewer spot-checks one "created" item against the shared folders (UI-4).
- [ ] Layer direction and placement correct; nothing split across trees (ARCH-1..7).
- [ ] State shape: no flag soup; emit guards after `await`; side effects in listeners (STATE-4, STATE-5, STATE-12).
- [ ] Errors: result type at repository boundary, user-safe messages, no swallowed catches (ERR-1..4).

## 3. Correctness

- [ ] Edge cases: empty list, pagination end, double tap, back during loading, app resumed, offline, token expiry.
- [ ] Async: subscriptions/controllers disposed; stale results ignored (ASYNC-1, ASYNC-2, ASYNC-6).
- [ ] Persistence: migration for changed persisted models; cleared on logout (STORE-3, STORE-6).

## 4. Tests

- [ ] Tests assert behaviour (emitted states, rendered states), not implementation details.
- [ ] Failure and no-internet paths tested, not only success (TEST-1, TEST-2).
- [ ] Bug fix has a regression test that would fail without the fix (TEST-4).

## 5. Accessibility

- [ ] Icon-only controls labelled; images decorative or labelled (A11Y-1).
- [ ] Targets ≥ 48dp; no `shrinkWrap` tap targets (A11Y-2).
- [ ] Screenshot or check at 1.3× text scale — no overflow (A11Y-3).
- [ ] Contrast acceptable in both themes; not color-only (A11Y-4, A11Y-5).
- [ ] Custom controls expose role/state; errors announced; focus to first invalid field (A11Y-6, A11Y-7).

## 6. Localization, security, privacy

- [ ] No literals; plurals via ICU; locale-aware formatting (I18N-1..4).
- [ ] No secrets, tokens in URLs, PII in logs/analytics (SEC-1, SEC-7, SEC-10, OBS-4).
- [ ] New permission/SDK → purpose string, README, store disclosures (PLAT-1, REL-4).

## 7. Docs

- [ ] CHANGELOG entry in user language; `docs/project/flutter/features.md` row; `CONTRIBUTING.md` if setup/workflow changed; ADR for architectural change (DOC-1..3, DOC-6).

Verdict: **Approve** / **Request changes** (list blocking IDs) / **Comment** (SHOULD-level only).
