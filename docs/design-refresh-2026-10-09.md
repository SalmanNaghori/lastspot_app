# LastSpot design refresh — 9 October 2026

LastSpot connects local activity hosts with players: discover → details → request to join → host approval → participation/chat. The existing implementation uses Flutter, feature-first presentation/domain/data modules, BLoC/Cubit, GetIt, GoRouter, Supabase, generated English localization, and shared Material 3 components.

This refresh follows the implemented violet/coral palette and Plus Jakarta Sans typography. The older master specification mentions emerald/Inter, while the generic governance profile still contains TBD placeholders and references unused routing/theme classes. Existing architecture and actual theme are retained for this UI task; no stack migration or dependency changes were made.

## Delivered

- Home greeting and city selection sit above a stronger editorial activity banner. “Find a game” opens Explore; “Host an activity” opens the existing create flow.
- Confirmation dialogs use a tonal icon header, explicit close control, scrollable content, full-width actions, destructive-action styling, and shared fade/slide/scale motion.
- Sheets use a consistent scrim, bounded tablet width, and animated keyboard insets.
- Activity photos open in a fullscreen modal with paging, previous/next buttons, pinch and double-tap zoom, explicit zoom/reset controls, and accessible labels. The inline gallery follows the selected fullscreen page and resets when its activity/images change. No-photo activities retain their existing fallback.
- Image fades, loading shimmer, dialogs, sheets, and gallery controls respect reduced motion. Fullscreen paging jumps immediately when animations are disabled.

