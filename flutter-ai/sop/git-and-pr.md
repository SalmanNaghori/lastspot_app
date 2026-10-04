# SOP: Git and Pull Requests

## Purpose

Changes that are small enough to review, described well enough to understand later, and explicit about their architectural and dependency impact.

## Scope

Branches, commits, pull requests, code review, architecture-changing PRs, dependency changes, large refactors, generated files.

## Principles

1. One PR, one purpose.
2. The commit history is documentation; write it for the reader in six months.
3. Architectural impact is declared, never discovered.
4. Reviewers review design and correctness; tooling reviews formatting.

## Standard

### Branches (UNIVERSAL)

```text
main            protected; always releasable
develop         optional integration branch (if used, document it)
feature/<ticket>-<short-kebab>
fix/<ticket>-<short-kebab>
refactor/<scope>-<short-kebab>
chore/<scope>
spike/<topic>   never merged; deleted after learning
release/<version>
hotfix/<ticket>
```

Reference project uses `phase_two_master`, `chat_master`, `ui_refactoring` (NEEDS-DECISION ND-13); adopt the scheme above for new branches.

### Commits (UNIVERSAL, HIGH)

Conventional Commits:

```text
<type>(<scope>): <imperative summary ≤ 72 chars>

<body: what and why, not how; wrap at 100>

Refs: <ticket>
BREAKING CHANGE: <if any>
```

Types: `feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `chore`, `build`, `ci`, `style`, `revert`. Scope = feature or layer (`orbits`, `chat`, `network`, `di`).

- One logical change per commit; squash WIP before review.
- Never reuse a commit message verbatim across commits (reference: one 11-point paragraph repeated on 10+ commits — ANTI-PATTERN).
- Generated-file regeneration in its own commit when large (`chore(codegen): regenerate freezed/json`).

### Pull request template (UNIVERSAL, HIGH)

```markdown
## Summary
What and why (2–5 lines).

## Type
feat | fix | refactor | chore | docs | perf | test

## Architectural impact
- [ ] None — follows existing patterns
- [ ] Extends existing pattern (describe)
- [ ] Introduces new pattern / abstraction (link ADR)
- [ ] Changes layer boundaries, DI, routing, state model, networking, persistence (link ADR — REQUIRED)

## Dependencies
- [ ] No dependency changes
- [ ] Added/removed/upgraded: <name> — justification block from sop/dependency-management.md

## Reuse check
Existing code searched for: <widgets/repos/models/helpers>. Reused: <...>. New because: <...>.

## Testing
- Tests added/updated: <files>
- Manual: <steps, devices>

## Checklist (Definition of Done — checklists/definition-of-done.md)
- [ ] format, analyze, tests green
- [ ] no unrelated files changed
- [ ] no secrets / no new hardcoded design values / no new `sl<>` in widgets
- [ ] compliance check run (checklists/architecture-compliance.md) — result attached for architectural PRs

## Screenshots / recordings
```

### Size (RECOMMENDED)

≤ 400 changed lines excluding generated files. Larger refactors split into a series: (1) add new, (2) migrate callers, (3) remove old.

### Architecture-changing PRs (UNIVERSAL, HIGH)

Require: linked ADR (Proposed → Accepted on merge), compliance-check output, a migration note, and review by a tech lead. An AI agent may open such a PR only when the task explicitly asked for an architectural change; otherwise it must report the conflict (see `agent.md`).

### Dependency PRs (UNIVERSAL)

Isolated from feature work when possible; include the justification block; upgrades of architectural packages include a smoke-test note.

### Refactor PRs (UNIVERSAL)

No behaviour change; state "no functional change" in the summary; tests unchanged or added, never removed. Renames of directories/files in dedicated hygiene PRs (reference camelCase → snake_case).

### Generated files (UNIVERSAL)

Committed consistently; reviewers may collapse them. Never mix hand edits with regeneration in one commit.

### Code review (UNIVERSAL)

Reviewer checks, in order: correctness → architecture compliance → tests → naming → readability. Formatting/lint are CI's job. Every comment is either `blocking`, `suggestion`, or `question`. Author resolves all blocking comments before merge; at least one approval; CI green.

### Merge (RECOMMENDED)

Squash-merge feature branches with a Conventional Commit title; rebase before merge; delete branch after.

### Repository hygiene (UNIVERSAL)

- `.gitignore` covers `config/*.json`, `key.properties`, `*.jks`, `.env*`, build outputs, IDE folders.
- No scratch files at root (reference: `0`, `inspect_picker.dart`, `test_empty_notification.dart` — R27).
- One README; a `docs/` or `flutter-ai/` folder for governance.

## Recommended implementation

- Commit lint (`commitlint` or a simple regex hook) enforcing the Conventional Commit header.
- PR template file `.github/pull_request_template.md` (or Bitbucket equivalent) with the block above.
- Branch protection: required CI, required review, no force-push to `main`.

## Examples

Good commit: `fix(network): record Flutter errors to Crashlytics once\n\nFlutterError.onError was assigned three times; the last assignment dropped Crashlytics.\n\nRefs: BO-123`

Bad commit: branch name + 11-point paragraph reused across ten commits (reference).

## Anti-patterns

- PRs mixing a feature, a refactor, and a dependency bump.
- "Fix" / "update" / "changes" commit messages.
- Force-pushing over reviewed commits without notice.
- Deleting tests to make CI green.

## Exceptions

Hotfix PRs may skip the ADR requirement if they only revert or patch; follow-up PR within one sprint carries the proper change.
