# Guardrails: UI

SOP: `sop/ui-architecture.md`.

**UI-1** — Widgets MUST NOT resolve services from the container (`$LOOKUP`, e.g. `sl<>` with get_it), call repositories, data sources or the HTTP gateway, or access storage directly. Values come from state or constructor parameters.
Check: `rg -n "$LOOKUP|$STORAGE" $UI | rg -v "$ROOT_ALLOW"` → must be empty.

**UI-2** — `build`, `initState`, `didChangeDependencies` MUST NOT contain network calls, storage access, heavy computation, decryption, or business rules.
Check: `rg -n "await .*[Rr]epository|decrypt\w*\(|distanceBetween\(|jsonDecode\(" $UI` → review.

**UI-3** — Colors, spacing, radii, and text styles MUST come from the project's design tokens (colors, spacing, radii, typography — names recorded in `docs/project/flutter/project-rules.md` §F). `Colors.*` (except `Colors.transparent`), `Color(0x...)`, inline `TextStyle(fontSize: ...)` MUST NOT be added in feature code.
Check: `rg -nP "Colors\.(?!transparent)|Color\(0x|fontSize:|EdgeInsets\.(all|only|symmetric|fromLTRB)\(\s*\d" $PRES` → new hits are violations (tokens live in `$TOKENS`).

**UI-4** — Before creating a widget, the shared widget folders MUST be searched. A new widget that duplicates an existing button, text field, loader, toast, sheet, avatar, or network image wrapper MUST NOT be added.
Check: `rg -l "class \w*(Button|TextField|Loader|Loading|NetworkImage|Avatar|Sheet|Dialog)\w* extends" lib` and compare with new classes in the PR.

**UI-5** — User-facing strings MUST come from the project string source (`docs/project/flutter/project-rules.md` PR-F2: l10n or constants class); `Text('literal')` MUST NOT be added in feature code.
Check: `rg -n "Text\(\s*'[A-Za-z]|(label|hint|title)Text:\s*'[A-Za-z]" $PRES` → new hits are violations. See also `localization.md`.

**UI-6** — Every data-driven screen MUST render loading, error (with retry), empty, and no-internet states. A screen that renders only the success state MUST NOT be merged.

**UI-7** — Exactly one loading indicator style MUST be used per state: blocking overlay (the project's overlay loader) from a listener **or** inline loader from the builder — never both for the same status.

**UI-8** — Server-backed lists MUST use builder-based lazy lists (`ListView.builder`, slivers) and MUST be paginated. Items with per-item state MUST have stable `Key`s.
Check: `rg -n "ListView\(\s*children:" $UI` → review.

**UI-9** — Files under `presentation/` SHOULD stay under 400 lines and `build` methods under 100 lines; a screen SHOULD NOT provide more than ~8 Cubits directly.
Check: `wc -l` on changed files; count providers in the route wrapper.

**UI-10** — Fully commented-out widgets/screens MUST NOT exist in the tree.
Check: files with zero non-comment code lines.

**UI-11** — Controllers (`TextEditingController`, `ScrollController`, `AnimationController`, `FocusNode`) and observers registered in `State` MUST be disposed/removed in `dispose()`.
Check: files declaring these controllers must contain `dispose()` calling `.dispose()`/`removeObserver`/`removeListener`.

**UI-12** — Widgets MUST NOT use `Future.delayed` to wait for another component (router, cubit, plugin) to become ready.
Check: `rg -n "Future.delayed" $UI` → review each; only intentional UX delays with a named constant are allowed.

**UI-13** — Network images MUST go through the project image wrapper; raw `Image.network` / unwrapped `CachedNetworkImage` MUST NOT be added.
Check: `rg -n "Image\.network\(|CachedNetworkImage\(" $PRES` → only inside the image wrapper.

**UI-14** — Widgets MUST NOT depend on a global `BuildContext` (e.g. a static `appContext` / `navigatorKey.currentContext`) for sizing or theming; use the local `context`.
Check: `rg -n "appContext|navigatorKey\.currentContext" $PRES`.

## Forms

**UI-24** — Form validation rules MUST live in the state holder or a pure validator (testable without widgets); widgets only display field errors from state (see ERR-7).

**UI-25** — Text fields MUST declare `keyboardType`, `textInputAction`, and `autofillHints` where applicable; submit buttons MUST be disabled (or show progress) while a submission is in flight to prevent double submits.

**UI-26** — Sensitive fields (passwords, OTP, card data) MUST set `obscureText` / `enableSuggestions: false` / `autocorrect: false` as appropriate and MUST NOT be stored in state longer than the submission.

## Theming and responsive layout

**UI-27** — Colors MUST be read from the theme (`Theme.of(context)` / `ColorScheme` / theme extensions) so light and dark themes both work; a screen that is unreadable in either supported theme MUST NOT be merged.

**UI-28** — Layouts MUST NOT assume a fixed screen size: no hardcoded full-screen widths/heights; use constraints (`LayoutBuilder`, `Flexible`, breakpoints from the tokens). Screens MUST survive the smallest supported phone and, if tablets are supported, the documented breakpoints.

**UI-29** — Hardcoded asset path strings MUST NOT appear in widgets; use the project's asset constants or generated asset class.
Check: `rg -n "'assets/" $PRES` → must be empty.

Accessibility guardrails (semantics, tap targets, text scale, contrast): `accessibility.md`.
