# Back navigation and keyboard UX

Reviewed on 2026-10-19. Scope: presentation, navigation controls, and focus only.
The existing Feature First architecture, go_router routes, domain/data code,
Supabase, Firebase, and notification behavior are preserved.

## Implementation and reuse

- [`KhelBhaiBackButton`](../../../lib/core/widgets/khelbhai_back_button.dart)
  is the single shared control. It renders a 44 dp raised surface inside a fixed
  48 dp touch target, with a small vector arrow, orange extrusion, amber
  highlight, themed charcoal/light surfaces, press scale/shadow animation, and
  `AppMotion` reduced-motion support. It has a localized Back tooltip, a separate
  button semantics node, and native InkWell keyboard activation. There are no
  assets to decode, precache, or parse and no added dependencies.
- [`requestBack`](../../../lib/core/utils/context_extensions.dart) unfocuses the
  editor and delegates to `NavigatorState.maybePop`. This is the framework's
  guarded pop request; the existing go_router Navigator still owns the stack.
  It honors `Form.canPop` / `PopScope`, and a root route stays open. It does not
  replace the route stack with a fallback Home/Profile destination.
- [`AppKeyboardDismissal`](../../../lib/core/widgets/app_keyboard_dismissal.dart)
  overrides `EditableTextTapOutsideIntent`, using Flutter's own tap regions.
  The former app-wide GestureDetector only dismissed focus when it won a tap;
  the new action also handles taps on other controls without consuming their
  gestures. Input text selection continues through EditableText's own region.
- [`NavigationFocusObserver`](../../../lib/core/services/navigation_focus_observer.dart)
  clears the departing focus on push/pop/replacement. It is registered on the
  root router. [`AuthenticatedAppShell`](../../../lib/core/widgets/authenticated_app_shell.dart)
  clears focus before branch changes; existing indexed-stack state is retained.
  `LastSpotApp` supplies `ScrollViewKeyboardDismissBehavior.onDrag` through its
  Material scroll behavior rather than adding handlers to every form.
- [`AppBottomSheet`](../../../lib/core/widgets/bottom_sheets/app_bottom_sheet.dart)
  clears departing focus and retains its existing keyboard inset animation.
  `SelectionBottomSheet.show` now reuses that helper and calculates its height
  from the space above the keyboard. City/item selection clears focus before
  returning the existing selection result.

Searches covered `arrow_back`, `BackButton`, `AppBar`, `leading`, `TextField`,
`TextFormField`, `Focus`, `PopScope`, `showModalBottomSheet`, `onTapOutside`, and
`keyboardDismissBehavior`. Existing app bars, color/dimension/radius/motion
tokens, route table, shared fields, and sheet helper were extended. A new control
was needed because the existing controls were separate flat Material arrows.

## Flow audit

| Area | Applied behavior / preserved contract |
| --- | --- |
| Login, signup, password recovery | Valid submissions unfocus before dispatch. Signup/recovery use conditional shared back controls. Login remains a root screen. |
| Profile setup | Previous steps use the shared control with the existing step callback; successful Next/Save clears focus. First step has no implied route back. |
| Onboarding | Back remains a previous-slide action and is absent on the first slide. |
| Home, Explore, Activities, Chats roots | No implied back button. Route/tab navigation clears focus; indexed-stack routing remains unchanged. |
| Explore/search | Clearing the query retains focus. Field suffix controls stay in their native text region. Opening results clears focus via route observation. No separate suggestion screen was found. |
| Create/edit activity, preview, details, requests | Shared back control; guarded pop, retained route state, and valid preview clears focus. Tablet and mobile variants use the same control. |
| Direct/group chat, group info | Shared back control. `ChatComposerBar` groups Send with the editor using `TextFieldTapRegion`; Send cannot steal input focus. Message dispatch and realtime code are unchanged. |
| My Sports Space, profile, edit profile | Conditional leading shows the control on a pushed route and hides it at root. Valid profile save clears focus. |
| Settings, notifications, support, legal, reports | Explicit/shared app bars use the same control. Report submission retains existing validation/dispatch behavior. |
| Searchable sheets | Shared inset-aware sheet handling; result taps clear focus. City sheet retains its existing search and drag-dismiss behavior. |
| OTP | No standalone OTP input screen was found. Route focus handling permits destination autofocus; no OTP authentication behavior was changed. |

The audited edit/create forms do not currently define dirty-form confirmation.
This change preserves any route/form guard and tests a refusing unsaved Form; it
does not introduce a new discard-confirmation policy or change business logic.

## Verification

