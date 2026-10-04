# Guardrails: UI

SOP: `sop/ui-architecture.md`.

**UI-1** — Widgets MUST NOT resolve services from the container (`sl<>`), call repositories, data sources or the HTTP gateway, or access storage directly. Values come from state or constructor parameters.
Check: `rg -n "sl<|AppStorage|Hive\.|GetStorage" lib/layers/presentation/ui lib/layers/presentation/commonWidgets lib/layers/presentation/shared lib/layers/presentation/auth | rg -v "BlocProvider\(|wrappedRoute|create:"` → must be empty.

**UI-2** — `build`, `initState`, `didChangeDependencies` MUST NOT contain network calls, storage access, heavy computation, decryption, or business rules.
Check: `rg -n "await .*[Rr]epository|decryptString\(|distanceBetween\(" lib/layers/presentation/ui`.

**UI-3** — Colors, spacing, radii, and text styles MUST come from the design tokens (`AppColors`, `Dimensions`, text-style extensions). `Colors.*` (except `Colors.transparent`), `Color(0x...)`, inline `TextStyle(fontSize: ...)` MUST NOT be added in feature code.
Check: `rg -n "Colors\.(?!transparent)|Color\(0x|fontSize:" lib/layers/presentation --glob '!**/core/theme/**'` → new hits are violations (reference legacy: 1769 / 169 / 186).

**UI-4** — Before creating a widget, the shared widget folders MUST be searched. A new widget that duplicates an existing button, text field, loader, toast, sheet, avatar, or network image wrapper MUST NOT be added.
Check: `rg -l "class \w*(Button|TextField|Loader|Loading|NetworkImage|Avatar)\w* extends" lib/layers/presentation lib/layers/core/widgets` and compare with new classes in the PR.

**UI-5** — User-facing strings MUST come from the string constants class or localization; `Text('literal')` MUST NOT be added in feature code.
Check: `rg -n "Text\(\s*'[A-Za-z]" lib/layers/presentation --glob '!**/app_string*.dart'` → new hits are violations.

**UI-6** — Every data-driven screen MUST render loading, error (with retry), empty, and no-internet states. A screen that renders only the success state MUST NOT be merged.

**UI-7** — Exactly one loading indicator style MUST be used per state: blocking overlay (`EasyLoading`) from a listener **or** inline loader from the builder — never both for the same status.

**UI-8** — Server-backed lists MUST use builder-based lazy lists (`ListView.builder`, slivers) and MUST be paginated. Items with per-item state MUST have stable `Key`s.
Check: `rg -n "ListView\(\s*children:" lib/layers/presentation/ui` → review.

**UI-9** — Files under `presentation/` SHOULD stay under 400 lines and `build` methods under 100 lines; a screen SHOULD NOT provide more than ~8 Cubits directly.
Check: `wc -l` on changed files; count `BlocProvider(` in `wrappedRoute`.

**UI-10** — Fully commented-out widgets/screens MUST NOT exist in the tree.
Check: files with zero non-comment code lines.

**UI-11** — Controllers (`TextEditingController`, `ScrollController`, `AnimationController`, `FocusNode`) and observers registered in `State` MUST be disposed/removed in `dispose()`.
Check: files declaring these controllers must contain `dispose()` calling `.dispose()`/`removeObserver`/`removeListener`.

**UI-12** — Widgets MUST NOT use `Future.delayed` to wait for another component (router, cubit, plugin) to become ready.
Check: `rg -n "Future.delayed" lib/layers/presentation/ui` → review each; only intentional UX delays with a named constant are allowed.

**UI-13** — Network images MUST go through the project image wrapper; raw `Image.network` / unwrapped `CachedNetworkImage` MUST NOT be added.
Check: `rg -n "Image\.network\(|CachedNetworkImage\(" lib/layers/presentation --glob '!**/my_network_image*.dart' --glob '!**/core/widgets/**'`.

**UI-14** — Widgets MUST NOT depend on a global `BuildContext` (`GlobalVariable.appContext`) for sizing or theming; use the local `context`.
Check: `rg -n "appContext" lib/layers/presentation`.

## Reference project status

Tracked: R14 (`sl<>` in widgets), R17 (god files), R20 (duplicate kits), R21 (hardcoded colors), R23 (`Future.delayed`), R26 (`old_chat_screen.dart`), ND-6 (l10n), ND-7 (loader style).
