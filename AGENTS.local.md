<!-- reposeed:begin -->
# Project-local agent context

## Commands

- Install Flutter: `flutter pub get`
- Analyze Flutter: `flutter analyze`
- Test Flutter: `flutter test`

## Flutter workflow

For Flutter work, automatically read `.agents/skills/flutter-workflow/SKILL.md`
and `.agents/skills/flutter-workflow/references/REPOSEED.md` before planning,
scaffolding, or editing code.
For requested initialization or choices blocking authorized implementation, run
greenfield kickoff (orientation first) or brownfield adoption based on real code.
Reuse confirmed answers. Reviews, diagnoses, explanations and planning alone stay
read-only; an empty profile does not authorize adoption writes. An adopted app
follows its saved profile without repeating kickoff.
Apply this workflow only to the Flutter application; other stacks retain their
own conventions. The complete pipeline lives inside the skill and its selected Claude mirror.
App-owned records live in `docs/project/flutter/` and `docs/adr/`.
Keep compatible universal skills, including clarification, planning, code review,
verification and Ponytail; share answers and evidence with the Flutter workflow.
Only commit-messages, maintain-changelog and pr-description are replaced for
Flutter because their output contracts conflict with its Git/PR and docs SOPs.

## Project knowledge

- Read `CONTEXT.md` before making domain or architecture decisions when it exists.
- Read relevant records in `docs/adr/` before changing an established design.
- Update this file when a command or repository-specific convention changes.
<!-- reposeed:end -->
