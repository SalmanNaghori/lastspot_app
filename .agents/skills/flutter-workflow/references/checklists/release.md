# Release checklist

Run for every store release (REL-5). Long form: `sop/release-and-versioning.md`, `sop/ci-cd.md`.

## 1. Freeze

- [ ] Release scope agreed; all included PRs merged; CI green on the release commit.
- [ ] Feature flags for unfinished work are **off** by default; flag registry reviewed, expired flags removed (REL-6).
- [ ] Dependencies: no unreviewed upgrades in the last 48h of the freeze.

## 2. Version and docs

- [ ] `pubspec.yaml` version bumped (MAJOR.MINOR.PATCH); build number higher than the last upload on both stores (REL-1).
- [ ] `CHANGELOG.md` `[Unreleased]` promoted to `## [X.Y.Z] - YYYY-MM-DD` (REL-2); store release notes prepared and localized.
- [ ] Tag `vX.Y.Z` on the exact commit CI will build.

## 3. Quality gates

- [ ] `flutter analyze` clean; unit/widget tests green; integration tests for critical journeys green (TEST-20).
- [ ] Manual smoke on a real Android and a real iOS device with the **release/prod** build: install fresh, upgrade from the previous store version (migrations — STORE-3), login/logout, critical journeys, push tap from terminated state, deep link, offline start.
- [ ] Accessibility smoke: TalkBack + VoiceOver on one critical journey; largest font size; dark mode.
- [ ] Performance smoke: cold start time and one heavy list compared with the previous release (`sop/performance.md`).

## 4. Build and compliance

- [ ] Built by CI from the tag (CI-5), prod config, release signing (SEC-17), `--obfuscate --split-debug-info` (SEC-18).
- [ ] Debug symbols / mapping files uploaded to the crash reporter.
- [ ] No debug menus, test credentials, verbose logging or TLS bypass in the build (SEC-14, SEC-19, OBS-1).
- [ ] Store compliance current: privacy manifest, privacy labels, Data safety, permissions purpose strings, account deletion, target SDK (REL-4, PLAT-1).
- [ ] Minimum-supported-version config updated if this release must become mandatory (REL-8).

## 5. Rollout

- [ ] Android staged rollout / iOS phased release configured; halt criteria written (e.g. crash-free sessions < 99.5%).
- [ ] Owner watching crash-free rate, top non-fatals and reviews for 48h.
- [ ] Rollback plan: halt rollout; kill-switch flags identified; hotfix branch from the tag.

## 6. After

- [ ] Release announced with the CHANGELOG section.
- [ ] Post-release issues logged; backlog updated.
