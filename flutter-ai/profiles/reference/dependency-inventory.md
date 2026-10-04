# Dependency Inventory — `pubspec.yaml`

Legend — Arch: A = architectural (touches many layers, must be wrapped), F = feature-specific, U = utility. Use: W = wrapped behind project abstraction, D = used directly. Verdict: KEEP, REVIEW (justify or remove), REMOVE (unused/duplicate), LEGACY.

## State, DI, functional, codegen

| Package | Purpose | Category | Where used | Arch | Use | Verdict |
|---------|---------|----------|------------|------|-----|---------|
| flutter_bloc | Bloc/Cubit state management | State | presentation | A | D | KEEP |
| equatable | Value equality for events/states | State | events, `Failure` | U | D | KEEP |
| get_it | Service locator / DI | DI | `core/di`, `sl<>` | A | W (`sl`) | KEEP |
| fpdart | `Either<Failure,T>`, `Unit` | Functional | repos, cubits | A | D | KEEP |
| freezed / freezed_annotation | Immutable models/states | Codegen | models, states | A | D | KEEP |
| json_annotation / json_serializable | JSON codegen | Serialization | freezed models | A | D | KEEP |
| build_runner | Codegen runner | Codegen | dev | U | D | KEEP |
| auto_route / auto_route_generator | Typed routing | Routing | `core/navigation` | A | W (`AppRouter`, `NavigationService`) | KEEP |
| meta | Annotations | Utility | sparse | U | D | REVIEW (Flutter SDK re-exports most) |

## Networking

| Package | Purpose | Category | Where used | Arch | Use | Verdict |
|---------|---------|----------|------------|------|-----|---------|
| dio | HTTP client | Networking | `core/network`, `dio_injection` | A | W (`BaseApiService`) | KEEP |
| pretty_dio_logger | Debug HTTP logging | Logging | `dio_injection` (kDebugMode) | U | D | KEEP |
| http_parser | `MediaType` for multipart | Networking | repos (upload) | U | D | KEEP |
| mime | MIME lookup for uploads | Networking | repos | U | D | KEEP |
| socket_io_client | Realtime | Networking | `core/realtime/socket` | A | W (`SocketClient`) | KEEP |
| internet_connection_checker_plus | Connectivity | Networking | `NetworkMonitor` | A | W | KEEP |
| connectivity_plus | Connectivity | Networking | `selfie_camera_screen.dart` raw | A | D | REMOVE (duplicate, ND-4) |
| cached_network_image | Image caching | Images | `MyNetworkImage` + raw | F | partly W | KEEP; route all use via wrapper |
| any_link_preview | URL previews in chat | UI | chat | F | D | KEEP |
| flutter_google_maps_webservices | Places API | Platform | `LocationRepositoryImpl` | F | W | KEEP |
| google_static_maps_controller | Static map images | UI | location sharing | F | D | REVIEW |

## Storage

| Package | Purpose | Category | Where used | Arch | Use | Verdict |
|---------|---------|----------|------------|------|-----|---------|
| hive / hive_flutter | Local DB (chat cache, drafts, notification history) | Storage | `data/localDB`, `hiveInjection` | A | W (data sources) | KEEP |
| get_storage | Key-value prefs + session | Storage | `EncryptedStorage` → `AppStorage` | A | W | KEEP for prefs; REVIEW for tokens (ND-8) |
| encrypt | AES for storage | Security | `encryption_utils.dart` | A | W | REVIEW (weak key derivation, R6) |
| path_provider / path | File paths | Utility | media | U | D | KEEP |

## Firebase / platform

