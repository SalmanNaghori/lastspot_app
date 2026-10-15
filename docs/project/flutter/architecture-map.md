# Architecture Map — LastSpot (`lastspot_app`)

This document reflects the real, implemented architecture of LastSpot.

## 1. Directory Tree & Orientation

- **Orientation:** Feature First Clean Architecture (Stay)
- **Root:** `lib/`

```text
lib/
├── core/
│   ├── base_import.dart           # Common core barrel
│   ├── constants/                 # dimensions.dart, app_constants.dart, app_string.dart
│   ├── di/                        # service_locator.dart (GetIt container)
│   ├── extension/                 # context_extension.dart, map_extension.dart, etc.
│   ├── l10n/                      # intl_en.arb, app_localizations.dart
│   ├── network/                   # router.dart, app_routes.dart, supabase_config.dart, base_repository.dart
│   ├── services/                  # push_notification_service.dart, account_session_service.dart, etc.
│   ├── theme/                     # app_color.dart, app_theme.dart, app_typography.dart
│   ├── utils/                     # app_utils.dart, result.dart, shared_prefs_util.dart
│   └── widgets/                   # responsive_layout.dart, authenticated_app_shell.dart, app buttons, etc.
├── features/
│   ├── activities/                # My Activities / Joined Activities (data, domain, presentation)
│   ├── auth/                      # Login, Signup, Profile Setup, Device Registration
│   ├── categories/                # Sports categories listing & selection
│   ├── chat/                      # Direct chat, Group chat, Group info, Realtime messaging
│   ├── cities/                    # City filtering & selection
│   ├── explore/                   # Activity search, filtering, and discovery
│   ├── help_support/              # Help center & support contact
│   ├── legal/                     # Privacy policy, Terms & conditions
│   ├── notifications/             # Notification feed & unread badge
│   ├── profile/                   # User profile, statistics, settings
│   ├── reports/                   # Moderation & activity/user reporting
│   ├── settings/                  # Theme, language, preferences
│   ├── spot/                      # Activity creation, details, booking, management
│   └── startup/                   # Splash, onboarding, maintenance, force-update
├── lastspot_app.dart              # Global MultiBlocProvider, MaterialApp.router, theme setup
└── main.dart                      # App bootstrap, edge-to-edge, Supabase & DI initialization
```

## 2. Composition Root

- **Bootstrap (`lib/main.dart`):**
  - Initializes `WidgetsFlutterBinding`, system UI edge-to-edge style.
  - Initializes Supabase (`SupabaseConfig.initialize()`) & Firebase (`Firebase.initializeApp()`).
  - Executes `setupServiceLocator()` registering singletons/factories into `sl<GetIt>()`.
  - Initializes `PushNotificationService`.
  - Calls `runApp(const LastSpotApp())`.
- **Global Providers (`lib/lastspot_app.dart`):**
  - Provides root BLoCs: `StartupBloc`, `AuthBloc`, `SettingsCubit`, `CityCubit`, `CategoryBloc`.
- **Route / Feature Composition Roots:**
  - Feature screens inject scoped BLoCs via `BlocProvider(create: (_) => sl<FeatureBloc>())` in router or parent screen widgets.

## 3. Vertical Slice: Activity Booking & Participation (`features/spot`)

```text
[SpotDetailsScreen] (Mobile / Tablet Responsive Layout)
       │
       ▼ (dispatches events / renders state)
[SpotDetailsBloc]
       │
       ▼ (invokes use cases)
[GetSpotDetailsUseCase] / [JoinSpotUseCase] / [GetConfirmedPlayersUseCase]
       │
       ▼ (delegates to repository interface)
[SpotRepository] (Domain)
       ▲
       │ (implements)
[SpotRepositoryImpl] (Data, extends BaseRepository)
       │
       ▼ (executes network operations)
[SpotRemoteDataSource]
       │
       ▼ (queries / invokes RPC)
[Supabase Client] → PostgreSQL (tables: `requests`, `join_requests`, RPC: `join_activity_atomic`)
       │
       ▼ (deserializes into models & maps to entities)
[RequestModel] → [RequestEntity] (Domain Entity)
       │
       ▼ (emits)
[SpotDetailsLoaded] → [SpotDetailsBookingPanel] (UI feedback)
```

## 4. Home Activity Hub and discovery

- `HomeScreen` waits for `ProfileCubit` to load before calling `HomeCubit`, passing the selected city and saved sports preferences. If profile loading fails, Home still loads without a city filter.
- `HomeCubit` loads the city feed, categories, cities, the current user's activities, and received/sent join requests concurrently. It chooses the newest pending request, then the nearest upcoming joined activity, then the nearest upcoming hosted activity. Activity times are compared as instants against `DateTime.now().toUtc()`.
- A group-chat action is shown for an upcoming joined activity only when its sent join request is accepted. Review opens the matching activity's request manager; activity actions open its details; recommendations come from the current feed, selected city, and matching saved category names/slugs.
- Home category chips navigate to `/explore?category_id=<id>`, where the Explore state applies the category to its results.
- Evidence: `lib/features/spot/presentation/pages/home_screen.dart`, `lib/features/spot/presentation/bloc/home_cubit.dart`, `lib/features/spot/presentation/widgets/home_activity_hub.dart`, `lib/features/spot/domain/repositories/spot_repository.dart`, and `lib/features/explore/presentation/pages/explore_screen_mobile.dart`. Tests: `test/features/spot/presentation/bloc/home_cubit_test.dart` and `test/features/spot/presentation/widgets/home_activity_hub_test.dart`.

