# SOP: Code Quality

## Purpose

Code that is uniform enough to be read by anyone on the team or by an agent without a style debate, and free of the dead weight that hides real problems.

## Scope

Lints, formatting, imports, comments and documentation, TODOs, logging, debug code, dead code, duplication, complexity, generated code.

## Principles

1. **The formatter decides layout; the linter decides style; humans decide design.**
2. **Delete, don't comment out.** Git remembers.
3. **Zero analyzer warnings on `main`.** Infos are reviewed, not ignored.
4. **A `// ignore:` is a documented exception**, not a shortcut.

## Standard

### Formatting (UNIVERSAL, HIGH)

`dart format .` before every commit; line length 100 (project decision, set in `analysis_options.yaml` `formatter: page_width: 100` on Dart ≥ 3.7) or default 80 — one per project. CI fails on unformatted files.

### Lints (RECOMMENDED; ND-10 for reference)

Baseline: `include: package:flutter_lints/flutter.yaml` (reference) plus:

```yaml
linter:
  rules:
    prefer_const_constructors: true
    prefer_const_declarations: true
    prefer_final_locals: true
    prefer_single_quotes: true
    always_declare_return_types: true
    avoid_print: true
    avoid_dynamic_calls: true
    unawaited_futures: true
    cancel_subscriptions: true
    close_sinks: true
    use_key_in_widget_constructors: true
    avoid_unnecessary_containers: true
    sized_box_for_whitespace: true
    require_trailing_commas: true
    directives_ordering: true
    unnecessary_await_in_return: true
analyzer:
  errors:
    missing_required_param: error
    missing_return: error
    invalid_use_of_protected_member: error
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.gr.dart"
    - "lib/generated/**"
```

Or adopt `very_good_analysis` wholesale. Either way: analyzer clean on `main`.

### Imports (UNIVERSAL)

- Order: `dart:` → `package:` → relative; blank line between groups (`directives_ordering`).
- Within `lib/`, prefer `package:` imports over deep relative paths (`../../..`). Reference mixes both; new files use `package:`.
- No barrel that re-exports other layers or third-party packages (see `project-structure.md`).
- No `// ignore: depend_on_referenced_packages` — declare the dependency.

### Comments and documentation (UNIVERSAL)

- Public classes in `core/` and `domain/` get a one-paragraph `///` doc comment stating responsibility.
- Comments explain *why*, not *what*. Delete comments that restate the code.
- Reference uses `/// ----> Section` banners inside methods; acceptable, but prefer extracting a named method.
- No commented-out code blocks in merged code (reference: `old_chat_screen.dart` 1483 lines, `cubit/auth/*` 512 lines — delete, R26).

### TODOs (UNIVERSAL)

`// TODO(owner): description [ticket]`. A TODO without owner and ticket is not merged. Review TODO count per release.

### Logging and debug code (UNIVERSAL, HIGH)

- One logger (`DebugLog`) gated by `kDebugMode`; `print`/`debugPrint` forbidden in `lib/` (`avoid_print`).
- No debug UI, test credentials, or `kDebugMode ? realUrl : fakeUrl` toggles in production paths.
- Redaction rules in `security.md`.

### Dead code (UNIVERSAL)

- Unused classes, events, enums, dependencies, assets, and files are removed in the PR that orphans them.
- Periodic check: `dart run dart_code_metrics:metrics check-unused-code lib` (or `flutter analyze` `unused_element`) — reference dead items listed in R26.

### Duplication (UNIVERSAL)

Before writing: search for an existing helper/widget/model/endpoint (`rg`). Three similar lines are fine; a copied method or widget is not. Reference: duplicate widget kits, duplicate endpoint constants.

### Complexity (RECOMMENDED)

| Unit | Soft limit | Action |
|------|------------|--------|
| File | 400 lines | split by responsibility |
| Class | 300 lines | extract collaborator |
| Method / `build` | 60 lines / 100 lines | extract widget or method |
| Constructor params | 8 | group into a params object or split class |
| Cyclomatic complexity | 10 | early returns, polymorphism |

Limits are review triggers, not compile errors. Reference outliers: `common_dialogs.dart` 1224, `chat_contacts_base_cubit.dart` 758.

### `// ignore:` (UNIVERSAL)

Allowed only with a trailing reason: `// ignore: avoid_dynamic_calls — Hive returns dynamic here`. `ignore_for_file` only in generated files. Reference: ~1450 ignores, mostly generated; audit the hand-written ones.

### Generated code (UNIVERSAL)

Never hand-edit. Regenerate with `dart run build_runner build --delete-conflicting-outputs`; commit consistently (`project-structure.md`).

### Nullability (UNIVERSAL)

- Avoid `!` outside tests; use `?.`, `??`, early returns, or make the type non-nullable at the source.
- `dynamic` only at parse boundaries; never in method signatures of repositories or cubits.

## Recommended implementation

- Pre-commit hook: `dart format --set-exit-if-changed`, `flutter analyze`, `flutter test` on changed packages.
- CI: same three steps plus a grep for `print(`, secret patterns, and `Colors\.` in presentation.

## Examples

Good (reference): consistent `snake_case` files; commented `pubspec.yaml` groups; `DebugLog` abstraction.

Fix (reference): minimal lint set; 11 `print(`, 32 `debugPrint(`; commented mega-blocks; `depend_on_referenced_packages` ignores in `app_initializer.dart`.

## Anti-patterns

- Committing with analyzer warnings.
- "Temporary" `print` statements.
- Commented-out code as documentation.
- Blanket `ignore_for_file` in hand-written files.
- 1000-line utility files.

## Exceptions

Generated and vendored code is excluded from lint/complexity limits (and vendored code should not be in `lib/` at all).
