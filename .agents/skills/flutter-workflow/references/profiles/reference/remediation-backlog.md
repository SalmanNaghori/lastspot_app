# Remediation Backlog (discovered, NOT applied)

Every item below was found during the audit. **Nothing here has been changed.** Each item is a proposal for a separate, reviewable PR. Priorities: P0 = security/production defect, P1 = correctness/leak, P2 = architecture hygiene, P3 = cleanup.

| # | Pri | Item | Evidence | Proposed fix | Rule |
|---|-----|------|----------|--------------|------|
| R1 | P0 | Crashlytics disabled for Flutter framework errors: `FlutterError.onError` is assigned three times, last one is `dumpErrorToConsole` | `lib/layers/app/initializer/app_initializer.dart:40-49` | Single assignment: `FlutterError.onError = (d) { FlutterError.dumpErrorToConsole(d); FirebaseCrashlytics.instance.recordFlutterFatalError(d); }` | guardrails/security §Logging |
| R2 | P0 | Release APK signed with debug keystore | `android/app/build.gradle:37-38` `signingConfig = signingConfigs.debug` | Add `key.properties`-driven release signing config; keep keystore out of git | guardrails/security §Build |
| R3 | P0 | Auth token in socket URL query string; full URL logged | `core/realtime/socket/socket_manager.dart:164-171`, `socket_client.dart` `DebugLog.i("Socket connecting → $url")` | Send token via `auth` option / `extraHeaders`; redact URL in logs | guardrails/security §Tokens |
| R4 | P0 | Hardcoded Google API key in Dart | `lib/layers/utils/extensions.dart:974` | Use `sl<AppConfiguration>().googleApiKey` via injected config; restrict key in Google Cloud console | guardrails/security §Secrets |
| R5 | P0 | Maps API keys in `AndroidManifest.xml:51` and `Info.plist:46-47` (two different keys) | platform files | Inject via `manifestPlaceholders` / xcconfig from env; restrict by bundle id/SHA | guardrails/security §Secrets |
| R6 | P1 | AES key derived from package name, IV from platform name; token not in OS secure storage | `core/storage/encrypted_storage.dart:36-59` | Move token/keys to `flutter_secure_storage` behind `AppStorage`; keep GetStorage for non-sensitive prefs | ND-8 |
| R7 | P1 | `clearSession` leaves encryption key/IV, name, image, login flags | `core/storage/app_storage_impl.dart` | Clear all `StorageKeys` session-scoped keys on logout | sop/security |
| R8 | P1 | `badCertificateCallback` trusts any cert for staging host | `core/di/dioInjection/dio_injection.dart` | Compile out with `kReleaseMode` guard or remove; use proper staging cert | guardrails/networking |
| R9 | P1 | Emit after `await` without `isClosed` | `bloc/authBloc/auth_bloc.dart:59-65`, `cubit/locationCubit/location_cubit.dart`, `audio_player_cubit.dart`, `create_orbit_bloc.dart` | Add `if (isClosed) return;` after each await | rules/bloc |
| R10 | P1 | Uncancelled stream subscriptions | `core/network/queue/network_request_queue.dart:28-32`, `core/notification/manager/notification_manager.dart`, `data/remote/notification_remote_data_source.dart`, `presentation/auth/verify_otp_screen.dart:44`, `ui/profile/selfie_camera_screen.dart:38` | Store subscriptions; cancel in `dispose()`/`close()` | guardrails/performance |
| R11 | P1 | `EventSubscriberMixin.disposeSubscriptions` does not clear the list | `core/realtime/event_subscriber_mixin.dart:17-21` | `_subscriptions.clear()` after cancel | sop/async-programming |
| R12 | P1 | Sensitive data logged (FCM token, notification payload) | `data/remote/notification_remote_data_source.dart:40-43`, background handler | Remove or redact | guardrails/security |
| R13 | P1 | Deep links accept any id without validation or auth binding | `core/deepLink/` | Validate format; require session; ignore unknown hosts | ND-12 |
| R14 | P2 | `sl<>` inside widgets (~170) and cubit methods | see audit §2 | Inject via constructor / expose via state; start with `AuthStateProvider.userID` and `AppConfiguration.awsReferer` | guardrails/architecture |
| R15 | P2 | UI code in domain helpers (`BuildContext`, `Navigator`, `EasyLoading`) | `domain/helper/chat_media_picker_helper.dart`, `image_picker_helper.dart`, `mention_text_editing_controller.dart` | Move to `presentation/` helpers or split pure logic from UI | guardrails/architecture |
| R16 | P2 | `GeneralRepository` imports presentation model | `domain/repositories/general_repository.dart:1` | Move `AgreementContent` to `data/models` | guardrails/architecture |
| R17 | P2 | God files | `chat_contacts_base_cubit.dart` 758, `chat_message_list_cubit.dart` 667, `shared/common_dialogs.dart` 1224, `single_chat_screen.dart` ~30 providers | Split by responsibility; group chat providers into a `ChatScope` wrapper | guardrails/ui |
| R18 | P2 | Flag-style Bloc states | `auth_state.dart`, `create_orbit_state.dart`, `user_profile_state.dart` | Migrate to freezed + `Status` | ND-2 |
| R19 | P2 | Two connectivity packages | pubspec, `selfie_camera_screen.dart:38` | Remove `connectivity_plus`; use `NetworkMonitor` | ND-4 |
| R20 | P2 | Duplicate widget kits (5 buttons, 4 text fields, 3 loaders, 4 image paths) | audit §8 | Consolidate to one of each in `core/widgets`; deprecate others | guardrails/ui |
| R21 | P2 | Hardcoded design values (1769 `Colors.*`, 169 `Color(0x`) | presentation | Lint rule + incremental migration to `AppColors` | rules/ui |
| R22 | P2 | `lib/layers/data/models/responseModels/` listed as a Flutter asset | `pubspec.yaml` | Remove from `flutter.assets` | sop/configuration |
| R23 | P2 | `Future.delayed` timing hacks (~50) | notification cold start, deep link, nearby places | Replace with explicit readiness signals (`Completer`, `onAppReady`) | guardrails/performance |
| R24 | P2 | No tests | `test/widget_test.dart` commented | Add `bloc_test`, `mocktail`; start with `OrbitListCubit`, `AuthBloc`, `OrbitsRepositoryImpl` | sop/testing |
| R25 | P2 | Dio timeouts 120s | `dio_injection.dart:24-26` | 30s connect/receive; per-request override for uploads | ND-14 |
| R26 | P3 | Dead code: `old_chat_screen.dart` (1483 lines commented), `cubit/auth/*` commented, `CompleteProfileEvent`, `ThemeCubit`, `AppTheme/DarkTheme` stack, `Environment` enum, `TENOR_API_KEY`, `background_location` git dep, `contacts_repository_impl.dart:116` UnimplementedError | audit | Delete in one "remove dead code" PR | sop/code-quality |
| R27 | P3 | Stray root files `0`, `inspect_picker.dart`, `test_empty_notification.dart`; two READMEs | root | Delete; merge READMEs | sop/git-and-pr |
| R28 | P3 | Version pin mismatch `.fvmrc` vs `.tool-versions` | root | Align to 3.38.3 | ND-11 |
| R29 | P3 | Vendored `CountryCodePicker` inside `lib/` | `lib/layers/app/custom/CountryCodePicker/` | Move to `packages/`; path dep `../packages/country_code_picker` | sop/dependency-management |
| R30 | P3 | `ChatPinnedBloc` registered in cubits module; `ChatMessagingBloc` state named `LastMessageState`; `webview_page.dart` defines `WebViewScreen`; typo filenames | various | Rename/move in a hygiene PR | sop/naming-conventions |
| R31 | P3 | `ApiEndpoints` duplicates and inconsistent leading `/` | `core/network/client/api_endpoints.dart` | Deduplicate; one convention | sop/networking |
| R32 | P3 | Commit messages duplicated verbatim across 10+ commits | `git log` | Adopt Conventional Commits | sop/git-and-pr |
| R33 | P3 | `analysis_options.yaml` minimal | file | Adopt curated stricter lint set | ND-10 |

## Suggested sequencing

1. **Week 1 (P0):** R1, R2, R3, R4, R5 — each a small isolated PR.
2. **Week 2 (P1):** R6 + R7 together (storage), R8, R9, R10 + R11, R12, R13.
3. **Ongoing (P2):** R14–R25 incrementally, one feature area per PR, each adding tests (R24).
4. **Cleanup (P3):** R26–R33 in hygiene PRs that touch no behaviour.
