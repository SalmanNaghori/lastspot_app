<!-- Copy to <repo-root>/CONTRIBUTING.md. Replace every <...>.

> Adoption seed: confirm or replace example commands, platforms and package names
> from kickoff answers or repository evidence before treating this as setup guidance.

     Greenfield: fill at kickoff from docs/project/flutter/project-rules.md.
     Brownfield: fill from what the repo actually uses (pin file, scripts, CI) — never invent commands. -->

# Contributing

This app is governed by [`.agents/skills/flutter-workflow/references/`](../../references/agent.md). This page is the short, practical version for people joining the project.

These conventions cover the Flutter application. If other stacks are added,
keep their setup and contribution conventions in their own sections; Flutter
commands and checklists do not become requirements for unrelated changes.

## 1. Setup

| Step | Command / action |
|------|------------------|
| Flutter version | `<pin file, e.g. .fvmrc>` → `<e.g. fvm install && fvm use>` |
| Dependencies | `<e.g. fvm flutter pub get>` |
| Config | copy `config/<env>.json.example` → `config/<env>.json`, ask `<who>` for values (never commit them) |
| Code generation | `<e.g. fvm dart run build_runner build --delete-conflicting-outputs>` |
| Localization | `<e.g. fvm flutter gen-l10n>` |
| Run | `<e.g. fvm flutter run --flavor dev --dart-define-from-file=config/dev.json>` |

Always run Flutter/Dart through the pinned version (CI-2).

## 2. Where things go

- Architecture and placement: `docs/project/flutter/project-rules.md` §A (`<Feature First / Layer First / mixed>`).
- What the app does: `docs/project/flutter/features.md`.
- Before building a feature: `checklists/new-feature.md`.

## 3. Branches and commits

- Branches: `<e.g. feat/<ticket>-short-name, fix/..., chore/...>` from `<main>`.
- Commits: Conventional Commits (`feat(checkout): ...`) — `sop/git-and-pr.md`.

## 4. Pull requests

1. Fill the PR template (it carries the Definition of Done).
2. Run locally: `<format>`, `<analyze>`, `<test>`.
3. Update living docs in the same PR: `CHANGELOG.md` `[Unreleased]`, `docs/project/flutter/features.md`, ADR if architectural.
4. At least `<n>` approval(s); CI must be green.

## 5. Changing the rules

- New architectural choice or package: write an ADR (`docs/adr/TEMPLATE.md`).
- Need to break a guardrail: `checklists/exception-request.md`.
- Proposing a change to `.agents/skills/flutter-workflow/references/` itself: PR with an entry in `.agents/skills/flutter-workflow/references/CHANGELOG.md`.

## 6. Releases

`checklists/release.md` — owned by `<role/person>`.

## 7. Help

`<channel / people>`