## 5. API debug JSON and data models

- `BaseRepository` emits response JSON only in debug builds. `DebugJsonFormatter` handles model lists, nested JSON values, dates and enums, pretty-prints the result, and redacts token, credential, contact, name, and message/content fields. It does not transform API response objects.
- Chat conversation/message, request/image, join request, category, and city API models use generated Freezed equality/copyWith and JSON output. Profile is already a Freezed JSON model. Request and join-request row parsing remains custom to preserve existing aliases, defaults, nested relationships, and participant/status derivation.
- Evidence: `lib/core/network/base/base_repository.dart`, `lib/core/utils/debug_json_formatter.dart`, the corresponding `data/models/` files, and serialization tests under `test/features/*/data/models/` plus `test/core/utils/debug_json_formatter_test.dart`.

## 6. Vertical Slice: Direct and Group Chat (`features/chat`)

```text
[ChatScreenMobile / ChatScreenTablet]
       │
       ▼ (initializes ChatCubit with conversation mode)
[ChatCubit]
       ├── direct → [get_or_create_direct_chat]
       └── group  → [get_or_create_group_chat]
       │
       ▼ (loads latest messages, pages older history, sends, and streams)
[ChatRepository] → [ChatRemoteDataSource] → Supabase
       ├── conversation list: get_my_chat_conversations
       ├── message rows: chat_messages
       └── realtime inserts: chat_messages
       │
       ▼
[ChatMessageEntity] → [ChatMessageBubble] → [ChatTextFormatter]
```

- Direct and group screens share `ChatMessageBubble` and `ChatTextFormatter`.
  Message ownership controls alignment; incoming group messages also show the
  sender name at the start of a streak.
- `chat_messages.content` keeps the original text, including formatting marks,
  whitespace, and line breaks. `ChatTextFormatter` transforms it only into
  presentation spans. The selectable text Copy action copies the original
  content.
- Source: `lib/features/chat/presentation/bloc/chat_cubit.dart`,
  `lib/features/chat/data/datasources/chat_remote_datasource.dart`,
  `lib/features/chat/presentation/widgets/chat_message_bubble.dart`, and
  `lib/features/chat/presentation/utils/chat_text_formatter.dart`.
- Verification: `test/features/chat/presentation/utils/chat_text_formatter_test.dart`,
  `test/features/chat/presentation/widgets/chat_message_bubble_test.dart`, and
  `test/features/chat/presentation/bloc/chat_cubit_test.dart`.
- Realtime and Supabase channel decisions: [ADR-0007](../../adr/0007-supabase-realtime-messaging.md).
- Activity details and accepted activity cards open groups by request ID; the RPC resolves or reuses the conversation ID, and backend access policies remain authoritative.

## 7. Cross-Cutting Concerns

| Concern | Implementation | Location |
|---------|----------------|----------|
| **Auth & Session** | `AuthBloc`, `AccountSessionService`, `Supabase.client.auth` | `lib/features/auth/`, `lib/core/services/` |
| **Single-Device Security** | RPCs `activate_my_session`, `register_my_device`, device tokens | `lib/features/auth/data/datasources/` |
| **Routing & Navigation** | `go_router` (`appRouter`), typed path helpers (`AppRoutes`) | `lib/core/network/` |
| **Errors & Failures** | `Result<T, Exception>` (`Success` / `Failure`), `BaseRepository` | `lib/core/utils/result.dart`, `lib/core/network/base/` |
| **Design System** | `AppColor`, `AppTheme`, `AppSpacing`, `AppRadius`, `Dimensions` | `lib/core/theme/`, `lib/core/constants/` |
| **Local Storage** | `shared_preferences` wrapped by `SharedPrefsUtil` | `lib/core/utils/shared_prefs_util.dart` |
| **Realtime** | Supabase Realtime Channels (`chat_messages`, join requests) | `lib/features/chat/`, `lib/features/spot/` |
| **Push Notifications** | `firebase_messaging` + `flutter_local_notifications` | `lib/core/services/` |
| **Localization** | `AppLocalizations` (`intl_en.arb`) + `AppString` | `lib/core/l10n/`, `lib/core/constants/` |

### In-app feedback and foreground notifications

- `InAppFeedbackManager` is the single owner of in-app SnackBars and is also registered as a `NavigatorObserver`. It replaces queued messages, deduplicates event keys, clears transient feedback on route changes, and leaves persistent errors visible with a Dismiss action.
- `AuthenticatedAppShell` forwards Supabase notification inserts and foreground `PushNotificationService` forwards FCM messages to the manager. Chat banners carry the conversation ID; opening that conversation or receiving a message while it is open dismisses/suppresses the banner. FCM background delivery and local notification tap handling remain in `PushNotificationService` / `LocalNotificationService`.
- `ChatScreen` registers both its requested target and resolved conversation with the manager so request-based group-chat routes are filtered while the conversation is being resolved.
- Source: `lib/core/services/in_app_feedback_manager.dart`, `lib/core/services/push_notification_service.dart`, `lib/core/widgets/authenticated_app_shell.dart`, `lib/features/chat/presentation/pages/chat_screen.dart`. Lifecycle coverage: `test/core/services/in_app_feedback_manager_test.dart`.
