# Codebase Audit Report

Date: 2026-09-08
Scope: `lib/` (1163 Dart files, 73 `.g.dart`, 67 `.freezed.dart`, 1 `.gr.dart`), `test/`, `pubspec.yaml`, `analysis_options.yaml`, `android/`, `ios/`, `config/`.
Method: direct file inspection plus `rg` counts. No application code was modified.

Classification vocabulary used throughout:

| Tag | Meaning |
|-----|---------|
| UNIVERSAL | Reusable in any Flutter project; became a standard in `sop/` and a boundary in `guardrails/`. |
| PROJECT-SPECIFIC | Valid here, documented via ADR, not promoted to a universal rule. |
| RECOMMENDED | Universal best default, but a project may override with an ADR. |
| OPTIONAL | Allowed; not required. |
| LEGACY | Present, superseded, must not be extended; candidate for removal. |
| ANTI-PATTERN | Present and harmful; guardrails forbid new occurrences. |
| NEEDS-DECISION | Two or more competing implementations; a tech lead must choose. |

Confidence: HIGH = observed in 3+ places with consistent behaviour; MEDIUM = observed but with variation; LOW = inferred.

---

## 1. Application structure

| Finding | Evidence | Class | Confidence |
|---------|----------|-------|-----------|
| Layer-first layout: `lib/layers/{app,base,core,data,domain,presentation,utils}` | directory tree | PROJECT-SPECIFIC (ADR-0001) | HIGH |
| Features are spread across layers (e.g. orbits: `domain/repositories/orbits_repository.dart`, `data/repositoryImpl/orbits_repository_impl.dart`, `presentation/cubit/orbitListCubit/`, `presentation/ui/dashboard/orbits/`) | file listing | PROJECT-SPECIFIC | HIGH |
| Barrel files: `utils/exports.dart` (mega-barrel re-exporting Flutter, bloc, Hive, EasyLoading, app, base, presentation), `app/app.dart`, `core/core.dart`, `presentation/presentation.dart` | `lib/layers/utils/exports.dart` | NEEDS-DECISION (hides dependencies; makes layer violations invisible to the analyzer) | HIGH |
| A third-party package vendored **inside `lib/`** with its own `pubspec.yaml`, `ios/`, `.github/` | `lib/layers/app/custom/CountryCodePicker/` | ANTI-PATTERN (should live in `packages/`) | HIGH |
| Stray tracked root files: `0` (empty), `inspect_picker.dart`, `test_empty_notification.dart`, two READMEs | repo root | LEGACY | HIGH |
| Flutter version pins disagree: `.fvmrc` = 3.32.6, `.tool-versions` = 3.38.3, README says 3.38.3 | root files | NEEDS-DECISION | HIGH |

## 2. Dependency injection

