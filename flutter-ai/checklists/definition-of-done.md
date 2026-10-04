# Definition of Done — Checklist

Copy into the PR description (or the agent's final report). Every unchecked item needs a written reason or the change is not done.

## 1. Structure and naming
- [ ] Files are in the correct layer/feature folder (`sop/project-structure.md`, `project/project-rules.md` §A).
- [ ] New directories and files are `snake_case`; class names match file stems (`sop/naming-conventions.md`).
- [ ] No new files under `lib/generated/json/`, `lib/layers/app/custom/`, or at repo root.
- [ ] Orientation respected (ARCH-7): a feature is not split across `lib/features/` and `lib/layers/`. Stay: no new `lib/features/` unless that is already the tree. No bulk tree move.

## 2. Reuse
- [ ] Searched for existing repositories, endpoints, models, widgets, events, helpers before creating (list search terms/paths).
- [ ] Reused or extended existing code where possible; every new abstraction justified (ARCH-6).

## 3. Dependencies
- [ ] No dependency changes, **or** the DEP-1 justification block is included and no duplicate capability is introduced.
- [ ] Architectural dependency changes have an ADR.

## 4. Architecture
- [ ] Layer direction respected; no Flutter UI in data/domain (Layer First: `domain/`/`data/`; Feature First: `services/`/`models/`); no presentation imports from lower layers (ARCH-1..3).
- [ ] Constructor injection; `sl<>()` only at composition roots (DI-1, DI-2).
- [ ] DI registration in the correct module with correct lifetime (DI-3, DI-4).
- [ ] State: Cubit by default; `@freezed` + `Status`; no flag soups; `isClosed` after every `await` (STATE-2..5).
- [ ] Repository returns `Either<Failure, T>`; gateway via `ApiRequest`; endpoints in `ApiEndpoints` (NET-1..4, ERR-1).
- [ ] Typed route registered, guarded if needed, generated code committed (ROUTE-1, ROUTE-4, ROUTE-10).
- [ ] Side effects only in listeners (STATE-12).

## 5. UI states and separation
- [ ] Loading, error (+retry), empty, no-internet states rendered (UI-6).
- [ ] One loader style for the state (UI-7).
- [ ] No business logic, `sl<>()`, repository or storage access in widgets (UI-1, UI-2).
- [ ] Design tokens only; no `Colors.*`, `Color(0x`, `fontSize:`, inline `TextStyle` (UI-3).
- [ ] Strings from `AppString`/l10n (UI-5).
- [ ] Controllers/observers/subscriptions disposed (UI-11, ASYNC-1, ASYNC-2).

## 6. Error handling and async
- [ ] No empty or log-only catches without documented fallback (ERR-3).
- [ ] User-safe error messages; no stack traces in state (ERR-4).
- [ ] No `Future.delayed` as a readiness hack (ASYNC-5).

## 7. Tests
- [ ] Cubit/Bloc tests: success, failure, no-internet, pagination as applicable (TEST-1).
- [ ] Repository tests with mocked gateway (TEST-2).
- [ ] Shared widget tests (TEST-3); regression test for bug fixes (TEST-4).
- [ ] `flutter test` green.

## 8. Quality
- [ ] `dart format .` applied; `flutter analyze` clean (no new warnings/infos).
- [ ] No `print`, no commented-out code blocks, no `// ignore:` without reason, no TODO without owner+ticket.
- [ ] Files < 400 lines / `build` < 100 lines, or justified.

## 9. Security
- [ ] No secrets or env values in code, manifest, plist (SEC-1, SEC-2).
- [ ] No tokens/PII in logs or URLs (SEC-7, SEC-10).
- [ ] No TLS/debug bypass reachable in release (SEC-14, SEC-19).

## 10. Scope and documentation
- [ ] Only task-related files changed; generated files regenerated, not hand-edited.
- [ ] Commit messages follow Conventional Commits; PR template filled (`sop/git-and-pr.md`).
- [ ] ADR added/updated if an architectural decision was made; `project/project-rules.md` updated if a project default changed.

## 11. Compliance
- [ ] `checklists/architecture-compliance.md` matrix completed; all PASS, or FAIL items have an approved exception (`checklists/exception-request.md`).
- [ ] Pre-existing violations observed (not introduced) are listed for the backlog.
