# Guardrails: CI, Release, Store and Runtime Controls

SOP: `sop/ci-cd.md`, `sop/release-and-versioning.md`. Related: TEST-9, SEC-17..19.

## Continuous integration

**CI-1** — Every PR MUST run in CI: pinned Flutter version, `flutter pub get`, codegen check, `dart format --set-exit-if-changed`, `flutter analyze` (no new issues), `flutter test`. Merging with a red or skipped pipeline MUST NOT happen.

**CI-2** — CI and developers MUST use the same Flutter version from the single pin file (DEP-11, ND-13); CI MUST fail if `pubspec.lock` would change on `pub get`.

**CI-3** — Codegen MUST be verified in CI: regenerate, then `git diff --exit-code` (if generated files are committed) so stale generated code fails the build.

**CI-4** — Secrets for CI/CD (signing keys, store credentials, `--dart-define` files) MUST live in the CI secret store, injected at build time; they MUST NOT be committed or echoed in logs.

**CI-5** — Release artefacts (AAB/IPA) MUST be built only by CI from a tagged commit, never from a developer machine, so builds are reproducible.

**CI-6** — Branch protection MUST require the CI checks and at least one review on the default and release branches.

## Release

**REL-1** — Versions MUST follow `MAJOR.MINOR.PATCH+BUILD` in `pubspec.yaml`; the build number MUST strictly increase for every store upload; every release MUST be git-tagged `vMAJOR.MINOR.PATCH`.

**REL-2** — Each release MUST move `CHANGELOG.md` `[Unreleased]` entries under the new version heading in user-facing language (DOC-1).

**REL-3** — Flavors/environments (e.g. dev, staging, prod) MUST differ only by configuration (`--dart-define-from-file`, bundle id suffix, app name/icon), never by code branches on flavor names in features.
Check: `rg -n "flavor ==|appFlavor ==|isStaging|isDev" $PRES $STATE` → must be empty.

**REL-4** — Store compliance MUST be kept in sync with the code: privacy manifest (`PrivacyInfo.xcprivacy`), App Store privacy labels, Google Play Data safety form, account-deletion path (if accounts exist), target SDK requirements. A PR adding a data-collecting SDK MUST update them.

**REL-5** — A release MUST pass the release checklist (`checklists/release.md`): integration tests (TEST-20), manual smoke on real devices for both platforms, crash-reporter symbols uploaded (SEC-18), staged rollout configured.

**REL-6** — Feature flags MUST be read through one flags interface with typed keys and safe local defaults; every flag MUST have an owner and a removal date; expired flags MUST be removed.

**REL-7** — Remote config / flags MUST NOT be used to ship untested code paths to production users, or to change behaviour that needs store review.

**REL-8** — Apps with a backend contract MUST support a minimum-supported-version check (force/soft update) that is evaluated at startup and does not block on network failure.
