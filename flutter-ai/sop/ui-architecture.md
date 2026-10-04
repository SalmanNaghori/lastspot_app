# SOP: UI Architecture

## Purpose

Screens that are thin, widgets that are reusable, design values that come from one place, and loading/error/empty states that look the same everywhere.

## Scope

Screens, widgets, shared components, theme and design tokens, responsive layout, loading/error/empty UI, forms, lists, dialogs/sheets, images, localization.

## Principles

1. A screen composes; it does not compute.
2. Extract a widget when it is reused, when it has its own state, or when `build` exceeds ~100 lines — not before.
3. Every color, spacing, radius, text style comes from the design system.
4. One component per job: one button family, one text field family, one loader, one toast, one sheet helper.
5. Strings shown to users are never literals in widget code.

## Standard

### What belongs where (UNIVERSAL, HIGH)

| Concern | Screen | Widget | Cubit/Bloc | Domain |
|---------|--------|--------|------------|--------|
| Provide state holders (route wrapper) | ✓ | | | |
| Listen for side effects (navigate, toast, loader) | ✓ | | | |
| Layout composition | ✓ | ✓ | | |
| Render a piece of state | | ✓ | | |
| Decide loading/error/empty | | | ✓ (status) | |
| Filtering, sorting, distance checks, validation rules | | | ✓ | ✓ (policy) |
| Decrypt, format dates/currency | | | ✓ / UI model | |
| API / storage access | | | | via repository |

### Screen and widget paths (UNIVERSAL)

| Kind | Feature First | Layer First |
|------|---------------|-------------|
| Routed screen | `lib/features/<x>/views/<x>_screen.dart` | `lib/layers/presentation/ui/<x>/<x>_screen.dart` |
| Feature widgets | `lib/features/<x>/widgets/` | `lib/layers/presentation/ui/<x>/widgets/` |
| Shared / design-system widgets | `lib/shared/widgets/` | `lib/layers/core/widgets/` (or `presentation/commonWidgets` for domain-aware) |

Views compose; they do not call services. Extracted widgets stay in the same feature's `widgets/` folder.

### Screen template (UNIVERSAL)

State-holder names below (`FooCubit`, `BlocProvider`) follow a Bloc project. On a Riverpod project, the same screen lives in `views/` and the holder lives in `controller/`.

```dart
@RoutePage()
class FooScreen extends StatelessWidget implements AutoRouteWrapper {
  const FooScreen({super.key, required this.fooId});
  final String fooId;

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider(create: (_) => sl<FooCubit>()..load(fooId), child: this);

  @override
  Widget build(BuildContext context) {
    return BlocListener<FooCubit, FooState>(
      listenWhen: (p, c) => p.status != c.status && c.status == Status.failure,
      listener: (context, state) => AppToast.show(state.error),
      child: Scaffold(
        appBar: const AppBarPrimary(title: 'Foo'),
        body: BlocBuilder<FooCubit, FooState>(
          builder: (context, state) => StateView(
            status: state.status,
            isEmpty: state.items.isEmpty,
            onRetry: context.read<FooCubit>().load,
            child: FooList(items: state.items),
          ),
        ),
      ),
    );
  }
}
```

- `StatelessWidget` unless the screen owns controllers/observers.
- Initial load in the route wrapper (`..load()`), or `initState` when it depends on widget lifecycle.
- A shared **state-render widget** (`StateView`: loading / error+retry / empty / content) is RECOMMENDED; the reference project lacks one and repeats `if (status == ...)` in every screen.

### Widget extraction (UNIVERSAL)

Extract when: reused in 2+ places; has local state; `build` > ~100 lines; needs its own `BlocSelector`. Do **not** extract single-use 10-line fragments into separate files ("widget fragmentation"). Prefer private widget classes over builder methods for rebuild scoping.

### Shared components (UNIVERSAL, HIGH)

| Kind | One family, in the design-system folder |
|------|------------------------------------------|
| Buttons | primary / secondary / text / icon variants of **one** widget |
| Text fields | one base + thin variants |
| Loader | one inline loader; one blocking-overlay helper |
| Toast / snackbar | one helper |
| Bottom sheet / dialog | one `showAppSheet` / `showAppDialog` helper |
| Network image | one wrapper over `CachedNetworkImage` (+ avatar variant) |
| App bar | one |
| Empty / error views | one each |