| Finding | Evidence | Class | Confidence |
|---------|----------|-------|-----------|
| `get_it` with global alias `GetIt sl = GetIt.instance` | `core/di/service_locator.dart:15` | PROJECT-SPECIFIC (alias name), UNIVERSAL (single container) | HIGH |
| Registration split into ordered modules: Config → EventBus → LifeCycle → MainConfig → External → Hive → AppLevel → DataSources → Repositories → DomainServices → Blocs → Cubits → Boot | `service_locator.dart:33-78` | UNIVERSAL (modular, ordered composition root) | HIGH |
| Repositories = `registerLazySingleton<Abstract>(() => Impl(dep: sl()))`; Blocs/Cubits = `registerFactory` | `repository_injection.dart`, `cubits_injection.dart` | UNIVERSAL | HIGH |
| Constructor injection in all 20 repository impls (0 `sl<` hits in `repositoryImpl/`) | rg | UNIVERSAL | HIGH |
| `sl<>` called inside cubit methods / helpers: `location_cubit.dart:262` (`sl<AppConfiguration>()`), `chat_details_helpers.dart` (`sl<AuthStateProvider>()`) | rg | ANTI-PATTERN (hidden dependency) | HIGH |
| `sl<>` called inside widgets: ~170 hits across ~70 files in `presentation/ui`, e.g. `heat_map_button.dart:53` (`sl<AppStorage>()`), `orbit_image.dart:43` (`sl<AppConfiguration>().awsReferer`), `members_tile.dart:199` (`sl<AuthStateProvider>().userID`) | rg | ANTI-PATTERN | HIGH |
| `sl<>` in `BlocProvider(create: (_) => sl<X>())` and `wrappedRoute` | `main.dart:62-82`, `orbit_detail_screen.dart:30-54` | UNIVERSAL (composition root use is correct) | HIGH |
| `ChatDraftRepositoryImpl()` takes no deps and opens Hive box by global name | `repository_injection.dart:114` | ANTI-PATTERN (implicit global) | MEDIUM |
| `ChatPinnedBloc` registered in `cubits_injection.dart:206` instead of blocs module | file | LEGACY (misplacement) | HIGH |
| `MapControlsCubit()` constructed with `new` inside dashboard instead of `sl` | UI audit | NEEDS-DECISION (pure UI cubits may skip DI; must be stated) | MEDIUM |
| `GlobalVariable.appContext = navigatorKey.currentContext!` used by `Dimensions` and `MainConfig.textTheme` | `base/global_key.dart`, `base/main_config.dart:28` | ANTI-PATTERN (global BuildContext) | HIGH |

## 3. State management

| Finding | Evidence | Class | Confidence |
|---------|----------|-------|-----------|
| `flutter_bloc` 9.x; 14 Blocs, ~68 Cubits | `bloc/`, `cubit/` folders | PROJECT-SPECIFIC counts; Bloc+Cubit UNIVERSAL option | HIGH |
| `BaseCubit<S>`: network-restore hook, stale tracking, `handleFailure` → `Status.noInternet`/`Status.failure` | `base/base_cubit.dart` | UNIVERSAL pattern (shared failure handling) | HIGH |
| `Status { none, initial, loading, paginating, success, failure, noInternet, syncing }` | `base/base_status.dart` | UNIVERSAL (single status enum) | HIGH |
| Only 9 of ~68 cubits extend `BaseCubit`; 71 extend raw `Cubit` | rg | NEEDS-DECISION (adopt BaseCubit for all data-loading cubits, or retire it) | HIGH |
| Three state styles: (a) freezed + `Status` (`home_state.dart`, `orbit_list_state.dart`), (b) plain class + `isLoading/hasError/isSuccess` flags (`auth_state.dart`, `create_orbit_state.dart`), (c) sealed subclasses (`view_user_profile_state.dart`) | files | (a) UNIVERSAL, (b) ANTI-PATTERN "flag soup", (c) OPTIONAL for finite flows | HIGH |
| Events: `sealed class XEvent extends Equatable`; names mix `OnCreateOrbitEvent`, `VerifyOtpEvent`, `PinChat`, `LoadPinnedMessages`; `ChatPinnedEvent` is `abstract` not `sealed` | `*_event.dart` | NEEDS-DECISION → standardised in `sop/naming-conventions.md` | HIGH |
| `ChatMessagingBloc` state type is `LastMessageState` | `chat_messaging_bloc.dart` | LEGACY (naming mismatch) | HIGH |
| `CompleteProfileEvent` declared but no `on<>` handler | `auth_event.dart:45`, `auth_bloc.dart` | LEGACY (dead event) | HIGH |
| `bloc_concurrency` not a dependency; no `transformer:` anywhere | `pubspec.lock`, rg | NEEDS-DECISION | HIGH |
| `isClosed` checked before `emit` after `await` in BaseCubit descendants; missing in `AuthBloc`, `LocationCubit.loadCurrentLocation`, `AudioPlayerCubit.toggle`, `CreateOrbitBloc` | files | ANTI-PATTERN (emit-after-close) | HIGH |
| Debounce via `easy_debounce` (6 cubits) and raw `Timer` (2 cubits) | rg | NEEDS-DECISION (pick one) | HIGH |
| Pagination: `skip/limit/hasMore/Status.paginating` (OrbitList, Feeds, Members) vs `isPaginating` bool (ChatMessageList, BondList) vs feature enum (Comments, Appeals) vs cursor (GIF) | files | NEEDS-DECISION → standard contract in `sop/state-management.md` | HIGH |
| Navigation / toasts / EasyLoading kept out of Blocs and Cubits (0 hits for `Navigator`, `EasyLoading`, `Fluttertoast` under `bloc/` and `cubit/`) | rg | UNIVERSAL (side effects in `BlocListener`) | HIGH |
| One cubit helper takes `BuildContext` and reads another bloc | `chatDetailsCubit/uiHelperExtensions/chat_details_user_ui.dart:83-85` | ANTI-PATTERN | HIGH |
| `UserProfileBloc` exposes imperative public methods that bypass events | `user_profile_bloc.dart` | ANTI-PATTERN (Bloc as façade) | MEDIUM |
| 21 `BlocProvider`s at app root in `main.dart` | `main.dart:60-83` | NEEDS-DECISION (scope per route where possible) | HIGH |
| `SingleChatScreen.wrappedRoute` provides ~30 cubits | `single_chat_screen.dart:53-114` | ANTI-PATTERN (god screen) | HIGH |
| Cross-feature updates via `GlobalEventBus` + `EventSubscriberMixin.listenTo<T>` | `core/realtime/` | PROJECT-SPECIFIC (ADR-0007); pattern RECOMMENDED for realtime-heavy apps | HIGH |
| `context.read<` 896 hits, `context.watch<` 1, `context.select<` 0, `BlocSelector<` 7 | rg | RECOMMENDED: use `BlocSelector`/`buildWhen` for rebuild scoping | HIGH |
| God cubits: `chat_contacts_base_cubit.dart` 758 lines, `chat_message_list_cubit.dart` 667 | wc | ANTI-PATTERN | HIGH |
| Entirely commented legacy cubits `cubit/auth/user_update_complete_profile.dart` (512 lines) | file | LEGACY (delete) | HIGH |
| `ThemeCubit` exists but is neither registered nor provided | rg | LEGACY | HIGH |

