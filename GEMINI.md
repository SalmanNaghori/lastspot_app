# LastSpot Project Rules

These rules govern all UI and logic code generated for the LastSpot Flutter project. **Violation of any rule is NOT acceptable.**

## 1. Flutter Version Management (FVM)
1. ALWAYS use `fvm flutter` instead of `flutter` for all CLI commands.
2. ALWAYS use `fvm dart` instead of `dart` for all CLI commands.
3. DO NOT run standard `flutter pub get` or `flutter run`. ALWAYS prefix with `fvm`.
4. The required Flutter version for this project is strictly defined in the `.fvmrc` file (currently `stable`).

## 2. Responsive Layout
Every screen MUST use `ResponsiveLayout` to provide separate mobile and tablet views. A screen is composed of 3 files:
- `[screen].dart` (parent with state, returns ResponsiveLayout)
- `[screen]_mobile.dart` (mobile-specific StatelessWidget)
- `[screen]_tablet.dart` (tablet-specific StatelessWidget)

## 3. No Hardcoded Dimensions
NEVER use raw double literals for padding, margin, font size, or border radius. ALWAYS use the `Dimensions` class with responsive suffixes:
- `Dimensions.r16.dynamicW` (widths, horizontal padding)
- `Dimensions.r16.dynamicH` (heights, vertical padding, icons)
- `Dimensions.r16.dynamicSP` (font sizes)
- `Dimensions.r12.dynamicR` (border radii)

## 4. No Hardcoded Colors
NEVER use standard `Colors.*` or hex color literals. ALWAYS use `context.surfaceColor` / `context.primaryColor` / `context.textPrimary` via extensions on BuildContext (`ThemeColors` from `app_color.dart`) for System Theme compatibility. This ensures that colors automatically adapt when the theme changes from the app side.
- Example: `context.primaryColor`, `context.textPrimary`

## 5. No Hardcoded Strings
NEVER embed user-facing text directly in widget code. ALWAYS add strings to `lib/core/l10n/intl_en.arb` and access via `AppLocalizations.of(context)`. No redundant static string helper files.

## 6. Architecture & State Management
- **Feature-first Clean Architecture:** `lib/features/<feature_name>/` (data, domain, presentation).
- **State Management:** Use `flutter_bloc` for business logic, global state, and async operations. Use `ValueNotifier` for local UI state (toggles, loading spinners) instead of `setState`. DO NOT use `setState` unless absolutely required for trivial UI interactions that cannot be easily solved with `ValueNotifier`.

## 7. UI Components & DRY
NEVER write private widget classes (`_MyWidget`) inside a screen file if it can be reused. ALWAYS extract every reusable widget into its OWN public file inside `lib/features/[feature]/presentation/widgets/`.
**Avoid widget-building methods** (e.g., `Widget _buildRow() { ... }`). ALWAYS create separate `StatelessWidget` or `StatefulWidget` classes instead. This improves performance (via `const` constructors) and maintains a clean widget tree.

## 8. Material 3 & ThemeMode
- `ThemeData(useMaterial3: true)` must be set at the app root.
- The app MUST support `ThemeMode.system` using `ThemeData.light()` and `ThemeData.dark()`.

## 9. Supabase Edge Functions
Sensitive operations (joining a match, decrementing open slots, preventing race conditions, post expiry validation) must execute via Supabase Edge Functions (RPC), never directly via client DB writes.

## 10. App Constants
Use `AppConstants` (from `lib/core/constants/app_constants.dart`) where required, instead of hardcoding constant values like versions, support emails, platform checks, or global configs.

## 11. No Inline Function Execution Logic in Widget Tree
NEVER write multiline function or callback logic directly inside widget trees (e.g. `onPressed: () { ... }`).
ALWAYS extract callback logic into dedicated, private helper methods (e.g. `_onNotificationTap()`, `_onClearAllPressed()`) and call the method in the widget callback.