| Package | Purpose | Category | Where used | Arch | Use | Verdict |
|---------|---------|----------|------------|------|-----|---------|
| firebase_core / firebase_messaging / firebase_crashlytics | Push + crash reporting | Platform | initializer, notifications | A | W (`NotificationManager`) | KEEP (fix R1) |
| flutter_local_notifications | Local notifications | Platform | `core/notification` | A | W | KEEP |
| app_badge_plus | App icon badge | Platform | `BadgeService` | F | W | KEEP |
| geolocator | Location + distance | Platform | cubits, background service | A | D | KEEP; consider `LocationService` wrapper |
| flutter_background_service | Background isolate | Platform | `BackgroundLocationService` | A | W | KEEP |
| background_location (git fork) | Background location | Platform | **no Dart usage found** | — | — | REMOVE (verify native usage first) |
| google_maps_flutter / google_maps_flutter_android | Maps | UI/Platform | dashboard maps | F | D | KEEP |
| permission_handler | Permissions | Platform | `core/services/permission` | A | W | KEEP |
| device_info_plus / package_info_plus | Device/app metadata | Utility | `MainConfig` | U | W | KEEP |
| app_links | Deep links | Platform | `DeepLinkService` | A | W | KEEP |
| url_launcher / share_plus | External intents | Platform | UI | U | D | KEEP |
| flutter_contacts | Contacts sync | Platform | `ContactsRepositoryImpl` | F | W | KEEP |
| sms_autofill | OTP autofill | Platform | `VerifyOTPScreen` | F | D | KEEP |
| flutter_libphonenumber | Phone formatting | Utility | auth | F | D | KEEP |
| shake | Shake-to-feedback (Android) | Platform | `FirebaseAppFeedback` | F | D | KEEP |
| super_clipboard | Clipboard media paste | Platform | chat | F | D | KEEP |
| aws_rekognition_api / aws_client | Face verification | Platform | **commented out**; live path uses backend API | F | — | REMOVE (dead) |

## Media

| Package | Purpose | Category | Where used | Arch | Use | Verdict |
|---------|---------|----------|------------|------|-----|---------|
| image_picker, wechat_assets_picker, file_picker, camera, camerawesome | Pick/capture media | Media | pickers, selfie | F | partly W (`ImagePickerHelper`) | REVIEW: five pickers; document which is used where |
| video_compress, flutter_image_compress, image | Compression/manipulation | Media | upload service | F | W | KEEP |
| video_thumbnail, cached_video_player_plus, chewie | Video | Media | chat/feeds | F | D | KEEP |
| just_audio, record | Audio playback/recording | Media | chat audio | F | W (`AudioRecordingManager`) | KEEP |
| flutter_cached_pdfview, open_filex | Documents | Media | chat docs | F | D | KEEP |
| emoji_picker_flutter | Emoji | UI | chat | F | D | KEEP |
| photo_manager (transitive, imported with `depend_on_referenced_packages` ignore) | Gallery permission bypass | Media | `AppInitializer` | — | D | REVIEW: add as direct dep or remove import |

## UI

| Package | Purpose | Category | Where used | Arch | Use | Verdict |
|---------|---------|----------|------------|------|-----|---------|
| google_fonts | Inter font | UI | theme | U | W | REVIEW (Inter is also bundled in assets; one source) |
| flutter_easyloading | Blocking loader | UI | listeners (60+) | A | D | KEEP; rule PR-F4 |
| fluttertoast | Toasts | UI | `AppConstant.showToast` | A | W | KEEP |
| lottie | Animations | UI | splash/empty | F | D | KEEP |
| flutter_html, flutter_widget_from_html_core | HTML rendering | UI | policy/terms, chat | F | D | REVIEW (two HTML renderers) |
| webview_flutter | Web content | UI | `WebViewScreen` | F | D | KEEP |
| flutter_linkify | Link detection | UI | chat | F | D | KEEP |
| auto_size_text, dots_indicator, dashed_circular_progress_bar, wheel_picker, stop_watch_timer, simple_typing_indicator, flutter_staggered_grid_view, scrollview_observer | Widgets | UI | various | F | D | KEEP (each single-purpose) |
| cupertino_icons | Icons | UI | default | U | D | KEEP |
| easy_debounce | Debounce | Utility | cubits | U | D | KEEP (standard, PR-C6) |
| logger | Logging | Logging | `DebugLog` | A | W | KEEP |
| country_code_picker (path, vendored in lib/) | Country picker | UI | auth | F | D | LEGACY (R29) |

## Dev

| Package | Verdict |
|---------|---------|
| flutter_lints | KEEP; extend rule set (ND-10) |
| flutter_test | KEEP |
| bloc_test, mocktail | **MISSING** — pre-approved additions (ND-9) |

## Overrides

`dependency_overrides`: `uuid`, `http`, `intl` — REVIEW each release; remove when upstream constraints allow.

## Summary

- Total direct dependencies: ~95. Architectural (must stay wrapped): 22.
- REMOVE candidates: `connectivity_plus`, `background_location`, `aws_rekognition_api`, `aws_client`.
- REVIEW: `meta`, `google_static_maps_controller`, media picker overlap (5 packages), two HTML renderers, `google_fonts` vs bundled Inter, `photo_manager` transitive import, `encrypt` key derivation.