Before creating a widget: search the shared folders. The reference project has 5 button widgets, 4 text fields, 3 loaders, 4 image paths (ANTI-PATTERN, R20).

### Design tokens (UNIVERSAL, HIGH)

- `AppColors`, `Dimensions`/spacing scale, radius scale, `AppTextStyles`/text extensions, `ThemeData` built from them.
- No `Colors.*`, `Color(0x...)`, `fontSize:`, `TextStyle(...)`, magic `EdgeInsets` numbers in feature code. Reference: 1769 `Colors.*` + 169 `Color(0x` (ANTI-PATTERN, R21). Exception: `Colors.transparent`.
- One theme stack. Remove unused parallel stacks (reference: `AppTheme/LightTheme/DarkTheme` unused).

### Responsive (RECOMMENDED)

- `LayoutBuilder`/`MediaQuery.sizeOf` at the screen level; breakpoints in one constants file.
- A base responsive view is OPTIONAL and only useful if breakpoints produce different layouts; returning the same widget for every breakpoint (reference `BaseResponsiveViewFull` usage) is LEGACY noise.
- No pixel-scaling packages unless the design system mandates it.

### Forms (RECOMMENDED)

- `Form` + `TextFormField` with `validator`s **or** Cubit-side validation exposing field errors in state — one approach per project. Reference uses imperative checks + toast (NEEDS-DECISION); default for new forms: Cubit-side validation with `fieldErrors` map in state.
- Validation regexes centralised (`RegExpressions`).

### Lists (UNIVERSAL)

- `ListView.builder` / `SliverList` for anything unbounded or > ~20 items.
- Stable `Key`s (`ValueKey(item.id)`) for reorderable/animated lists and lists with per-item state.
- Pagination trigger via scroll threshold in a controller or `scrollview_observer`; the Cubit decides whether to load.

### Dialogs / sheets (UNIVERSAL)

Helpers only; pass Cubits with `BlocProvider.value`; sheet content is a widget class, not an inline closure > 30 lines.

### Images and icons (UNIVERSAL)

- Network: the project wrapper only. Asset: `Image.asset` with constants (`AppImage`). SVG via `flutter_svg` if used; icon fonts acceptable (reference: `MyCustomIcon`).
- Provide `width/height` or `cacheWidth` for large images.

### Strings and localization (RECOMMENDED)

- L1/L2 single-language: constants class (`AppStrings`). L2+ multi-language or any product with i18n roadmap: `flutter_localizations` + `.arb` + `AppLocalizations`.
- Never `Text('literal')` in feature code. Reference: `AppString` + ~100 literals (NEEDS-DECISION ND-6).

## Recommended implementation

- Create a shared state-render widget (`state_view.dart`: loading/error/empty/content) in `lib/shared/widgets/` (Feature First) or `core/widgets/` (Layer First).
- Add a lint or CI grep failing new `Colors\.` / `Color\(0x` in feature UI folders outside the theme folder.

## Examples

Good (reference): `orbit_list_tab.dart` — composes `SearchWidget`, `CategoriesBar`, `AvailableOrbitList`; listeners handle side effects; `wrappedRoute` scoping in `orbit_detail_screen.dart`.

Fix (reference): `join_orbit_section.dart:70-90` distance check in widget; `all_contacts_screen.dart:179-233` filtering in screen; `login_screen.dart:236-285` validation in screen; `common_dialogs.dart` 1224 lines.

## Anti-patterns

- `sl<>()` in widgets.
- Business logic or `await repository...` in `build`/`initState`.
- Widgets > 500 lines; screens providing 30 cubits.
- Duplicated components with `My`/`Custom` prefixes.
- `EasyLoading.show()` and an inline spinner for the same state.
- Hardcoded colors, sizes, strings.
- Fully commented-out legacy screens kept in tree (`old_chat_screen.dart`).

## Exceptions

Platform-specific views (maps, camera, video) may exceed size guidance when the plugin API forces it; split into a controller + view where possible and document the exception in the file header.