- New widget tests:
  [`khelbhai_back_button_test.dart`](../../../test/core/widgets/khelbhai_back_button_test.dart)
  and [`app_keyboard_dismissal_test.dart`](../../../test/core/widgets/app_keyboard_dismissal_test.dart).
  They cover both themes, a 320×568 logical screen, 200% text scale, 48 dp/labeled
  target guidelines, semantic activation, reduced motion, pressed state,
  keyboard dismissal, root safety, guarded form back, Android back dispatch,
  simulated iOS edge swipe, retained previous-route draft, conditional leading,
  chat Send, search interaction/drag, destination autofocus, and sheet insets.
- Existing onboarding journey checks now locate and tap `KhelBhaiBackButton`.
  The repository ignores its previous local test baseline; `.gitignore` includes
  only these two new regression files and the updated onboarding test.
- The outside-tap regression is also checked against the original
  GestureDetector implementation before restoring the supported intent action.
- Both themes were rendered from the real widget and visually inspected.

Final checks (Flutter 3.47.5 via FVM):

| Command / check | Observed result |
| --- | --- |
| `fvm dart format` on the changed Dart files | Applied; subsequent final formatting changed no files. |
| `fvm flutter analyze` | No issues found. |
| `fvm flutter test` | 191 tests passed, including 12 new focus/navigation tests and the updated onboarding journey. Existing capture tests log Google Fonts download warnings; no test failures. |
| Original tap-detector regression reproduction | The outside-button test fails with focus still active under the old GestureDetector; the supported intent action passes. |
| `git diff --check` | Passed. |
| `python3 .agents/skills/flutter-workflow/scripts/check_compliance.py --base HEAD` | Passed its limited static checks; the broader review is in the matrix below. |
| `uvx reposeed graphify update .` | Completed, AST-only: 9,617 nodes / 12,180 edges. Graphify reports 12 generated Dart files with zero extracted nodes and 5 SQL files omitted because its SQL parser is unavailable; these graph gaps do not indicate Flutter test failures. |

No dependency, architecture, setup, or business-policy change was needed. No
platform build, live backend journey, commit, push, or publication was performed.

Hardware/device limits: widget tests simulate Android and iOS navigation; no
live app/device journey or physical TalkBack/VoiceOver session was run. Native
IME animation, physical iOS swipe behavior, and process-death restoration remain
manual QA. Previous-route retention is tested; no restoration configuration was
added. A synthetic destination autofocus test covers the focus contract, not a
production OTP journey.

## Compliance review

Rows refer to the Flutter architecture-compliance checklist. PASS means the
changed code was reviewed for that property; it does not imply device testing.

| Rows | Result | Evidence / applicability |
| --- | --- | --- |
| 1–4, 6 | PASS | New code stays in shared UI/navigation; no data/domain or business-rule changes. |
| 5 | N/A | No new interface, base class, repository, or use case. |
| 7–8, 10–13, 15, 17–22, 24 | N/A | DI, feature state, events, networking, repositories, models, and error handlers unchanged. |
| 9 | PASS | pubspec and lockfile unchanged; framework-only rendering/interaction. |
| 14 | PASS | No new subscriptions/controllers; observer belongs to the router. Existing composer controller disposal retained. |
| 16 | PASS | Focus/navigation actions remain in UI handlers and the registered Navigator observer. |
| 23 | PASS | No added logging, input capture, secrets, or PII. |
| 25 | PASS | Existing go_router route table/stack retained; guarded framework pop request; no new push APIs or route literals. |
| 26–27 | N/A | Deep links, notifications, and feature loading/error states unchanged. |
| 28–30 | PASS | Existing brand colors, dimensions, radii, motion, sheet and field mechanisms reused; localized Material Back label. |
| 31–33 | PASS | Lightweight const painter; no asset/runtime parsing, readiness sleeps, or asynchronous state updates. Button's single build stays together to keep its one control/semantics tree reviewable. |
| 34 | PASS | Widget regression coverage and existing onboarding journey updated in this change. |
| 35–37 | N/A | Auth/session security, storage, native build/signing and configuration unchanged. |
| 38–39 | PASS | Scope limited to navigation/focus, tests, docs, and required graph refresh. Existing accepted architecture preserved; no new ADR needed. |
| 40 | PRE-EXISTING | Widget-side DI/session access and existing inline styles/literals/private builders remain in legacy screens; they were not expanded into new business behavior. |
| 41–43 | PASS (widget scope) | Both themes, fixed accessible control dimensions, input behavior, semantics and localized label covered; physical assistive technology unverified. |
| 44–47 | N/A | Persistence, telemetry, permissions, release/CI settings unchanged. |
| 48 | PASS | CHANGELOG and shared-widget/feature catalogue updated; this record captures the tap-region and guarded-pop contracts. CONTRIBUTING needs no setup changes. |

Security review: auth form changes only unfocus after existing validation. No
credentials, session handling, user data transport, service calls, permissions,
uploads, Firebase, or notifications were modified. Knowledge capture is scoped
to this navigation/focus flow; no knowledge manifest exists to check.
