<!-- Flutter sections apply only to Flutter app changes. Other stacks keep their own review requirements. -->

<!-- Copy to <repo-root>/.github/pull_request_template.md. Source: .agents/skills/flutter-workflow/references/sop/git-and-pr.md -->

## What and why

<!-- One paragraph. Link the ticket. -->

## Type

- [ ] Feature
- [ ] Bug fix (regression test included — TEST-4)
- [ ] Refactor (no behaviour change)
- [ ] Chore / dependency / config
- [ ] Release

## Screenshots / recordings

<!-- Required for UI changes: before / after, light + dark, 1.3× text scale. -->

## Checklist

- [ ] Placement follows `docs/project/flutter/project-rules.md` §A; feature lives in one tree (ARCH-7)
- [ ] No new container lookups outside composition roots (DI-2, UI-1)
- [ ] No secrets, hardcoded design values or user-facing strings (SEC-1, UI-3, UI-5)
- [ ] Loading / error+retry / empty / no-internet states handled (UI-6)
- [ ] Accessibility: semantics labels, 48dp targets, text scale (A11Y-*)
- [ ] Strings localized per PR-F2 (I18N-*)
- [ ] Tests added/updated per `guardrails/testing.md`
- [ ] `dart format`, `flutter analyze`, `flutter test` pass locally
- [ ] Codegen regenerated; no hand-edited generated files (STRUCT-5)
- [ ] Dependency changes carry a DEP-1 block (or "none")
- [ ] Living docs updated: CHANGELOG `[Unreleased]`, `docs/project/flutter/features.md`, CONTRIBUTING.md if setup changed, ADR if architectural (DOC-*)

## Dependencies

none | <DEP-1 block>

## Architectural impact

none | <description, ADR link>

## Pre-existing violations observed

none | <IDs + locations>