Direction informed by [Material 3 Expressive](https://m3.material.io/) and its [motion guidance](https://m3.material.io/styles/motion). No third-party UI library added.

## Files and reuse

Modified:
- `lib/core/constants/dimensions.dart`, `lib/core/theme/app_motion.dart`: shared sizing/motion tokens.
- `lib/core/widgets/dialogs/app_dialog.dart`: extends the existing dialog helper with reusable overlay presentation.
- `lib/core/widgets/bottom_sheets/app_bottom_sheet.dart`: extends existing sheet presentation.
- `lib/core/widgets/app_cached_network_image.dart`, `lib/core/widgets/app_shimmer.dart`: reduced-motion support.
- `lib/features/spot/presentation/widgets/home_greeting_banner.dart`, `lib/features/spot/presentation/pages/home_screen.dart`: updated banner and create action.
- `lib/features/spot/presentation/widgets/spot_details_gallery.dart`: viewer integration and page synchronization.
- `lib/core/l10n/intl_en.arb`: new copy; `app_localizations.dart` and `app_localizations_en.dart` regenerated with Flutter.

Created:
- `lib/features/spot/presentation/widgets/spot_photo_viewer.dart`: dedicated owner for fullscreen paging and zoom controllers; no previous fullscreen viewer was found.
- `test/core/widgets/dialogs/app_dialog_test.dart`, `test/core/widgets/bottom_sheets/app_bottom_sheet_test.dart`, `test/features/spot/presentation/widgets/spot_details_gallery_test.dart`, `test/features/spot/presentation/widgets/home_greeting_banner_test.dart`: interaction/regression coverage.
- `test/support/design_test_app.dart`: localized theme harness without network font requests.
- `docs/design-refresh-2026-10-09.md`: this implementation report.

Deleted: none. Dependencies: none. Architectural impact: none; the viewer is a non-addressable modal through the existing dialog helper. Local widget state only manages presentation controllers.

Searches covered shared dialogs, sheets, image wrappers, motion/theme tokens, gallery widgets, confirmation callers, home actions, routes, feature state/repositories, and existing tests. Reused AppButton, AppCachedNetworkImage, SportGradientBackground, AppDialog, AppBottomSheet, AnimationWrapper, localization, and the existing Explore/Create routes.

## Verification and limits

- The initial eight widget tests pass and cover confirm/cancel/close, small-screen large-text dialogs, home callbacks, sheet reopening, fullscreen selection/zoom/close, reduced-motion paging/system back, activity replacement, and no-photo fallback.
- Tests use empty image URLs to exercise deterministic fallbacks, without real network or Supabase access.
- Formatting and `git diff --check` checked for this change. Generated localization uses `fvm flutter gen-l10n`.
- Full-project analyzer reports 26 pre-existing findings, including null-awareness, unused code/imports, style lints, and datasource print statements. Targeted analysis of all changed UI files and tests passes with no issues.
- No authenticated device walkthrough, live image download, real multitouch device test, or backend integration test was performed. Backend joins, chat, and authentication were not changed.

## Compliance review

Numbers correspond to `flutter-ai/checklists/architecture-compliance.md`. PASS means the change introduces no violation; N/A means the area is untouched.

| Checks | Result | Evidence |
|---|---|---|
| 1–4 Layers, UI boundaries, logic placement | PASS | UI-only changes; no repository/storage calls added |
| 5 New abstractions | N/A | No domain/service abstractions |
| 6 Structure/codegen | PASS | Existing folders; generated localization regenerated |
| 7–8 DI | N/A | No container or registration changes |
| 9 Dependencies | PASS | pubspec unchanged |
| 10 State paradigm | PASS | Existing BLoC architecture retained; local controller state |
| 11–13 Feature state/emit/holder purity | N/A | No feature state changes |
| 14 Controllers | PASS | Page and transformation controllers/listeners disposed |
| 15 Events | N/A | No BLoC event changes |
| 16 Side effects | PASS | Overlay/navigation triggered by interaction handlers |
| 17–22 Pagination/network/repositories/global errors | N/A | Untouched |
| 23 Logging | PASS | No logging or sensitive output added |
| 24 Models | N/A | Existing entities reused |
| 25 Routing | PASS | Existing destinations; helper-based modal overlay |
| 26 Deep links | N/A | Untouched |
| 27 UI states | PASS | Existing loading/error image wrappers and empty fallback |
| 28 Design tokens | PASS | Existing palette/type/spacing and added shared tokens |
| 29 Shared widgets | PASS | Existing image/button/overlay primitives extended |
| 30 Strings | PASS | New user-facing text localized |
| 31–33 Lifecycle/performance/async | PASS | Lazy pages, bounded image decode, disposal, stale callback guard |
| 34 Tests | PASS | Interaction tests without backend/network access |
| 35–37 Security/build | N/A | Untouched |
| 38 Scope | PASS | Design and gallery interaction changes only |
| 39 Project governance | PRE-EXISTING | Generic profile is unfilled; implemented stack retained |
| 40 Pre-existing findings | PASS | Recorded below |

Observed pre-existing issues: generic project rules contain unresolved TBDs and incompatible AutoRoute/theme examples; HomeScreen accesses the Supabase session directly (UI-1); existing cached-image fallback uses literal colors (UI-3); spot datasource has print statements (ERR-6). These were not extended by this change. No blocking failures introduced and no exceptions requested.

## Follow-up for map and home sections (9 October 2026)

The details screen previously showed a large lavender panel with a hardcoded network image, so it looked like a map even though it was not one. New activities currently persist latitude/longitude as `0,0`; the app cannot draw a reliable pin from those fields. The panel and its unused painter were removed. The location card now names a shared map link or venue, describes the action accurately, opens the link or searches Maps, and reports an open failure. This preserves the actual host location without pretending to have a map preview.

Home previously placed the same activity in both Nearby and Coming Up and rendered both as large image cards. The updated Cubit groups future activities once: urgent within 24 hours, Coming Up in the next seven days, and Later on after that. Coming Up uses a compact card showing image, sport, time, location, price and availability. Later on retains the larger photo card. The old Nearby label was removed because the backend only filters by city when one is selected; it does not calculate distance. Section-specific View All links were removed because they opened unfiltered Explore. The Later on label does not imply a distance calculation. The banner still opens Explore for all games.

New regression tests cover the non-overlapping Cubit groups, a shared map link and venue search action, and compact-card readability at 320 logical pixels with 200% text scale. The full suite now has 12 passing tests, and targeted static analysis reports no issues. This test also exposed a Cubit error when a use case returned an immutable empty city list; the Cubit now copies lists before sorting.

Files changed in this follow-up: `app_utils.dart`, `home_cubit.dart`, `home_state.dart`, `home_screen.dart`, `spot_details_screen_mobile.dart`, `compact_spot_card.dart`, `spot_details_content.dart`, `intl_en.arb` and its generated output. Removed `spot_details_map_placeholder.dart` and unused `map_placeholder_painter.dart`. Added `home_cubit_test.dart`, `spot_details_content_test.dart`, and `compact_spot_card_test.dart`. No package, schema, or API change.

Limit: activities without exact coordinates continue to open an external map link/search. Showing a real in-app pin would require storing valid coordinates during activity creation and providing a map tile service. Existing records with `0,0` cannot be safely plotted as a venue.
