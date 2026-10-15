# SOP: Release, Versioning and Store Compliance

## Purpose

Ship predictable, traceable releases that pass store review, can be rolled out gradually, and can be controlled after shipping.

## Scope

Version numbers, branching for releases, changelog, flavors, store compliance (privacy, data safety, account deletion), staged rollout, hotfixes, feature flags, remote config, forced/soft updates. Guardrails: `../guardrails/release.md` REL-*, SEC-17..20. Checklist: `../checklists/release.md`.

## Principles

1. Every build in a store maps to one tag, one changelog section, one set of symbols.
2. Environments differ by configuration, not code.
3. What ships can be turned off without a new release.

## Standard

### Versioning (UNIVERSAL, HIGH)

- `version: MAJOR.MINOR.PATCH+BUILD` in `pubspec.yaml`.
  - MAJOR: breaking product change / redesign; MINOR: features; PATCH: fixes.
  - BUILD: monotonically increasing integer shared by both stores (CI computes or validates it).
- Tag `vX.Y.Z` on the commit that was built. Release notes come from `CHANGELOG.md`.

### Branching for releases (RECOMMENDED)

- Trunk-based: release from `main` tags; hotfix from the tag on `hotfix/x.y.z+1`, merged back.
- Or release branches `release/x.y` when QA cycles are long. Record the choice in `sop/git-and-pr.md` project notes.

### Flavors / environments (UNIVERSAL)

- `dev`, `staging`, `prod` (or the project's set) via Android `productFlavors` + iOS schemes/xcconfigs, each with its own bundle id suffix, app name, icon, Firebase project, and `config/<env>.json` (`configuration.md`).
- Feature code never checks the flavor name (REL-3); it reads typed config values.

### Store compliance (UNIVERSAL, HIGH)

| Item | Where | When to update |
|------|-------|----------------|
| iOS privacy manifest | `ios/Runner/PrivacyInfo.xcprivacy` (+ SDK manifests) | adding SDKs / required-reason APIs |
| App Store privacy labels | App Store Connect | data collection changes |
| Play Data safety | Play Console | data collection changes |
| Account deletion | in-app path + web link | apps with account creation |
| Permissions purpose | `Info.plist`, README (PLAT-1) | new permission |
| Target SDK | `android/app/build.gradle` | yearly Play requirement |
| Export compliance / encryption | Info.plist `ITSAppUsesNonExemptEncryption` | crypto changes |

### Rollout (RECOMMENDED)

- Android staged rollout (e.g. 5% → 20% → 50% → 100%) gated on crash-free sessions; iOS phased release.
- Halt criteria written down (crash-free < 99.5%, spike in a non-fatal).

### Feature flags and remote config (RECOMMENDED)

- `FeatureFlags` interface (`isEnabled(Flag.newCheckout)`) backed by remote config / a flags service, with **local defaults** that are safe if fetching fails.
- Flag registry: key, owner, default, created, removal date (REL-6). Remove the flag and dead branch after rollout.
- Kill switches for risky features (payments, new sync engine).

### Forced and soft updates (UNIVERSAL for backend-coupled apps)

- Backend or remote config publishes `min_supported_version` and `latest_version`.
- Startup check: below minimum → blocking update screen with store link; below latest → dismissible prompt. Network failure never blocks startup (REL-8).
- Android may use the in-app updates API; iOS links to the App Store.

## Recommended implementation

- `.agents/skills/flutter-workflow/scripts/bump_version.sh` (or a CI step) that bumps `pubspec.yaml`, moves CHANGELOG `[Unreleased]`, and tags.
- Release notes per store generated from the CHANGELOG section.

## Anti-patterns

- Reusing a build number; tagging after the fact from a different commit.
- `if (F.appFlavor == Flavor.dev) showDebugMenu()` scattered in features.
- Flags that live forever.

## Exceptions

Internal-distribution-only apps may skip store-specific items but keep versioning, tags, changelog and CI builds.
