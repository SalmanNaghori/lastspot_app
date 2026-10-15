---
name: flutter-workflow
description: Automatically use for Flutter app initialization, greenfield kickoff, brownfield adoption, and Flutter code, review, debugging, or architecture work. Load the Flutter pipeline before scaffolding or editing Dart. Does not apply to unrelated backend or other stack work.
---

# Flutter workflow

This skill contains the complete Flutter workflow. Its Claude mirror contains the same
references, templates and scripts. App-owned records live in `docs/project/flutter/`
and `docs/adr/`; reuse an existing ADR location through its index.
Resolve paths relative to this skill: [integration contract](references/REPOSEED.md),
[agent workflow](references/agent.md). Read both before Flutter work.
For a monorepo, initialize from the Flutter application's directory and apply
these instructions only to that app. Do not change the conventions of sibling apps.

## Route the first task before writing code

Preserve task mode first: review, diagnosis, explanation and planning requests
alone stay read-only. Use the relevant Flutter checklists without requiring
adoption or filling empty profiles. Do not format files as part of a review.
Only initialize adoption when requested or when a missing choice blocks authorized
implementation. Compatible universal skills support planning, review, verification
and reuse within this pipeline, sharing answers and evidence. Only the three
conflicting commit, PR and changelog skills are replaced for Flutter; their
specific conflicts and the retained skills' scope are listed in `references/REPOSEED.md`.

Inspect the real app tree and `pubspec.yaml`, then read
[project identity](../../../docs/project/flutter/README.md) and
[project rules](../../../docs/project/flutter/project-rules.md).
An unfilled profile does not make existing application code greenfield.

- **New app:** read [adoption section A](references/ADOPT.md) and
  [kickoff section 1](references/checklists/greenfield-kickoff.md).
  Ask Feature First versus Layer First **first**, and wait if unanswered. Reuse
  choices and authorization already supplied. Then ask the remaining
  kickoff questions together, with documented defaults. Record only confirmed
  choices in the project documents and app ADRs. Show the resulting profile;
  stop before scaffolding until the user authorizes it. A generic request to
  initialize the workflow authorizes governance setup, not inventing an app.
- **Existing app without an adopted profile:** read adoption section B and
  [brownfield audit](references/checklists/brownfield-audit.md).
  Inspect dependencies, bootstrap/DI, routes and 2–3 real vertical slices.
  Ask Stay versus Strangler once; preserve the existing tree and report unknowns.
  Record evidence, then obtain the project-profile decision before feature work.
- **Adopted app:** use its recorded choices and accepted ADRs. Do not repeat
  kickoff or change its stack. Follow READ → INSPECT → SEARCH → DESIGN → IMPLEMENT
  → VERIFY → MAINTAIN LIVING DOCS → REPORT in `references/agent.md`.

Read the task-relevant SOP, guardrails, compact rules, and checklists on demand.
Do not load the entire kit, or activate `references/profiles/reference/` unless requested.
Only unresolved decisions that affect the requested task block it.

## Completion evidence

Respect selected platforms, architecture level, packages, and capability scope.
Use the app's pinned toolchain when present. Report commands actually run and
unavailable tools. Maintain the app's changelog, contributing guide, and feature
record with code changes. Preserve RepoSeed-managed blocks in root instructions;
never overwrite them with the kit's standalone templates.
