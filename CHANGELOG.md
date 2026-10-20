# Changelog

All notable user-facing changes. Format: Keep a Changelog. Versioning: `sop/release-and-versioning.md`.

## [Unreleased]

### Added
- Shared premium 3D back button with light/dark raised surfaces, glossy orange depth, accessible touch targets, and reduced-motion-aware press feedback.
- Home now shows a personalized Activity Hub for pending requests, the next joined or hosted activity, and city/category-matched recommendations; Home category chips open filtered Explore results.
- API debug responses now use pretty JSON with sensitive fields redacted, and listed chat, activity, request, category, and city models use generated Freezed serialization.
- Activity hosts and accepted participants can open their group chat from activity details, activity cards, and the Chats filters; older message history now loads in pages.
- Shared WhatsApp-style rich text formatting for direct and activity group chats, with selectable messages that copy the original text.
- Multi-device session revocation and single-device session integrity via `activate_my_session` RPC.
- Deep link monitoring and password reset verification flow (`/reset-password`).
- Graphify AST knowledge graph tooling and automated community map.

### Fixed
- Back controls dismiss the keyboard and respect route/form guards; tapping outside inputs, changing routes/tabs, submitting valid forms, and dragging scroll views now clear unnecessary focus. Chat Send retains the keyboard, clearing search keeps focus, and selection sheets avoid the keyboard.
- Android and iOS launcher icons use the selected square sports artwork with platform masking; the original Android native splash artwork is retained independently of launcher exports.
- Screen titles reuse the Home logo in light and dark mode, and location markers follow the active theme color while retaining their 3D shading.
- Screens now extend behind the floating bottom navigation, removing the separate peach background around the pill while preserving its safe-area spacing.
- City selection now shows state beneath each city, searches combined city/state text, preserves distinct city IDs, and adapts its sheet to short lists and keyboard use; the Home header uses the centralized theme-aware KhelBhai logo and live user/notification actions.
- The active sports carousel label scales to remain readable on narrow screens.
- Sharper KhelBhai splash artwork, with restored mascot detail and clearer logo and tagline; unused blurred splash variants were removed.
- Empty states now use distinct KhelBhai sports illustrations, and remote image loading/error fallbacks use theme-aware brand colors and cached avatar images.
- In-app feedback now uses one managed SnackBar lifecycle. Route changes clear stale transient messages, persistent errors have a Dismiss action, foreground chat notifications are suppressed for the open conversation, and other chat banners open the matching conversation.

## [1.0.3+1] — 2026-10-14
### Baseline
- Baseline at flutter-workflow adoption (earlier history: git log / tags).
- 14 features catalogued: startup, auth, cities, categories, spot, explore, activities, chat, notifications, profile, settings, reports, help_support, legal.
