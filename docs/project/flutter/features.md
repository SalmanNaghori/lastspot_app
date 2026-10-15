# Feature catalogue — LastSpot

What the app does, one row per user-facing feature. Kept current in the **same PR** as the code (DOC-2).

Status values: `observed` · `planned` · `in-progress` · `live` · `flagged` · `deprecated` · `retired`.

## Features

| Feature | Description (user view) | Status | Owner | Tree / folder | Route(s) | State holder | Repository | Flag (REL-6) | Critical journey (TEST-20) | Permissions / push (PLAT-*) | Since |
|---------|-------------------------|--------|-------|---------------|----------|--------------|------------|--------------|----------------------------|-----------------------------|-------|
| **startup** | App launch, splash, maintenance & force-update checks | live | Core | `lib/features/startup/` | `/splash`, `/maintenance`, `/force-update` | `StartupBloc` | n/a (Supabase client + SharedPreferences) | none | App Launch | none | pre-adoption |
| **auth** | Login, signup, password reset, profile setup, device registration | live | Auth | `lib/features/auth/` | `/login`, `/signup`, `/forgot-password`, `/profile-setup`, `/account-status` | `AuthBloc`, `ProfileCubit` | `AuthRepository`, `ProfileRepository`, `DeviceRepository` | none | User Registration & Auth | Notification permission | pre-adoption |
| **cities** | City selection, multi-city filtering, active cities list | live | Core | `lib/features/cities/` | Modal selection | `CityCubit` | `CityRepository` | none | Location discovery | Location | pre-adoption |
| **categories** | Sports & activity category discovery (Cricket, Football, etc.) | live | Spot | `lib/features/categories/` | Embedded / Tabs | `CategoryBloc` | `CategoryRepository` | none | Discovery | none | pre-adoption |
| **spot** | Create activity, preview, details, manage match requests, join CTA, and Home Activity Hub | live | Spot | `lib/features/spot/` | `/create`, `/spot/:id`, `/manage-requests/:id`, `/home` | `SpotDetailsBloc`, `HomeCubit` | `SpotRepository` | none | Host & Join Activity | Photos, Camera | pre-adoption |
| **explore** | Search, category/date/time/distance/price filters, results grid | live | Spot | `lib/features/explore/` | `/explore`, `/explore?category_id=:id` | `ExploreBloc` | `SpotRepository` | none | Discover Activities | Location | pre-adoption |
| **activities** | My Activities (Created matches) & Joined Activities | live | Spot | `lib/features/activities/` | `/activities` | `ActivitiesBloc` | `SpotRepository`, `AuthRepository` | none | View Participations | none | pre-adoption |
| **chat** | Direct 1:1 chat, activity group chat, group info, formatted messaging | live | Chat | `lib/features/chat/` | `/chat/:id`, `/chat/:id/info` | `ChatCubit`, `ConversationsCubit` | `ChatRepository` | none | Participant Communication | Realtime | pre-adoption |
| **notifications** | Notification feed, unread count badge, read/delete actions | live | Push | `lib/features/notifications/` | `/notifications` | `NotificationsCubit`, `NotificationsListCubit` | `NotificationsRepository` | none | Notification Routing | FCM Push | pre-adoption |
| **profile** | View user profile, statistics (created/joined), avatar upload, edit | live | Profile | `lib/features/profile/` | `/profile`, `/profile/edit` | `ProfileCubit` | `ProfileRepository` | none | Profile Management | Photos, Camera | pre-adoption |
| **settings** | Theme mode (light/dark/system), accent color, language switch | live | Core | `lib/features/settings/` | `/settings` | `SettingsCubit` | n/a (SharedPreferences) | none | App Customization | none | pre-adoption |
| **reports** | Report users or inappropriate activities with reason and notes | live | Moderation | `lib/features/reports/` | `/report` | `ReportCubit` | `ReportRepository` | none | Community Moderation | none | pre-adoption |
| **help_support** | Help center, FAQs, customer support email contact | live | Support | `lib/features/help_support/` | `/help-support` | Stateless / URL launcher | n/a | none | User Support | none | pre-adoption |
| **legal** | Terms & Conditions, Privacy Policy legal viewer | live | Legal | `lib/features/legal/` | `/terms`, `/privacy` | Stateless | n/a | none | Legal Compliance | none | pre-adoption |

## Retired

| Feature | Removed in | Replaced by / notes |
|---------|------------|---------------------|
| _(none)_ | — | — |