## 4. Networking

| Finding | Evidence | Class | Confidence |
|---------|----------|-------|-----------|
| `BaseApiService.executeAPI(ApiRequest) → Future<Either<Failure, dynamic>>` implemented by `NetworkAPIImpl` over Dio | `core/network/client/` | UNIVERSAL (single HTTP gateway abstraction) | HIGH |
| `ApiRequest` value object: url, method, query, body, requiresAuth, onSendProgress, allowQueued, apiType | `core/network/model/api_request_model.dart` | UNIVERSAL | HIGH |
| Endpoints centralised in `ApiEndpoints`; some duplicates (`aboutUs` vs `aboutUsAPI`) and inconsistent leading `/` | `api_endpoints.dart` | UNIVERSAL (central) + LEGACY (duplicates) | HIGH |
| Interceptors: `AuthInterceptor` (Bearer when `extra.requiresAuth`), `AuthFailureInterceptor` (401 → logout + `LogoutEvent`; 503 maintenance; 409 force update), `RetryInterceptor` (3x GET/HEAD, backoff), `PrettyDioLogger` (`kDebugMode`) | `dio_injection.dart:50-63` | UNIVERSAL | HIGH |
| No refresh-token flow; 401 = hard logout | rg `refresh` | PROJECT-SPECIFIC (backend contract) | HIGH |
| Offline request queue keyed by `method_url_query_body`, flushed on reconnect, cleared on logout | `network_request_queue.dart` | PROJECT-SPECIFIC, OPTIONAL universally | HIGH |
| `NetworkMonitor` wrapping `internet_connection_checker_plus`; `connectivity_plus` also a dep and used raw in `selfie_camera_screen.dart:38` | pubspec, rg | NEEDS-DECISION (two connectivity packages) | HIGH |
| `UpdateUiMixin.backToUI` wraps call + parse, uses `compute` for `computeJson` and for maps > 50 keys | `update_ui_mixin.dart` | PROJECT-SPECIFIC helper (ADR-0005); parse-off-main-thread RECOMMENDED | HIGH |
| `DioErrorMapper` → single `Failure(error, statusCode)` | `dio_error_mapper.dart` | UNIVERSAL shape; RECOMMENDED to add typed failure kinds | HIGH |
| Timeouts 120s for connect/send/receive | `dio_injection.dart:24-26` | NEEDS-DECISION (very long) | HIGH |
| `badCertificateCallback` trusts any cert when host == staging base URL host | `dio_injection.dart` | ANTI-PATTERN unless compiled out of release | HIGH |
| No download API surface | rg `onReceiveProgress` | n/a | HIGH |

