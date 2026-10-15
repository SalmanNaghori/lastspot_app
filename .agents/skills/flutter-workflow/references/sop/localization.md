# SOP: Localization (i18n / l10n)

## Purpose

One source of truth for user-facing text and locale-aware formatting, so adding a language is a translation task — not a code change.

## Scope

String source, ARB files, plurals/select, dates/numbers/currency, RTL, locale switching, server-provided text. Guardrails: `../guardrails/localization.md` (I18N-*). Decision: `docs/project/flutter/project-rules.md` PR-F2 / ND-5.

## Principles

1. Widgets never contain user-facing literals.
2. Grammar (plural, gender) is the translator's job — express it in ICU messages, not in Dart conditionals.
3. Formatting follows the user's locale, not the developer's.

## Standard

### Choosing the string source (ND-5)

| App | Choice | Classification |
|-----|--------|----------------|
| L1/L2, single language, no i18n roadmap | constants class (`AppStrings`) | OPTIONAL |
| Any multi-language app or i18n on the roadmap | `flutter_localizations` + `gen-l10n` + `.arb` | RECOMMENDED |

Moving from constants to ARB later is mechanical **only if** every string already lives in one class — so I18N-1 applies to both.

### gen-l10n setup (RECOMMENDED)

```yaml
# l10n.yaml
arb-dir: lib/core/l10n          # or the project's path (PR-A6 $STRINGS)
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
untranslated-messages-file: build/untranslated.json
nullable-getter: false
```

- `pubspec.yaml`: `flutter: generate: true`; `flutter_localizations` from the SDK; `intl` pinned to the SDK-compatible version.
- `MaterialApp(localizationsDelegates: AppLocalizations.localizationsDelegates, supportedLocales: AppLocalizations.supportedLocales)`.
- Access through an extension: `context.l10n.loginTitle`.

### Keys and messages (UNIVERSAL)

- Keys: `lowerCamelCase`, prefixed by feature: `checkoutPayButton`, `profileEditTitle`. Shared: `commonRetry`, `commonCancel`.
- Every key has `@key.description` (context for translators) and typed `placeholders`.
- Plurals: `"cartItems": "{count, plural, =0{Cart is empty} =1{1 item} other{{count} items}}"`.
- Never concatenate translated fragments (`l10n.hello + name`); use placeholders.

### Formatting (UNIVERSAL)

- `DateFormat.yMMMd(locale)`, `NumberFormat.currency(locale: …, name: currencyCode)`, `NumberFormat.compact`.
- Currency comes from the data (ISO code), not from the device locale.
- Times respect `MediaQuery.alwaysUse24HourFormatOf(context)`.

### RTL (UNIVERSAL when an RTL locale is supported)

- `EdgeInsetsDirectional`, `AlignmentDirectional`, `PositionedDirectional`, `TextAlign.start`.
- Directional icons (back, forward, chevrons) mirror; logos and media controls do not.

### Server text

- Prefer the API returning localized text (send `Accept-Language`).
- Enum-like server codes map to ARB keys in the presentation layer; unknown codes fall back to a generic string.

### Failures

- `Failure` carries a `kind`; the UI maps `kind → l10n` (ERR-4). Repositories never build localized text.

## Recommended implementation

- CI step: `flutter gen-l10n` and fail if `build/untranslated.json` lists missing keys for shipped locales.
- A pseudo-locale (e.g. `en_XA`, elongated + accented) during development exposes truncation and hardcoded strings.

## Anti-patterns

- `Text('Save')`, `SnackBar(content: Text('Something went wrong'))`.
- `'${count} item${count == 1 ? '' : 's'}'`.
- `DateFormat('dd/MM/yyyy')` for display to users in several countries.

## Exceptions

Developer-only debug screens behind `kDebugMode` may use literals.
