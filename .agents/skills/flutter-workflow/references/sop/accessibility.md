# SOP: Accessibility

## Purpose

Make every screen usable with a screen reader, large text, a switch/keyboard, and reduced motion — and keep it that way as features change. Accessibility is a release requirement, not a polish pass.

## Scope

Semantics, tap targets, text scaling, contrast, focus, announcements, motion. Android (TalkBack) and iOS (VoiceOver). Guardrails: `../guardrails/accessibility.md` (A11Y-*).

## Principles

1. Build on Material/Cupertino widgets — they ship semantics. Custom gestures need explicit semantics.
2. Accessibility lives in the **design tokens** (contrast, sizes) and **shared widgets** (labels, targets) so features inherit it.
3. Verify with the platform's assistive tech, not only by reading code.

## Standard

### Semantics (UNIVERSAL, HIGH)

- Icon-only buttons: `IconButton(tooltip: l10n.close, …)` — the tooltip doubles as the semantic label.
- Decorative images: `excludeFromSemantics: true`. Meaningful images: `semanticLabel`.
- Custom tappables: wrap in `Semantics(button: true, label: …, enabled: …)` or prefer `InkWell`/`TextButton` which already expose a button role.
- Group related content with `MergeSemantics` (e.g. a list tile's title + subtitle + trailing value) so it reads as one item.
- Hide duplicated text from readers with `ExcludeSemantics`.

### Targets and layout (UNIVERSAL, HIGH)

- ≥ 48×48 dp hit area (Material) / 44×44 pt (iOS). Small visuals keep a large hit area via padding or `SizedBox` around the `InkWell`.
- No `materialTapTargetSize: MaterialTapTargetSize.shrinkWrap` in shared widgets.

### Text scaling (UNIVERSAL, HIGH)

- Must work at 1.3× without overflow; must stay usable at 2.0× (wrapping, scrolling).
- Never clamp the app to 1.0. If a specific dense widget must clamp, clamp at ≥ 1.3 and document why.
- Avoid fixed heights on text containers; use `minHeight` constraints.

### Contrast and color (UNIVERSAL, HIGH)

- Token pairs (text/background, icon/background) meet 4.5:1 (normal text) and 3:1 (large text ≥ 18sp or 14sp bold, and UI components) in light **and** dark themes.
- Status/errors use color **plus** icon/text.

### Focus, keyboard and announcements (UNIVERSAL)

- Focus order follows reading order; use `FocusTraversalGroup`/`OrderedTraversalPolicy` only to fix genuine mismatches.
- On a failed form submit, move focus to the first invalid field and announce the error.
- Async results that appear off-focus (snackbars, inline banners) are announced (`SemanticsService.announce`).

### Motion (UNIVERSAL)

- Respect `MediaQuery.disableAnimationsOf(context)`: shorten or skip non-essential animations.

## Recommended implementation

- Shared widgets (`AppButton`, `AppIconButton`, `AppTextField`) take a required `semanticLabel`/`tooltip` for icon-only variants — features cannot forget it.
- Widget tests for shared widgets (TEST-3) include:

```dart
final handle = tester.ensureSemantics();
await tester.pumpWidget(...);
await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
await expectLater(tester, meetsGuideline(textContrastGuideline));
handle.dispose();
```

- Manual pass per release: TalkBack + VoiceOver through the critical journeys; system font size at max; dark mode; reduce motion on.

## Examples

Good: `IconButton(icon: AppIcons.close, tooltip: context.l10n.close, onPressed: …)`.
Bad: `GestureDetector(onTap: …, child: SvgPicture.asset(…, width: 16))` — no label, 16dp target.

## Anti-patterns

- `MediaQuery(data: …copyWith(textScaler: TextScaler.noScaling))` at the app root.
- Placeholder-only text fields (no label) — the hint disappears on input and is not always read.
- Errors shown only by turning a border red.

## Exceptions

Games / canvas-heavy views may provide an alternative accessible flow instead of per-element semantics; record it in an ADR.