## 5. Repository and domain

| Finding | Evidence | Class | Confidence |
|---------|----------|-------|-----------|
| Abstract repository in `domain/repositories/`, impl in `data/repositoryImpl/` with `Impl` suffix, all return `Future<Either<Failure, T>>` (`Unit` for void) | 20 pairs | UNIVERSAL (contract), PROJECT-SPECIFIC (`Impl` suffix) | HIGH |
| Most repositories call `BaseApiService` directly; only chat has a remote data source + local cache data source | `data/remote/` (2 files) | UNIVERSAL rule: data source layer only when 2+ sources | HIGH |
| Use cases exist only for chat message list (7 files) | `domain/usecases/chatMessageList/` | OPTIONAL (use cases when orchestration is non-trivial) | HIGH |
| Domain interfaces import `data/models/**` (no domain entities) | every `domain/repositories/*.dart` | PROJECT-SPECIFIC (ADR-0005): single model layer | HIGH |
| `GeneralRepository` imports a presentation model (`commonWidgets/.../agreement_content.dart`) | `general_repository.dart:1` | ANTI-PATTERN (domain → presentation dependency) | HIGH |
| `domain/helper/` contains `BuildContext`, `Navigator`, `EasyLoading` (`chat_media_picker_helper.dart`, `image_picker_helper.dart`, `mention_text_editing_controller.dart`) | rg | ANTI-PATTERN (UI in domain) | HIGH |
| `OrbitsRepositoryImpl` depends on `FirebaseMessaging` to fetch FCM token for a query param | `orbits_repository_impl.dart:255` | NEEDS-DECISION (leak of platform concern into a feature repo) | MEDIUM |
| `contacts_repository_impl.dart:116` `UnimplementedError` behind TODO | file | LEGACY | HIGH |

## 6. Models and serialization

| Finding | Evidence | Class | Confidence |
|---------|----------|-------|-----------|
| freezed + json_serializable (`@freezed` + `part '*.g.dart'`) — 49 models | `data/models/responseModels/feed_entity.dart` | UNIVERSAL default | HIGH |
| FlutterJsonBeanFactory (`lib/generated/json/`, `$XFromJson`, custom `@JsonSerializable`) — 23 models | `user_info_response_model_entity.dart` | LEGACY (freeze; do not add) | HIGH |
| Handwritten `fromJson` — 6 models | `nearby_places_response.dart` | OPTIONAL for tiny models | HIGH |
| Naming mix: `*Entity`, `*Model`, `*ModelEntity`, `Model*Response*Entity` | file list | NEEDS-DECISION → convention in `sop/naming-conventions.md` | HIGH |
| Typos in file names: `model_reset_edication_*`, `model_inquery_*`, `completeProfile_request_model_entity.dart` (camelCase) | file list | LEGACY | HIGH |
| `lib/layers/data/models/responseModels/` declared as an **asset** folder in pubspec | `pubspec.yaml` flutter.assets | ANTI-PATTERN (ships source as asset) | HIGH |

