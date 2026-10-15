# SOP: CI/CD

## Purpose

Every change is verified the same way on a clean machine, and every release artefact is built reproducibly by automation.

## Scope

Pipeline stages, toolchain pinning, caching, codegen checks, secrets, build/sign/upload automation. Guardrails: `../guardrails/release.md` CI-*, TEST-9, DEP-11. Decision: ND-13 (toolchain pin), ND-15 (CI provider).

## Principles

1. CI is the source of truth for "it builds and passes".
2. One pinned Flutter version for humans and machines.
3. Releases are built from tags by CI, never from laptops.

## Standard

### Toolchain (UNIVERSAL, HIGH)

- Pin with **FVM** (`.fvmrc`) or **asdf/mise** (`.tool-versions`) — exactly one (DEP-11). `pubspec.yaml` `environment.sdk`/`flutter` constraints agree.
- Developers and agents run commands through the pin (`fvm flutter …` when FVM is used).
- `pubspec.lock` is committed for apps.

### PR pipeline (UNIVERSAL, HIGH)

| Stage | Command (adapt) | Fails on |
|-------|-----------------|----------|
| Setup | install pinned Flutter; `flutter pub get --enforce-lockfile` | lockfile drift |
| Codegen | `dart run build_runner build --delete-conflicting-outputs` then `git diff --exit-code` | stale generated code (CI-3) |
| l10n | `flutter gen-l10n` | missing keys (I18N-2) |
| Format | `dart format --output=none --set-exit-if-changed .` | unformatted code |
| Analyze | `flutter analyze --no-fatal-infos` (or fatal per project) | new issues |
| Test | `flutter test --coverage` | any failure |
| Checks | `checklists/architecture-compliance.md` script (optional, warn-only at first) | blocking FAILs |

Cache the pub cache and Flutter SDK; keep the PR pipeline under ~10 minutes.

### Main / nightly (RECOMMENDED)

- Build debug/profile APK + iOS simulator build to catch native breakage.
- `integration_test` on an emulator/simulator or device farm for critical journeys (TEST-20).

### Release pipeline (UNIVERSAL)

- Trigger: tag `vX.Y.Z` (or a release branch, per `release-and-versioning.md`).
- Steps: verify build number > last uploaded → build with prod config (`--dart-define-from-file`, `--obfuscate --split-debug-info`) → sign with CI-stored keys → upload symbols to crash reporter → upload to TestFlight / Play internal track → attach changelog.
- Tools: fastlane, Codemagic, GitHub Actions, Bitrise — record the choice (ND-15).

### Secrets (UNIVERSAL, HIGH)

- Keystore, `key.properties`, App Store Connect API key, Play service account, config JSONs: CI secret store only (CI-4), decoded to files at build time, masked in logs.

## Recommended implementation

GitHub Actions sketch:

```yaml
jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { flutter-version-file: pubspec.yaml, cache: true }   # or read .fvmrc
      - run: flutter pub get --enforce-lockfile
      - run: dart run build_runner build --delete-conflicting-outputs && git diff --exit-code
      - run: dart format --output=none --set-exit-if-changed .
      - run: flutter analyze
      - run: flutter test --coverage
```

## Anti-patterns

- "Works on my machine" releases built locally with a debug keystore.
- Two pin files with different versions.
- Skipping CI for "docs-only" changes that also touch `lib/`.

## Exceptions

Hotfix pipelines may skip slow nightly stages but never analyze/test.
