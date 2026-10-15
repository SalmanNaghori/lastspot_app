# Contributing to LastSpot

This app is governed by [`.agents/skills/flutter-workflow/references/`](.agents/skills/flutter-workflow/references/agent.md). This page is the practical onboarding guide for contributors.

## 1. Setup

| Step | Command / action |
|------|------------------|
| Flutter version | `.fvmrc` (pinned to `stable`) → `fvm install && fvm use` |
| Dependencies | `fvm flutter pub get` |
| Configuration | Environment variables in `lib/core/network/supabase_config.dart` (`SupabaseConfig.supabaseUrl`, `SupabaseConfig.supabaseAnonKey`) |
| Code generation | `fvm dart run build_runner build --delete-conflicting-outputs` |
| Localization | `fvm flutter gen-l10n` (source: `lib/core/l10n/intl_en.arb`) |
| Run app | `fvm flutter run` |

Always run Flutter and Dart commands through FVM (`fvm flutter ...`, `fvm dart ...`).

## 2. Where Things Go

- **Architecture:** Feature-First Clean Architecture per `docs/project/flutter/project-rules.md` §A.
- **Placement:** All feature code lives in `lib/features/<name>/{data, domain, presentation}`.
- **Shared code:** Centralized in `lib/core/{constants, di, l10n, network, services, theme, utils, widgets}`.
- **Feature Catalogue:** Tracked in `docs/project/flutter/features.md`.
- **Before building a feature:** Review `.agents/skills/flutter-workflow/references/checklists/new-feature.md`.

## 3. Branches and Commits

- **Branches:** `feat/<short-name>`, `fix/<short-name>`, `chore/<short-name>` branched from `main`.
- **Commits:** Conventional Commits (`feat(chat): add whatsapp formatting`, `fix(auth): handle expired session`).

## 4. Verification & Pull Requests

Before submitting a PR, ensure all checks pass:
1. `fvm dart format .`
2. `fvm flutter analyze`
3. `fvm flutter test`
4. Update living docs in the same PR:
   - `CHANGELOG.md` (`[Unreleased]`)
   - `docs/project/flutter/features.md` (if adding/modifying user-facing features)
   - `docs/adr/` (if making a structural architectural change)

## 5. Changing Architectural Rules

- Adding a major package or modifying architectural patterns requires an Architectural Decision Record in `docs/adr/` using `docs/adr/TEMPLATE.md`.
- Exceptions to guardrails must be documented via `.agents/skills/flutter-workflow/references/checklists/exception-request.md`.