## 7. Routing

| Finding | Evidence | Class | Confidence |
|---------|----------|-------|-----------|
| `auto_route` 11 with `@AutoRouterConfig(replaceInRouteName: 'Screen,Route')`, ~79 typed routes, nested tab routers, `AuthGuard` | `core/navigation/app_router.dart` | UNIVERSAL (typed routing) | HIGH |
| Screen-scoped providers via `AutoRouteWrapper.wrappedRoute` | ~36 screens | RECOMMENDED | HIGH |
| `context.router.*` 117 hits; `NavigationService` 25; `Navigator.push` 18; legacy `navigateToPage` (CupertinoPageRoute) still used from `edit_profile_screen.dart` | rg | `Navigator.push` for screens = LEGACY | HIGH |
| `deepLinkBuilder: (_) => DeepLink.defaultPath` disables auto_route deep links; custom `DeepLinkService` (`app_links`) resolves after login | `main.dart:101`, `core/deepLink/` | PROJECT-SPECIFIC (ADR-0004) | HIGH |
| Deep links: host/path switch, no validation of IDs, no auth binding | `deep_link_service.dart` | NEEDS-DECISION (security) | MEDIUM |
| Notification tap → `NotificationHandlerRegistry.route` → typed route | `core/notification/router/` | UNIVERSAL pattern | HIGH |

## 8. UI architecture

| Finding | Evidence | Class | Confidence |
|---------|----------|-------|-----------|
| `XScreen` naming (~91), `@RoutePage`, mostly `StatefulWidget`, per-feature `widgets/` folder, UI `model/` folders for view DTOs | `presentation/ui/**` | UNIVERSAL (Screen suffix, per-feature widgets) | HIGH |
| Folder naming mixed: `chatDetailsScreen` vs `profile_setting`, `widget/` vs `widgets/` | tree | NEEDS-DECISION → snake_case standard | HIGH |
| Design tokens exist (`AppColors`, `Dimensions`, `AppStyles`, `context.fontStyle*`) | `core/theme/` | UNIVERSAL (tokens) | HIGH |
| 1769 `Colors.*`, 169 `Color(0x`, 186 `fontSize:`, 199 `TextStyle(` in presentation | rg | ANTI-PATTERN (hardcoded design values) | HIGH |
| Two theme stacks: `MyAppTheme` (used) vs `AppTheme/LightTheme/DarkTheme/AppTextTheme` (unused) | `core/theme/` | LEGACY | HIGH |
| Duplicate widget kits — buttons: `ButtonWidget`, `MyButton`, `MyOutLineButton`, `BottomNavButton*`, `LoginBottomNavButton`; text fields: `MyTextField`, `LoginTextField`, `ExpandTextField`, `MyChatTextField`; loaders: `LoadingWidget`, `EmptyLoaderWidget`, raw indicators, `EasyLoading`; images: `MyNetworkImage`, `MyCircleNetworkImage`, `UserAvatar`, raw `CachedNetworkImage`, `Image.network` | `commonWidgets/`, `shared/`, `core/widgets/` | ANTI-PATTERN (duplication) | HIGH |
| Loading UX split between `EasyLoading.show()` in listeners (60 hits) and inline `LoadingWidget` | rg | NEEDS-DECISION | HIGH |
| No shared state-render widget (loading/error/empty) | rg | RECOMMENDED addition | HIGH |
| `common_dialogs.dart` 1224 lines | wc | ANTI-PATTERN (god file) | HIGH |
| `BaseResponsiveViewFull` used by ~36 screens but returns the same widget for every breakpoint | `login_screen.dart:221-234` | LEGACY | HIGH |
| Forms: `Form(` 3, `TextFormField`/`validator:` 0; validation imperative + toast | rg | NEEDS-DECISION | HIGH |
| Business logic in widgets: decrypt in tiles, join-range check in `join_orbit_section.dart:70-90`, contact filtering in `all_contacts_screen.dart:179-233`, phone sanitising in `login_screen.dart:236-285` | files | ANTI-PATTERN | HIGH |
| `old_chat_screen.dart` 1483 lines fully commented, unrouted, unimported | rg | LEGACY (delete) | HIGH |
| `flutter_localizations` present, no `.arb`/`AppLocalizations`; `AppString` ~288 uses + ~100 hardcoded `Text('...')` | rg | NEEDS-DECISION (l10n) | HIGH |
| `webview_page.dart` defines `WebViewScreen` | file | LEGACY (file/class mismatch) | HIGH |

