# LastSpot design refresh — 8 October 2026

LastSpot connects people through local sports and activities. Its core journeys are discover → view → request to join and create → manage requests → play. The existing app uses Flutter, BLoC/Cubit, GoRouter and Supabase, with feature-first presentation/domain/data folders and shared widgets in `lib/core`.

This update improves discovery and shared interactions within that structure. The design takes cues from [Material 3's motion guidance](https://m3.material.io/styles/motion): clear visual emphasis and brief, purposeful transitions. It retains the project's typography, sports imagery and green identity.

## Changes

- Deeper emerald branding, separate page/card surfaces, explicit surface-container colors and adaptive dark colors.
- Rounded bottom navigation with an emphasized Create action and selected destination indicators.
- Home greeting banner with a working Find a game action and a keyboard-accessible city action.
- Shared activity cards used by Home and Explore: clearer headings, wrapping metadata, capacity indicator, host identity, themed badges and press feedback. Existing image Hero tags and detail navigation remain connected.
- Nearby cards use a lazy vertical list instead of a fixed-height carousel, allowing the card to grow with larger text.
- Shared confirmation dialogs animate with fade and scale; explicit confirm/cancel results remain typed. Logout on both mobile and tablet uses the same dialog. Destructive actions use the error color.
- Sheets use native drag handles, safe areas, keyboard insets and shared transition timings.
- The shared entrance wrapper, confirmation dialog, sheet, button and card transitions honor reduced-motion settings. Other pre-existing animation implementations are outside this pass.
- Refresh awaits the actual data request. Older home requests cannot replace newer city results or emit after disposal.
- Coming up now contains chronologically sorted activities at least 24 hours away. It intentionally overlaps the nearby collection; nearby is a location grouping, while coming up is a time grouping.
- Cancelled, completed, expired and draft activities are excluded from home discovery. Full future games remain visible.
- Host initials safely handle blank names and repeated spaces.

## Files and reuse

New production file: `lib/core/theme/app_motion.dart`, centralizing motion values and the reduced-motion duration policy.

Modified shared files: `app_color.dart`, `app_theme.dart`, `app_utils.dart`, `widget_animation.dart`, `authenticated_app_shell.dart`, `app_bottom_sheet.dart`, `app_button.dart`, `app_dialog.dart`.

Modified feature files: `home_cubit.dart`, `home_screen.dart`, `activity_card.dart`, `home_greeting_banner.dart`, `spot_hero_image.dart`, `spot_host_avatar.dart`, and the mobile/tablet profile screens.

Strings were added to `intl_en.arb`; both generated localization files were regenerated with `fvm flutter gen-l10n`.

Searches covered `showConfirmation`, `showDialog`, `AppBottomSheet`, `HomeGreetingBanner`, `ActivityCard`, `comingUp`, route/provider wiring and the existing use cases/repository interfaces. Existing buttons, sheets, image caching, Hero tags, routes, typography, radii and spacing tokens were extended instead of adding parallel components.

Dependencies: none added or upgraded. Architecture: unchanged. No database changes. Existing untracked helper scripts were left untouched.

## Verification

Six test files mirror the production paths, with a shared test harness. They use the existing `flutter_test` dependency and in-memory fakes:

- `test/core/widgets/dialogs/app_dialog_test.dart`: confirmation, cancellation, barrier dismissal and accessible layouts.
- `test/core/widgets/buttons/app_button_test.dart`: loading protection and destructive styling.
- `test/core/widgets/animation/widget_animation_test.dart`: reduced-motion behavior.
- `test/core/widgets/bottom_sheets/app_bottom_sheet_test.dart`: typed results and reopening.
- `test/features/spot/presentation/widgets/activity_card_test.dart`: banner/card interactions, capacity display, duplicate tap suppression, 320/800 logical-pixel widths, 200% text scale and both color schemes.
- `test/features/spot/presentation/bloc/home_cubit_test.dart`: upcoming regression, lifecycle visibility, offline/server errors, recovery, stale-request suppression and disposal safety. Success, offline/recovery and server-error tests assert the emitted state sequence and stream completion.
- `test/support/widget_test_app.dart`: shared localization, sizing and theme harness; extracted to avoid repeating test setup.

17 tests pass. Changed Dart files are formatted. `git diff --check` passes. Full analysis reports 26 existing findings (baseline: 28), with no new findings. The two removed findings were unused imports in touched code.

These are component and state tests, not a signed-in device or backend integration run. Native builds, real authentication, live create/join/chat operations and performance profiling were not run. FVM emits a kernel snapshot warning but successfully invokes the pinned Flutter 3.47.5 SDK.

## Compliance review

This review follows [`agent.md`](../agent.md), including reuse evidence, verification, the full 40-row checklist and explicit unresolved requirements. The earlier grouped table overstated compliance and is replaced below.

The root `project/` directory is empty; `flutter-ai/project/` contains generic `_TBD_` stubs. The README and `.agents/rules/lastspot_master_spec.md` describe the existing feature-first Flutter/BLoC/GoRouter/Supabase app. Keeping that implementation for the authorized design task does **not** establish approved ADRs or fill in the missing governance decisions. No migration or new architectural choice was made. Template references to AutoRoute, MyAppTheme and non-localized AppString conflict with the concrete app conventions and need reconciliation in the project profile before an architectural change.

| # | Area | Result | Evidence |
| --- | --- | --- | --- |
| 1 | Layers | PRE-EXISTING | ARCH-3: core utility/shell imports feature code; unchanged architecture. |
| 2 | UI-free domain/data | N/A | No domain/data changes. |
| 3 | Widget dependencies | PRE-EXISTING | UI-1/DI-2: shell container lookup and Home session reads remain. |
| 4 | Logic placement | PRE-EXISTING | ARCH-5: existing widget-side availability/formatting; new feed filtering stays in HomeCubit. |
| 5 | Abstractions | N/A | No new repository, interface or use case. |
| 6 | Structure | PASS | Same feature tree; localization regenerated; test paths now mirror sources. |
| 7 | DI lookups in holders | PASS | No new container lookup. |
| 8 | DI registrations | N/A | No registration changes. |
| 9 | Dependencies | PASS | Attempted test-package addition failed atomically; pubspec and lockfile unchanged. |
| 10 | State paradigm | PASS | Existing BLoC/Cubit retained. |
| 11 | State shape | PRE-EXISTING | STATE-3/4: existing HomeSuccess error flags and Equatable hierarchy unchanged. |
| 12 | Emit safety | PASS | Generation and closed guards added to load; city reload guarded after await. |
| 13 | Holder purity | PASS | HomeCubit has no UI imports or context. |
| 14 | Subscriptions | PASS | No new subscriptions/controllers/timers. |
| 15 | Events | N/A | No Bloc events changed. |
| 16 | Side effects | PASS | New navigation/dialog callbacks stay at the UI edge. |
| 17 | Pagination | N/A | Existing feed query contract retained; no new server list. |
| 18 | Networking | N/A | No gateway or transport change. |
| 19 | TLS/tokens | N/A | No TLS/auth transport change. |
| 20 | Repository contract | N/A | No repository change. |
| 21 | Catch discipline | PRE-EXISTING | ERR-3: silent city-save catch and URL utility catch remain. |
| 22 | Global handlers | N/A | No handler changes. |
| 23 | Logging | PRE-EXISTING | ERR-6: existing utility/data-source logging remains; Home build debug logs removed. |
| 24 | Models | N/A | No model change; root Freezed ADR is still Proposed. |
| 25 | Routing | PRE-EXISTING | ROUTE-1/2: existing centralized GoRouter string paths retained; template expects generated routes. |
| 26 | Deep links | N/A | No payload or guard change. |
| 27 | UI states | PASS | Existing loading, retry, empty and offline branches retained. |
| 28 | Design tokens | PRE-EXISTING | New styling uses theme tokens; older inline styles in touched screens remain. |
| 29 | Shared widgets | PASS | Existing dialog/button/sheet/image wrappers extended. |
| 30 | Strings | PRE-EXISTING | New strings localized; older Home/shell literals remain. |
| 31 | Widget hygiene | PRE-EXISTING | UI-9: existing Home build/file size and builder methods remain. |
| 32 | Performance | PASS | Lazy card list and stable keys; no new heavy build computation. |
| 33 | Async | PRE-EXISTING | New fetch generation/disposal guards pass; older dropped futures remain in UI callbacks. |
| 34 | Tests | FAIL | Behavioral tests pass; required bloc_test cannot resolve with the pinned dependency graph. See unresolved requirement below. |
| 35 | Security config | N/A | No configuration change. |
| 36 | Security storage | N/A | No storage change. |
| 37 | Build | N/A | No native build/signing change. |
| 38 | Scope | PASS | Discovery/shared interactions, related tests and reporting only. |
| 39 | ADR/project rules | PRE-EXISTING | ARCH-7: project profile is unfilled; observed structure is not an approved ADR. |
| 40 | Existing violations | PASS | Recorded separately below; no claim of repository-wide compliance. |

Summary: PRE-EXISTING: 12, N/A: 14, PASS: 13, FAIL: 1. This is not a clean-compliance sign-off.

### Unresolved test-package requirement

`flutter-ai/guardrails/testing.md` TEST-1 requires `bloc_test`; TEST-11 places the test packages under dev dependencies. The attempted command was `fvm flutter pub add dev:bloc_test dev:mocktail`.

The resolver failed: Flutter pins `test_api` to 0.7.12 and `matcher` to 0.12.20, while Freezed 4.0.2 requires analyzer 14. Compatible `test` versions needed by `bloc_test` cannot satisfy this graph; older alternatives also conflict with Supabase's realtime dependency. Neither `pubspec.yaml` nor `pubspec.lock` changed. No overrides, SDK changes or generator downgrades were applied.

The existing test suite remains runnable and now asserts state-emission sequences explicitly using Flutter test matchers. This improves coverage but is **not** recorded as satisfying the package-specific rule or as an approved exception. Resolution requires either a compatible test/SDK/generator combination or an explicitly accepted exception. No exception has been approved.

### Recorded violations

Each item below refers to code already present before the redesign, except the test-rule gap explicitly identified as introduced.

- **ARCH-3 / DI-2 / UI-1 — PRE-EXISTING**: `lib/core/utils/app_utils.dart` imports CityCubit; `lib/core/widgets/authenticated_app_shell.dart:27` resolves NotificationsCubit; `lib/features/spot/presentation/pages/home_screen.dart` reads the Supabase session. Fix: supply values through state/provider composition. No exception recorded.
- **STATE-3/4 — PRE-EXISTING**: `lib/features/spot/presentation/bloc/home_state.dart` uses separate error flags. Fix: a separately scoped migration to the chosen state shape. No exception recorded.
- **ERR-3 — PRE-EXISTING**: `lib/features/spot/presentation/bloc/home_cubit.dart:188` silently catches city-save failures; `lib/core/utils/app_utils.dart:50` has an empty URL-launch catch. Fix: expose a typed failure and present an actionable UI error. No exception recorded.
- **ERR-6 — PRE-EXISTING**: utility/data-source print/debug logging is reported by the existing analyzer baseline. Fix: the project's logging helper without sensitive payloads. No exception recorded.
- **UI-3/UI-5/UI-9 — PRE-EXISTING**: `lib/features/spot/presentation/pages/home_screen.dart` retains older inline styles, literals and long widget-builder methods. Fix: migrate those existing pieces to localized shared widgets in a scoped follow-up. No exception recorded.
- **ARCH-7 — PRE-EXISTING**: `flutter-ai/project/README.md` and `project-rules.md` still have `_TBD_` architecture fields. Fix: record actual approved project decisions, without copying the reference profile. No approval or ADR inferred from repository history.
- **TEST-1 — INTRODUCED, UNRESOLVED**: `test/features/spot/presentation/bloc/home_cubit_test.dart` covers the changed Cubit with Flutter tests instead of the mandated `bloc_test`. Fix: resolve the dependency incompatibility or obtain an explicit test-tool exception. No exception recorded; behavioral tests passing does not clear this rule.

The initial README also records backend/schema alignment gaps; live backend behavior is not determinable from repository evidence. Existing analyzer findings remain separate from this change's verification.

Remaining product limitations: Home category chips still navigate to Explore without passing the selected category; several older screens implement their own animations; nearby means the existing city feed, not verified GPS proximity. These should be addressed in a separate focused functional pass.
