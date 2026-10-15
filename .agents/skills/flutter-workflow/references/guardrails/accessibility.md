# Guardrails: Accessibility

SOP: `sop/accessibility.md`. Target: WCAG 2.2 AA as applied to mobile (Android TalkBack, iOS VoiceOver).

**A11Y-1** — Every icon-only or image-only interactive control MUST expose a semantic label (`tooltip`, `semanticLabel`, or `Semantics(label:)`) from the string source.
Check: `rg -n "IconButton\(" $PRES` → each has `tooltip:` or a `Semantics` ancestor; `rg -n "Image\.(asset|network)\(|SvgPicture" $PRES` → decorative ones use `excludeFromSemantics: true`.

**A11Y-2** — Interactive targets MUST be at least 48×48 dp (Material) / 44×44 pt (iOS). Shrinking below via `visualDensity`, `materialTapTargetSize: shrinkWrap`, or tiny `GestureDetector`s MUST NOT be added.
Check: `rg -n "shrinkWrap|VisualDensity\.compact|GestureDetector\(" $PRES` → review.

**A11Y-3** — Screens MUST render without overflow or clipped text at 1.3× text scale and remain usable at 2.0×. `textScaler`/`textScaleFactor` MUST NOT be clamped app-wide to 1.0.
Check: `rg -n "textScaleFactor:\s*1|TextScaler\.noScaling|TextScaler\.linear\(1" lib` → must be empty (except documented, bounded clamps ≥ 1.3).

**A11Y-4** — Text and essential icons MUST meet contrast ≥ 4.5:1 (normal text) / 3:1 (large text, UI components) in every supported theme. Contrast is a property of the design tokens and is checked when tokens change.

**A11Y-5** — Information MUST NOT be conveyed by color alone (errors, status, selection); pair color with text, icon, or shape.

**A11Y-6** — Custom controls (custom checkboxes, toggles, sliders, tappable cards) MUST expose role and state via `Semantics` (`button`, `toggled`, `checked`, `selected`, `enabled`) and MUST be reachable and operable with a screen reader and an external keyboard (focus order follows visual order).

**A11Y-7** — Dynamic changes that matter (form errors, async results, snackbars) MUST be announced (`SemanticsService.announce` or live regions) and focus MUST move to the first invalid field on failed submit.

**A11Y-8** — Motion: non-essential animations MUST respect `MediaQuery.disableAnimationsOf(context)` / reduce-motion; nothing may flash more than 3 times per second.

Verification: accessibility section of `checklists/pr-review.md`; Flutter's `meetsGuideline(androidTapTargetGuideline | iOSTapTargetGuideline | labeledTapTargetGuideline | textContrastGuideline)` in widget tests for shared widgets (TEST-3).
