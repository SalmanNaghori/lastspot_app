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

## Startup splash artwork

`SplashScreen` renders [`SplashBrandingView`](../../../lib/features/startup/presentation/widgets/splash_branding_view.dart),
which uses [`khelbhai_splash_restored.png`](../../../assets/branding/khelbhai_splash_restored.png)
through the generated asset accessor. The 852 × 1846 PNG is an AI-restored version
of the existing artwork, retaining the 6:13 composition and brand wording while
reconstructing fine detail. Earlier blurred source variants were removed during
asset cleanup. Their 1080 × 2340 dimensions did not reflect the actual
detail: both contained visibly enlarged, blurry edges. Flutter already used
`FilterQuality.high` and no decode-size limit; increasing filtering or resizing
the original cannot recover that missing detail. The existing fade, scale and
animated progress indicator are retained.

## Native splash and launcher icons

- Android's native launch window retains the original sports artwork and orange
  background. `drawable-*/native_splash_icon.png` keeps the previous padded
  launcher image separate from future app-icon exports; the original source is
  [`tool/branding/native_splash_original.png`](../../../tool/branding/native_splash_original.png).
  Legacy launch backgrounds and Android 12+ settings reference that frozen image.
- Launcher icons use the opaque, square 1254 × 1254
  [`khelbhai_launcher_master.png`](../../../assets/branding/khelbhai_launcher_master.png).
  The artwork has no baked-in corners or frame. Android adaptive resources fit it
  to the visible 72dp region of a 108dp layer. Existing monochrome resources are
  retained for themed icons. The manifest includes standard and round resources.
- [`export_launcher_icons.sh`](../../../tool/export_launcher_icons.sh) exports
  Android launcher PNGs and all iOS AppIcon sizes with macOS `sips`. iOS applies its
  own icon corners. The Flutter splash composition remains in `SplashBrandingView`.
- The illustration was repaired with the built-in imagegen tool using this
  [edit prompt](../../../tool/launcher_artwork_prompt.txt).

## Shared header branding and location markers

`KhelBhaiLogo` and `BrandedScreenTitle` in
[`brand_screen_title.dart`](../../../lib/core/widgets/brand_screen_title.dart)
use the same centralized light/dark logo as Home. Dashboard and standard app bars,
Explore, Profile, Settings, My Sports Space, and activity form/detail titles reuse
that component. Long titles can truncate within the available app-bar width.

`ActivityMetadataIcon.location` recolors the existing 3D pin with the active
`ColorScheme.primary`, using `AppAssets.locationPinColorFilter` to preserve neutral
highlights, shading and transparency. Home, Explore, city selection, activity
cards and activity details use this shared rendering path.

## Shared back navigation and keyboard behavior

[`KhelBhaiBackButton`](../../../lib/core/widgets/khelbhai_back_button.dart)
provides the shared raised light/dark back control. Navigation delegates to
`requestBack` in `context_extensions.dart`, using Flutter's guarded `maybePop`
so the current route can reject a pop. Onboarding and profile setup retain their
in-page previous-step callbacks. Root navigation tabs do not imply back controls.

[`AppKeyboardDismissal`](../../../lib/core/widgets/app_keyboard_dismissal.dart)
overrides the supported EditableText outside-tap action. Route changes use
`NavigationFocusObserver`; tab changes explicitly clear focus. The shared
Material scroll behavior dismisses on drag. `TextFieldTapRegion` keeps chat Send
and profile sports-search controls with their editor; selection sheets reuse
the inset-aware `AppBottomSheet` helper.

See the [audit and verification record](navigation-keyboard-ux.md) for affected
flows, test evidence, compliance, and device-testing limits.

## Retired

| Feature | Removed in | Replaced by / notes |
|---------|------------|---------------------|
| _(none)_ | — | — |
