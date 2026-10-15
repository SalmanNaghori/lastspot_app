# Dependency Inventory — `pubspec.yaml`

Legend:
- **Arch:** A = Architectural, F = Feature-specific, U = Utility
- **Use:** W = Wrapped behind abstraction, D = Direct
- **Verdict:** KEEP / REVIEW / REMOVE / LEGACY

| Package | Version | Purpose | Category | Where Used | Arch | Use | Verdict |
|---------|---------|---------|----------|------------|------|-----|---------|
| `supabase_flutter` | `^2.18.0` | Backend client, auth, PostgREST, Realtime | Network / Backend | `core/network/`, `features/*/data/` | A | W | KEEP |
| `flutter_bloc` | `^9.1.1` | State management (BLoC & Cubit) | State | `features/*/presentation/bloc/` | A | D | KEEP |
| `equatable` | `^2.1.0` | Value equality for states and entities | State / Domain | Domain entities, BLoC states | A | D | KEEP |
| `get_it` | `^9.2.1` | Dependency injection container | DI | `core/di/service_locator.dart` | A | W | KEEP |
| `go_router` | `^17.5.0` | Declarative URL-based routing | Routing | `core/network/router.dart` | A | W | KEEP |
| `shared_preferences` | `^2.5.5` | Key-value persistent storage | Storage | `core/utils/shared_prefs_util.dart` | A | W | KEEP |
| `freezed_annotation` | `^3.1.0` | Immutable data classes & unions | Serialization | `domain/entities/`, `data/models/` | A | D | KEEP |
| `json_annotation` | `^4.12.0` | JSON serialization generator tags | Serialization | `data/models/` | A | D | KEEP |
| `firebase_core` | `^4.15.0` | Firebase app initialization | Cloud / Auth | `main.dart` | A | W | KEEP |
| `firebase_messaging` | `^16.7.0` | Push notifications client | Push | `core/services/push_notification_service.dart` | A | W | KEEP |
| `flutter_local_notifications` | `^22.3.1` | Local heads-up notifications | Push | `core/services/local_notification_service.dart` | A | W | KEEP |
| `cached_network_image` | `^3.4.1` | Network image caching and disk cache | UI | `core/widgets/app_cached_network_image.dart` | U | W | KEEP |
| `google_fonts` | `^8.2.1` | Typography (Inter font family) | UI / Theme | `core/theme/app_typography.dart` | U | W | KEEP |
| `intl` | `^0.20.2` | Date/time and currency formatting | Utility | `core/utils/app_utils.dart` | U | D | KEEP |
| `flutter_localizations` | sdk | Multi-language localization support | Localization | `lastspot_app.dart`, `core/l10n/` | A | D | KEEP |
| `shimmer` | `^3.0.0` | Shimmer effect for skeleton loading | UI | `core/widgets/app_shimmer.dart` | U | W | KEEP |
| `skeletonizer` | `^2.1.3` | Automatic skeleton placeholders | UI | `lastspot_app.dart` | U | W | KEEP |
| `animations` | `^2.2.0` | Material motion & transition patterns | UI | `core/theme/app_motion.dart` | U | W | KEEP |
| `flutter_staggered_animations` | `^1.1.1` | Staggered list animations | UI | `features/explore/`, `features/spot/` | U | D | KEEP |
| `lottie` | `^3.6.1` | Lottie vector animations | UI | Success screens, empty states | U | D | KEEP |
| `audioplayers` | `^6.6.0` | Audio feedback playback | Media | `features/spot/presentation/` | F | D | KEEP |
| `image_picker` | `^1.2.3` | Gallery and camera image picking | Media | `core/services/image_service.dart` | F | W | KEEP |
| `image_cropper` | `^12.2.1` | 1:1 square cropping for profile avatars | Media | `core/services/image_service.dart` | F | W | KEEP |
| `flutter_image_compress` | `^2.5.1` | Image compression before upload | Media | `core/services/image_service.dart` | U | W | KEEP |
| `url_launcher` | `^6.3.2` | Launch external web links and maps | System | `core/utils/app_utils.dart` | U | W | KEEP |
| `package_info_plus` | `^10.2.1` | App version and build number lookup | System | `core/services/installation_id_service.dart` | U | W | KEEP |
| `device_info_plus` | `^13.2.0` | Hardware and OS info for device reg | System | `features/auth/data/datasources/` | F | W | KEEP |
| `pub_semver` | `^2.2.1` | Semantic version checking for updates | Utility | `features/startup/presentation/bloc/` | U | D | KEEP |
| `path_provider` | `^2.1.6` | Filesystem temporary cache directory | Storage | `core/services/image_service.dart` | U | D | KEEP |
| `logger` | `^2.8.0` | Structured app logging | Utility | `core/utils/logger_utils.dart` | U | W | KEEP |