## 9. Realtime, notifications, background

| Finding | Evidence | Class | Confidence |
|---------|----------|-------|-----------|
| `SocketManager` → `SocketClient` → `GlobalSocketRouter` → `*SocketHandler` → `GlobalEventBus` → subscribers | `core/realtime/`, `data/globalUpdatesHandler/` | PROJECT-SPECIFIC (ADR-0007), pattern RECOMMENDED | HIGH |
| Auth token passed in socket URL query string and logged at debug level | `socket_manager.dart:164-171`, `socket_client.dart` | ANTI-PATTERN (security) | HIGH |
| `EventSubscriberMixin.disposeSubscriptions` cancels but does not clear list | `event_subscriber_mixin.dart:17-21` | LEGACY defect | HIGH |
| Notifications: FCM + `flutter_local_notifications`, handler registry per type, MessagingStyle with Hive history, badge service | `core/notification/` | UNIVERSAL pattern | HIGH |
| `NotificationManager`, `NotificationRemoteDataSource`, `NetworkRequestQueue`, `VerifyOTPScreen`, `selfie_camera_screen` hold `.listen` without cancel | files | ANTI-PATTERN | HIGH |
| `Future.delayed` used ~50 times as timing hack (cold-start 1s, deep link 400-500ms, nearby places 3s) | rg | ANTI-PATTERN | HIGH |
| `flutter_background_service` + Geolocator for background location; git dep `background_location` appears unused in Dart | rg | LEGACY dep | MEDIUM |

## 10. Error handling and logging

| Finding | Evidence | Class | Confidence |
|---------|----------|-------|-----------|
| Single `Failure(error, statusCode)` Equatable; codes 101 unexpected, 110 no-internet, -1 timeout, 401, 403 | `failure.dart`, `dio_error_mapper.dart` | UNIVERSAL shape | HIGH |
| Failure → `state.error: String` → `AppConstant.showToast` in listener | e.g. `create_orbit_screen.dart:95-108` | UNIVERSAL flow | HIGH |
| Empty catches: `background_refresh_helper.dart:20`, `chat_ui_builder.dart:32`, `apply_sync_changes_use_case.dart:133`, `background_location_helper.dart:172` | rg | ANTI-PATTERN | HIGH |
| ~43 log-only catches in data/domain; `debugPrint(e.toString())` in `chat_contacts_repository_impl.dart:105` | rg | NEEDS-DECISION (define "log-and-continue" allowlist) | HIGH |
| `DebugLog` (logger, `kDebugMode`-gated) 443 hits; `debugPrint` 32; `print` 11 | rg | UNIVERSAL (`DebugLog`); `print` = ANTI-PATTERN | HIGH |
| `FlutterError.onError` assigned 3 times; final assignment `dumpErrorToConsole` disables Crashlytics for Flutter errors | `app_initializer.dart:40-49` | DEFECT (see remediation) | HIGH |
| Sensitive data logged at debug level: FCM token, socket URL with token, full notification payload | `notification_remote_data_source.dart:40`, `socket_client.dart` | ANTI-PATTERN | HIGH |

## 11. Persistence and security

