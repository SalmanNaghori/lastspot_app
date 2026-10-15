# LastSpot design system — 14 October 2026

This is the proposed mobile design system for the local interactive prototype. It is a design deliverable, not a claim that the Flutter UI has been changed. Existing source and backend capabilities were inspected before defining the screens. All names, activities, counts and messages in the prototype are illustrative sample data.

## Identity

LastSpot is a place for real plans with real people. The visual signature is a violet open-circle spot, compact editorial headings, pale court illustrations, and a clear remaining-capacity label. The warm, energetic surfaces stay quiet enough for activity details and conversations to remain readable.

## Color tokens

| Token | Light | Dark | Use |
|---|---|---|---|
| brand | `#5948E8` | `#AFA4FF` | Primary actions, links, selected controls |
| brand-strong | `#4334C8` | `#C6BDFF` | Pressed emphasis |
| brand-soft | `#EEEBFF` | `#2B2349` | Selected surfaces and outgoing bubbles |
| canvas | `#F7F7FB` | `#100F19` | App background |
| surface | `#FFFFFF` | `#1C192A` | Cards, sheets, inputs |
| ink | `#211D35` | `#F6F3FF` | Primary text |
| muted | `#6C657D` | `#C2BCD1` | Secondary text |
| outline | `#E4E0EE` | `#423B54` | Decorative dividers |
| input-outline | `#938AAB` | `#827893` | Identifiable form controls |
| success | `#087A58` | `#7CDCB4` | Accepted, available |
| success-soft | `#E6F6EE` | `#143D32` | Success label surface |
| warning | `#8A5608` | `#F4CC82` | Pending, limited capacity |
| warning-soft | `#FFF2D9` | `#44341C` | Warning label surface |
| error | `#BE3346` | `#FFA9B4` | Errors, destructive actions |
| error-soft | `#FDECEE` | `#4C2430` | Error label surface |

Calculated text contrast: white on brand 5.97:1; ink on canvas 15.21:1; muted on white 5.53:1; success on its surface 4.77:1; warning 5.55:1; error 4.91:1. Text and icon labels accompany semantic color. Decorative outlines do not substitute for control boundaries.

## Typography

Use Inter, already supported by the app's Google Fonts dependency and recorded project profile. The current `AppTypography` uses Plus Jakarta Sans; migration to Inter is a handoff decision within this redesign. The local prototype uses the operating system sans-serif stack for reliable offline rendering. Gujarati and Devanagari use platform font fallback, with Noto Sans Gujarati / Noto Sans Devanagari preferred when bundled in production. Keep emoji on the platform emoji font. Do not fake translations: app copy remains English until reviewed localizations are supplied; user messages support arbitrary Unicode.

| Role | Size / line height | Weight | Use |
|---|---|---|---|
| Display | 34 / 40 | 750 | Welcome headline only |
| Page | 28 / 34 | 700 | Home, Explore, Activities |
| Section | 20 / 26 | 700 | Section headings |
| Card title | 17 / 24 | 650 | Activity and request titles |
| Body | 15 / 23 | 400 | Description, chat, form help |
| Action | 15 / 20 | 650 | Buttons |
| Metadata | 13 / 19 | 450 | Date, venue, status |
| Caption | 11 / 16 | 600 | Timestamp and small labels |

No fixed text-height boxes. Allow text scaling to 200% and multiline labels. Do not truncate activity titles on detail screens; list titles may use two lines. Unicode copy must preserve original text and formatting markers.

## Layout and components

- Reference frame: 390 × 844 logical pixels. App screens scroll vertically; status area 34, app bar 56, bottom navigation 68 plus 22 safe area. Production uses actual `SafeArea`/insets rather than these reference constants.
- Spacing: 4, 8, 12, 16, 20, 24, 32, 40. Screen inset 20; card inset 16; section gap 24; inline icon gap 8.
- Radii: 8 for badges, 12 for fields/buttons, 18 for cards, 24 for sheets. Avoid applying pill corners to every surface.
- Buttons: minimum 48 high; primary violet fill; secondary pale violet; tertiary text; destructive error fill. Loading replaces the label with progress and disables repeated submission. Icon-only controls have labels and 44–48 targets.
- Fields: persistent label, 52 minimum height, clear focus ring, inline helper/error, semantic input type. Multiline input grows before the form scrolls. Errors do not erase input.
- Activity card: image/court visual, category and status, two-line title, date/time, venue, capacity label, price, contextual action. Compact cards reuse metadata without repeating large images.
- Category tiles: icon/illustration, name, visible selection tick. Multiple selection is limited to interests; discovery is a single category filter.
- Avatars: 40 in lists, 32 in participant stacks, 88 on profile. Initials fallback; do not infer presence or verification.
- Navigation: Home, Explore, Create, Activities, Profile. Create is a 44 square within the 68 navigation bar. It opens the creation flow and does not create an empty destination tab. Chats is accessible from Activities and eligible activity context.
- Chat: incoming surface bubbles, outgoing brand-soft bubbles, max 82% width, timestamps, date separators, sender labels in groups, shared rich text rendering. No delivery/read ticks unless backend evidence supports them.
- Sheets/dialogs: visible close/cancel, drag indicator on sheets, focus trap, Escape/back dismissal, return focus to invoker. Destructive confirmation shows exact action and cancel.
- Feedback: one transient SnackBar, 3 seconds. One dismissible notification banner near the top safe area, 5 seconds. Route/session changes remove stale messages; active-conversation events update messages directly. Persistent errors include Dismiss or a relevant recovery action.
- Skeletons: mirror the content layout, respect reduced motion. Empty/error states stay compact and provide a relevant action; no raw database exceptions.

## Responsive and platform behavior

At 320–430 wide, maintain a single column and flexible metadata wrapping. On tablets, center forms at 480–560; allow a two-column discovery feed and list/detail conversations only when both panes remain usable. Keep primary navigation identity consistent.

iOS uses native edge-back and date/time selection conventions. Android supports system back/predictive back and native date/time dialogs. The prototype's platform selector changes system chrome; it is not native OS behavior. The keyboard preview is a design aid; HTML fields also support the actual mobile keyboard. Chat composer and actions remain above the keyboard. Reduced-motion preference disables decorative transitions. Focus order follows visual order.

## Source mapping

Extend `lib/core/theme/{app_color,app_typography,app_spacing,app_radius,app_motion}.dart` and existing `AppButton`, `AppTextField`, `AppFilterChip`, `EmptyState`, `ErrorState`, shared activity cards and chat renderer when implementing. Keep `AppRoutes`, BLoC/Cubit state, `InAppFeedbackManager` and existing repository contracts. This prototype has no Supabase, authentication, FCM or Realtime connection.
