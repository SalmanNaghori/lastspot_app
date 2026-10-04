# SOP: Configuration

## Purpose

One typed, immutable configuration object per environment, injected at build time, with no secrets in the repository and no ambiguity about which environment a build targets.

## Scope

Environments, build-time values, feature flags, platform config (Android/iOS), Flutter version pinning, run configurations.

## Principles

1. Configuration is data supplied to the build, not code.
2. One typed object; no `String.fromEnvironment` scattered through features.
3. Fail fast when configuration is missing.
4. The same command builds every environment; only the file changes.

## Standard

### Environments (UNIVERSAL)

`local`, `dev`, `staging`, `prod` (add only what the team actually deploys).

### Mechanism (UNIVERSAL, HIGH; ADR-0008)

```text
config/
  dev.json.example     ← committed, key names only, placeholder values
  dev.json             ← gitignored, real values
  staging.json
  prod.json
```

```sh
flutter run   --dart-define-from-file=config/dev.json
flutter build apk --dart-define-from-file=config/prod.json --obfuscate --split-debug-info=build/symbols
```

```dart
class AppConfiguration {
  const AppConfiguration({required this.baseUrl, required this.socketBaseUrl, ...});
  final String baseUrl;
  ...
  static AppConfiguration fromEnvironment() {
    const base = String.fromEnvironment('BASE_URL');
    assert(base.isNotEmpty, 'BASE_URL missing: pass --dart-define-from-file=config/<env>.json');
    return AppConfiguration(baseUrl: base, ...);
  }
}
```

- Read **once** in the DI config module; registered as a singleton; injected via constructor. No `String.fromEnvironment` elsewhere.
- Every key in the JSON is consumed (reference: `TENOR_API_KEY` unused — remove or wire). Every field in the config class has a key.
- `Environment` enum derived from a `ENV` key if runtime branching is needed; otherwise omit (reference declares an unused enum — remove).
- `.env` files loaded at runtime (`flutter_dotenv`) are not used: they ship as readable assets.

### Native configuration (UNIVERSAL)

- Android: `manifestPlaceholders` fed from `dart-define` values or a gitignored `local.properties`-style file for Maps keys; `applicationId` suffixes per env via flavors when needed.
- iOS: xcconfig per env; `Info.plist` reads `$(VAR)`.
- Firebase config files per environment when projects differ (`android/app/src/<flavor>/google-services.json`).

### Feature flags (OPTIONAL)

Compile-time: keys in config JSON (`FEATURE_X=true`). Runtime: remote config service behind an interface; defaults in code.

### Flutter/Dart version (UNIVERSAL)

- One pin source (`.fvmrc` **or** `.tool-versions`) plus `environment.sdk` in `pubspec.yaml`; README states the version. Reference has `.fvmrc` 3.32.6 and `.tool-versions` 3.38.3 (ND-11) — align.

### Run configurations (RECOMMENDED)

Commit `.vscode/launch.json` (and/or `.idea/runConfigurations` if the team uses Android Studio) with one configuration per environment so nobody runs without config.

### Assets (UNIVERSAL)

`pubspec.yaml` `flutter.assets` lists only asset directories. Source directories are never assets (reference lists `lib/layers/data/models/responseModels/` — R22).

### Code generation configuration (RECOMMENDED)

`build.yaml` restricting generators to relevant globs; document the exact `build_runner` command in README / `tool/`.

## Recommended implementation

- `tool/run.sh <env>` and `tool/build.sh <env> <platform>` wrappers.
- CI matrix per environment using the same commands.

## Examples

Good (reference): `ConfigInjection` + `AppConfiguration`; gitignored `config/*.json`.

Fix (reference): missing `.json.example` files; unused key/enum; version pin mismatch; Maps keys hardcoded natively.

## Anti-patterns

- Base URL literal in Dart with an `if (kDebugMode)` switch.
- Environment chosen by editing a constant before building.
- Secrets in committed JSON "for convenience".
- Two version pin files disagreeing.

## Exceptions

Local-only overrides (`config/local.json`) may point at `localhost`/ngrok and may enable debug-only interceptors, guarded by `kDebugMode`.