| Finding | Evidence | Class | Confidence |
|---------|----------|-------|-----------|
| Hive boxes: `chat_drafts` (typeId 21), `notification_messages_box` (22), dynamic `chat_messages_cache_v1_<id>`, meta boxes; handwritten adapters | `data/localDB/`, `data/localModels/` | PROJECT-SPECIFIC (ADR-0006) | HIGH |
| `get_storage` wrapped by `EncryptedStorage` (AES-CBC); key = package name with `.`→`0` padded to 16; IV = padded platform name | `core/storage/encrypted_storage.dart:36-59` | ANTI-PATTERN (derivable key; not OS-backed) | HIGH |
| Auth token stored in `EncryptedStorage`, not Keychain/Keystore | `storage_keys.dart`, `auth_session_manager.dart` | NEEDS-DECISION (migrate to `flutter_secure_storage`) | HIGH |
| `clearSession` removes only `isLoggedIn`, `token`, `userId` | `app_storage_impl.dart` | DEFECT | HIGH |
| Env config via `--dart-define-from-file=config/<env>.json`; `config/*.json` gitignored | `service_locator.dart:34-36`, `.gitignore` | UNIVERSAL | HIGH |
| `TENOR_API_KEY` in config but never loaded; `Environment` enum unused | `config_injection.dart`, `app_config.dart` | LEGACY | HIGH |
| Hardcoded Google API key in `utils/extensions.dart:974`; Maps keys in `AndroidManifest.xml:51` and `Info.plist:46-47` | files | ANTI-PATTERN (hardcoded secret) | HIGH |
| `lib/firebase_options.dart`, `google-services.json`, `GoogleService-Info.plist` tracked in git | `git ls-files` | NEEDS-DECISION (common practice, but restrict keys in console) | HIGH |
| Release build uses `signingConfigs.debug` | `android/app/build.gradle:37-38` | DEFECT | HIGH |
| Chat message bodies encrypted at rest in Hive with session key | `chat_cache_data_source.dart` | PROJECT-SPECIFIC | MEDIUM |

## 12. Code quality, tests, tooling

| Finding | Evidence | Class | Confidence |
|---------|----------|-------|-----------|
| `analysis_options.yaml` = `flutter_lints` + `prefer_const_declarations` + `prefer_const_constructors` | file | NEEDS-DECISION (adopt stricter set, see `sop/code-quality.md`) | HIGH |
| `// ignore:` ~1450 (mostly generated), `ignore_for_file` ~143, `dynamic ` ~91 | rg | NEEDS-DECISION (audit non-generated ignores) | MEDIUM |
| Zero tests: `test/widget_test.dart` fully commented; no `bloc_test`, `mocktail`, `mockito` | `test/`, pubspec | ANTI-PATTERN | HIGH |
| Generated files committed (73 `.g.dart`, 67 `.freezed.dart`, 1 `.gr.dart`); no `build.yaml` | git ls-files | OPTIONAL (commit) — must be consistent | HIGH |
| Commit messages: one long numbered paragraph reused verbatim across 10+ commits, prefixed with branch name | `git log` | ANTI-PATTERN | HIGH |
| Branches: `phase_two_master`, `chat_master`, `ui_refactoring`, ...; remote is Bitbucket `master` | `git branch -a` | NEEDS-DECISION (branch naming) | HIGH |

---

## Summary counts

| Class | Count of findings |
|-------|------------------:|
| UNIVERSAL | 24 |
| PROJECT-SPECIFIC | 14 |
| RECOMMENDED | 6 |
| OPTIONAL | 4 |
| LEGACY | 20 |
| ANTI-PATTERN | 30 |
| NEEDS-DECISION | 22 |
| DEFECT (needs fix, tracked in `remediation-backlog.md`) | 4 |

Overall: a mature layered architecture with a sound core (DI, `Either` boundary, typed routing, event bus) whose main problems are **convention drift** (three state styles, three serialization stacks, two connectivity packages, mixed folder casing), **boundary leaks** (`sl<>` in widgets, UI in domain helpers), **security hygiene** (token in URL, weak storage crypto, debug signing, hardcoded keys), and **zero tests**.
