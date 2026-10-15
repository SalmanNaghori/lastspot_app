# Changelog

All notable user-facing changes. Format: Keep a Changelog. Versioning: `sop/release-and-versioning.md`.

## [Unreleased]

### Added
- Home now shows a personalized Activity Hub for pending requests, the next joined or hosted activity, and city/category-matched recommendations; Home category chips open filtered Explore results.
- API debug responses now use pretty JSON with sensitive fields redacted, and listed chat, activity, request, category, and city models use generated Freezed serialization.
- Activity hosts and accepted participants can open their group chat from activity details, activity cards, and the Chats filters; older message history now loads in pages.
- Shared WhatsApp-style rich text formatting for direct and activity group chats, with selectable messages that copy the original text.
- Multi-device session revocation and single-device session integrity via `activate_my_session` RPC.
- Deep link monitoring and password reset verification flow (`/reset-password`).
- Graphify AST knowledge graph tooling and automated community map.

### Fixed
- In-app feedback now uses one managed SnackBar lifecycle. Route changes clear stale transient messages, persistent errors have a Dismiss action, foreground chat notifications are suppressed for the open conversation, and other chat banners open the matching conversation.

## [1.0.3+1] — 2026-10-14
### Baseline
- Baseline at flutter-workflow adoption (earlier history: git log / tags).
- 14 features catalogued: startup, auth, cities, categories, spot, explore, activities, chat, notifications, profile, settings, reports, help_support, legal.
