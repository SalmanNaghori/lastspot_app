# SOP: Theming and Responsive Layout

## Purpose

Keep visual decisions in one place (tokens + theme) so features stay consistent, dark mode works, and layouts survive every supported screen size.

## Scope

Design tokens, `ThemeData`, theme extensions, dark mode, breakpoints, tablets/foldables, orientation, safe areas, assets. Guardrails: UI-3, UI-27..29 (`../guardrails/ui.md`), A11Y-4.

## Principles

1. Tokens → theme → widgets. Features never pick raw values.
2. Every supported theme is a first-class target.
3. Layout responds to constraints, not to device names.

## Standard

### Tokens (UNIVERSAL, HIGH)

| Kind | Where | Example |
|------|-------|---------|
| Color palette (raw) | token file only (`$TOKENS`) | `AppPalette.blue600` |
| Semantic colors | `ColorScheme` + a `ThemeExtension` for app-specific roles | `colorScheme.primary`, `context.appColors.success` |
| Spacing / radii / sizes | spacing token class | `AppSpacing.md`, `AppRadius.card` |
| Typography | `TextTheme` built from the type scale | `context.textTheme.titleMedium` |
| Durations / curves | motion tokens | `AppMotion.short` |

Features use **semantic** roles (`colorScheme.error`), never palette entries.

### Theme (UNIVERSAL)

- One `AppTheme.light()` / `AppTheme.dark()` built from the same tokens; `MaterialApp(theme:, darkTheme:, themeMode:)`.
- App-specific roles go in `ThemeExtension`s with `lerp` so theme switches animate.
- Component themes (`FilledButtonThemeData`, `InputDecorationTheme`, …) are configured once, so shared widgets need few overrides.

### Dark mode (UNIVERSAL when supported)

- Every semantic color has a dark value; contrast meets A11Y-4 in both.
- Images/illustrations with baked-in light backgrounds have dark variants or transparent backgrounds.

### Responsive layout (UNIVERSAL)

- Breakpoints are tokens (e.g. compact < 600, medium 600–840, expanded > 840 dp, matching Material window size classes). Record which classes the app supports in `docs/project/flutter/project-rules.md` §F.
- Use `LayoutBuilder` / `MediaQuery.sizeOf(context)` and switch layout by size class (single pane → list/detail; bottom bar → navigation rail).
- No hardcoded screen-wide widths/heights; content max-width on large screens.
- Respect `SafeArea`, keyboard insets (`MediaQuery.viewInsetsOf`) and display cutouts.
- Orientation: lock only by product decision (recorded); otherwise support both.

### Assets (UNIVERSAL)

- Assets referenced through generated classes (`flutter_gen`) or one constants class — no path strings in widgets (UI-29).
- Raster images ship 1x/2x/3x; prefer vector (SVG) for icons; icon fonts/SVGs over framework icons if the design system requires it (record in §F).

## Recommended implementation

- `context.appColors`, `context.textTheme`, `context.spacing` extensions keep call sites short.
- A gallery/debug screen showing every shared widget in light/dark and at 1.0×/2.0× text scale.

## Anti-patterns

- `Color(0xFF1E88E5)` or `Colors.blue` in a feature widget.
- `if (Theme.of(context).brightness == Brightness.dark) … else …` scattered in features — put it in the theme.
- `width: 375` / `MediaQuery.of(context).size.width * 0.9` everywhere instead of constraints.

## Exceptions

Brand moments (onboarding illustrations, marketing banners) may use bespoke assets; colors still come from tokens.
