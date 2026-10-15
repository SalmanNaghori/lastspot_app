# Reference rules overlay (historical)

These PROJECT / LEGACY / DECISION lines belonged with the reference profile.
Active projects use `docs/project/flutter/project-rules.md` instead.

# From architecture.rules
## Project
PROJECT   PR-A1  Keep lib/layers/{app,base,core,data,domain,presentation,utils}; do not add lib/features/. (ADR-0001)
PROJECT   PR-A2  Placement: interface -> domain/repositories; impl -> data/repositoryImpl; models -> data/models/<group>Models; cubit -> presentation/cubit/<x>_cubit; screen -> presentation/ui/<feature>/ + widgets/.
PROJECT   PR-A5  Do not import layers/utils/exports.dart from new data/, domain/ or core/ files.
PROJECT   PR-B3  sl<>() allowed only in core/di/**, BlocProvider.create, wrappedRoute, AppBootStartup, SplashScreen.
PROJECT   PR-B4  Dependency-free UI cubits may be constructed directly in BlocProvider(create: (_) => XCubit()) with a comment.
LEGACY    L-A1   camelCase directories (chatDetailsScreen, repositoryImpl) — do not create more; rename only in hygiene PRs.
LEGACY    L-A2   lib/layers/app/custom/CountryCodePicker — do not add code; move to packages/ (R29).
LEGACY    L-A3   utils/exports.dart mega-barrel — presentation may still use it; nothing new depends on it.

# From bloc.rules
## Project
PROJECT   PR-C1   Extend BaseCubit<S>: implement onInternetRestored() and stateWithFailure(); use handleFailure in fold.
PROJECT   PR-C3   New Bloc events follow <Noun><Verb>Requested / past-tense facts; existing On*Event names are LEGACY.
LEGACY    L-B1    AuthBloc/AuthState flag style and missing isClosed (R9, R18) — do not copy.
LEGACY    L-B2    UserProfileBloc public imperative methods — do not extend; add events instead.
LEGACY    L-B3    ChatPinnedBloc registered in CubitsInjection; ChatMessagingBloc state named LastMessageState — fix in hygiene PR (R30), do not replicate.

# From dependency.rules
## Project
PROJECT   PR-B1  Repositories -> RepositoryInjection; blocs -> BlocsInjection; cubits -> CubitsInjection; infra -> AppLevelInjection/ExternalDependency.
PROJECT   PR-H1  bloc_test + mocktail are pre-approved dev dependencies (ND-9).
DECISION  ND-3   bloc_concurrency not adopted; guard double-submit with status checks + isClosed. Propose via ADR if >5 blocs need transformers.
DECISION  ND-4   Use NetworkMonitor (internet_connection_checker_plus) only; do not use connectivity_plus in new code (removal R19).
LEGACY    L-D1   background_location (git), aws_rekognition_api, aws_client — unused; do not reference (R26).
LEGACY    L-D2   country_code_picker path dep inside lib/ (R29).
LEGACY    L-D3   dependency_overrides uuid/http/intl — review each release; do not add more without a comment.

# From error.rules
## Project
PROJECT   PR-ERR1 Failure codes: 101 unexpected, 110 noInternet, -1 timeout, 401/403 from HTTP. Use the constants, not literals.
PROJECT   PR-ERR2 BaseCubit.handleFailure(failure, isSyncing:, hasData:) is the standard fold-left handler.
LEGACY    L-E1   FlutterError.onError assigned 3x in app_initializer.dart (R1) — fix, don't replicate.
LEGACY    L-E2   Empty/log-only catches listed in audit §10 — do not add; fix when touching the file.
LEGACY    L-E3   update_ui_mixin.dart returning 'Parse error: $e\n$st' in Failure.error — replace with generic message + log.

# From flutter.rules
## Project
DECISION  ND-10  Lint set minimal today; adopt the FL-3 extras (or very_good_analysis) via a dedicated PR.
DECISION  ND-13  Commit convention: Conventional Commits from now on.
LEGACY    L-F1   11 print( / 32 debugPrint( in lib — do not add; replace when touching.
LEGACY    L-F2   Root scratch files (`0`, inspect_picker.dart, test_empty_notification.dart), two READMEs — delete in hygiene PR R27.
LEGACY    L-F3   old_chat_screen.dart, cubit/auth/* fully commented — delete in R26.

# From naming.rules
## Project
PROJECT   PR-A3   Existing camelCase directories stay until a hygiene PR; never rename in feature PRs.
PROJECT   PR-C3   New Bloc events follow NAME-16; existing On*Event names are LEGACY.
PROJECT   PR-D5   New models: XEntity / XReqModel (majority convention).
LEGACY    L-NM1   Typo filenames (model_reset_edication_*, model_inquery_*), webview_page.dart containing WebViewScreen, fetch_gifcubit_cubit.dart — fix only in hygiene PR R30.

# From networking.rules
## Project
PROJECT   PR-D1..D7 See docs/project/flutter/project-rules.md §D.
DECISION  ND-5   FJBF models: frozen; migrate opportunistically to freezed.
DECISION  ND-14  Timeouts 120s -> propose 30s default with upload overrides (R25).
LEGACY    L-N1   ApiEndpoints `API` suffix and duplicates (aboutUs/aboutUsAPI) — reuse existing names, add no new duplicates (R31).
LEGACY    L-N2   OrbitsRepositoryImpl depending on FirebaseMessaging for FCM token — prefer an injected DeviceTokenProvider for new code.
LEGACY    L-N3   GeneralRepository importing a presentation model (R16) — do not extend.

# From performance.rules
## Project
PROJECT   PR-C6   easy_debounce is the debounce mechanism; cancel key in close().
PROJECT   PR-PERF1 Reference good patterns: RepaintBoundary on GoogleMap, compute in parseResponse, Dio BackgroundTransformer — keep.
LEGACY    L-P1    Uncancelled listens in NetworkRequestQueue, NotificationManager, NotificationRemoteDataSource, VerifyOTPScreen, selfie_camera_screen (R10) — fix, don't copy.
LEGACY    L-P2    ~50 Future.delayed readiness hacks (R23) — do not add; replace with signals when touching.
LEGACY    L-P3    EventSubscriberMixin.disposeSubscriptions lacks clear() (R11).
LEGACY    L-P4    Unbounded MarkerUtils cache — add bound when touching.

# From routing.rules
## Project
PROJECT   PR-E1..E4 See docs/project/flutter/project-rules.md §E. Route naming via replaceInRouteName: 'Screen,Route'.
PROJECT   PR-E5  auto_route deep-link resolution is disabled (deepLinkBuilder -> defaultPath); DeepLinkService handles links after login (ADR-0004). Do not re-enable without an ADR.
DECISION  ND-12  Deep-link id validation and session binding — add (R13).
LEGACY    L-R1   navigateToPage + Navigator.push (18 hits) — do not add; migrate when touching those screens.
LEGACY    L-R2   21 root BlocProviders in main.dart — do not add more; scope new state per route.

# From security.rules
## Project
PROJECT   PR-G1..G3 See docs/project/flutter/project-rules.md §G.
DECISION  ND-8   Token storage stays in EncryptedStorage until migrated (R6). Do NOT add new sensitive keys to EncryptedStorage; new sensitive data waits for SecureAppStorage.
LEGACY    L-SEC1 Hardcoded Google key utils/extensions.dart:974; Maps keys in manifest/plist (R4, R5) — do not reference the literals; use AppConfiguration.googleApiKey.
LEGACY    L-SEC2 Token in socket URL + logged (R3) — do not copy pattern.
LEGACY    L-SEC3 Release signed with debug config (R2); staging cert bypass (R8); FCM token/payload logging (R12); incomplete clearSession (R7) — tracked, do not replicate.

# From state.rules
## Project
PROJECT   PR-C1  New data-loading Cubits extend BaseCubit<S> and implement onInternetRestored + stateWithFailure.
PROJECT   PR-C2  New states: @freezed with Status status, String error, int errorCode.
PROJECT   PR-C5  Page size default 10 (chat 20 per ADR-0007).
PROJECT   PR-C6  Debounce with easy_debounce; cancel key in close(). No new Timer-based debouncing.
DECISION  ND-1   BaseCubit adoption: default = adopt for all new data cubits.
DECISION  ND-2   Legacy flag states (AuthState, CreateOrbitState, UserProfileState): leave until migrated (R18); never extend the flag style.
LEGACY    L-S1   Per-feature status enums (ContactsStatus, CommentsStatus) — do not add more.
LEGACY    L-S2   isPaginating bool pagination (ChatMessageList, BondList) — do not copy.

# From testing.rules
## Project
PROJECT   PR-H1  Every new/modified Bloc/Cubit ships test/presentation/<name>_test.dart with bloc_test + mocktail (pre-approved, ND-9).
PROJECT   PR-H2  Every new repository impl ships a test mocking BaseApiService.
PROJECT   PR-H3  First backfill targets: OrbitListCubit, AuthBloc, OrbitsRepositoryImpl, DioErrorMapper, AuthInterceptor (R24).
LEGACY    L-T1   test/widget_test.dart is fully commented — replace, do not extend.

# From ui.rules
## Project
PROJECT   PR-F1..F4 See docs/project/flutter/project-rules.md §F.
PROJECT   PR-F2  Reuse: MyButton/MyOutLineButton (core/widgets), MyTextField, MyNetworkImage, LoadingWidget, ErrorView, AppConstant.showToast, CustomBottomSheet.
LEGACY    L-U1   1769 Colors.* / 169 Color(0x / 186 fontSize: in presentation — never add; migrate when touching a file (R21).
LEGACY    L-U2   Duplicate kits (ButtonWidget, LoginBottomNavButton, LoginTextField, ExpandTextField, EmptyLoaderWidget...) — do not extend (R20).
LEGACY    L-U3   old_chat_screen.dart, BaseResponsiveViewFull, webview_page.dart naming, common_dialogs.dart 1224 lines — do not extend (R17, R26, R30).
LEGACY    L-U4   ~170 sl<>() in widgets — do not add; when touching a widget, replace with state/params (R14).



---

# Evidence and status notes moved out of the universal kit

These lines were removed from `.agents/skills/flutter-workflow/references/sop/` and `.agents/skills/flutter-workflow/references/guardrails/` when the kit was made stack-neutral (check paths now use the variables in `guardrails/README.md`). They describe the **reference snapshot only**. `R*` ids refer to `remediation-backlog.md` in this folder; `ND-*` ids here are the snapshot's own numbering, not the active project's `docs/project/flutter/project-rules.md` §I.


## From `guardrails/ai-development.md`

- **AI-11** — The agent MUST place new files according to `sop/project-structure.md` and the project's orientation. A feature MUST NOT be split across `lib/features/` and `lib/layers/`. The agent MUST NOT bulk-move a legacy tree. On a Strangler project, new files for an existing feature go in that feature's current tree.
- git diff -U0 | rg "^\+.*sl<" | rg -v "BlocProvider|wrappedRoute|create:"   # DI-2 / UI-1

## From `guardrails/architecture.md`

- Layer First: `rg "import 'package:<app>/(layers/)?presentation" lib/layers/{domain,data,core}` → must be empty.
- Layer First: `rg -l "BuildContext|Navigator\.|EasyLoading|Fluttertoast|showDialog|showModalBottomSheet" lib/layers/{domain,data}` → must be empty.
- Layer First: `rg -l "presentation/(ui|cubit|bloc)" lib/layers/core --glob '!**/di/**' --glob '!**/navigation/**' --glob '!**/notification/**'`.
- Layer First: `rg -l "Repository|DataSource|BaseApiService|Dio\(" lib/layers/presentation/ui lib/layers/presentation/commonWidgets lib/layers/presentation/auth`
- Check: review; heuristics `rg "decryptString|distanceBetween|\.where\("` on `lib/layers/presentation/ui` **or** `lib/features/**/views` `lib/features/**/widgets`.
- Check: new paths for feature `foo` appear under only one of `lib/features/foo/` and `lib/layers/**/foo*`. Stay: `git diff --name-only | rg '^lib/features/'` is empty unless Feature First is already the tree.
- Only via `checklists/exception-request.md` + ADR. Known accepted deviations for the **reference** snapshot: layer-first orientation (example ADR-0001); use cases limited to chat (ADR-0005). Those examples are not greenfield defaults. Brownfield Strangler (mixed trees, one orientation per feature) is the allowed mixed form — not an exception to ARCH-7.

## From `guardrails/dependencies.md`

- Known violations (tracked, not yet fixed): `connectivity_plus` duplicate (DEP-2), `background_location` / `aws_*` unused (DEP-8), `country_code_picker` vendored in `lib/` (DEP-7), `depend_on_referenced_packages` ignores (DEP-5), pin mismatch (DEP-11). See `profiles/reference/remediation-backlog.md`.

## From `guardrails/networking.md`

- **NET-1** — All HTTP MUST go through the single API gateway (`BaseApiService` in the reference). The HTTP client (`Dio`) MUST NOT be imported or constructed outside `core/network` and the DI module.
- Check: `rg -l "executeAPI|BaseApiService" lib/layers/presentation lib/layers/domain --glob '!**/repositories/**'` → must be empty.
- Check: `rg -n "url: '" lib/layers/data` and `rg -n "https?://" lib/layers/data lib/layers/presentation --glob '!**/api_endpoints.dart'`.
- Check: `rg -n "Authorization|statusCode == 401" lib/layers/data` → must be empty.
- Check: `rg -n -B3 "badCertificateCallback" lib` shows the guard. (Reference violation: `dio_injection.dart`, R8.)
- Check: `rg -n "token=|\?token|'token': " lib/layers/core` → must be empty. (Reference violation: `socket_manager.dart`, R3.)
- Check: `rg -l "package:connectivity_plus/" lib` should be empty once ND-4 is executed.
- Check: `rg -n "Future<(?!Either)" lib/layers/domain/repositories` → must be empty.
- Check: `rg -n "try \{" lib/layers/presentation/{cubit,bloc}` → review each; only non-repository async work permitted.
- Check: `rg -n "Failure\('.*\$e" lib` → review. (Reference: `update_ui_mixin.dart` parse error message.)
- Check: `rg -c "FlutterError.onError =" lib` → 1. (Reference: 3, R1.)
- Tracked: R1, R3, R8, R25 (timeouts), R31 (endpoint duplicates), ND-4, ND-5, ND-14.

## From `guardrails/performance.md`

- Check: `rg -n "ListView\(\s*$|ListView\(children" lib/layers/presentation/ui` → review.
- Check: `rg -n "jsonDecode|decryptString|\.sort\(|await " lib/layers/presentation/ui` inside `build` → review.
- Check: files containing `.listen(` must contain `cancel()`; `rg -n "\.listen\(" lib | rg -v "_sub|Subscription|listenTo"` → review. (Reference violations R10.)
- Check: `rg -n "Future.delayed" lib` → each hit is either a named UX constant or a violation. (Reference: ~50, R23.)
- Check: `event_subscriber_mixin.dart` `disposeSubscriptions` contains `clear()`. (Reference: R11.)
- Check: `rg -n "registerLazySingleton\(" lib/layers/core/di | rg -v "dispose:"` → review each for owned resources.
- Tracked: R10, R11, R23; hot-screen rebuild scoping (7 `BlocSelector` vs 896 `context.read`); unbounded `MarkerUtils` cache.

## From `guardrails/routing.md`

- Check: `rg -n "Navigator\.(push|pushReplacement)\(|CupertinoPageRoute\(|MaterialPageRoute\(" lib/layers/presentation` → new hits are violations (reference legacy: 18, `navigateToPage`).
- Check: `rg -n "pushNamed\(|'/[a-z]" lib/layers/presentation --glob '!**/app_router.dart'`.
- Check: `rg -l "router\.|NavigationService|navigatorKey" lib/layers/presentation/{cubit,bloc} lib/layers/data lib/layers/domain` → must be empty.
- Legacy `Navigator.push`/`navigateToPage` (R30), deep-link validation (R13/ND-12), 21 root providers (ROUTE-8 SHOULD).

## From `guardrails/security.md`

- Check: `rg -n "AIza[0-9A-Za-z_-]{30,}|sk_live|Bearer [A-Za-z0-9._-]{20,}|apiKey\s*[:=]\s*'" lib android/app/src ios/Runner` → must be empty. (Reference violations: `utils/extensions.dart:974`, manifest, plist — R4, R5.)
- Check: `rg -n "packageName|Platform\.(isAndroid|isIOS)" lib/layers/core/storage` → review key derivation. (Reference: `encrypted_storage.dart`, R6/ND-8 — accepted deviation pending decision; no new sensitive keys may be added to it.)
- Check: `rg -n "token=|\?token" lib` → must be empty. (Reference: R3.)
- Check: compare `StorageKeys` session keys with `clearSession()` body. (Reference: R7.)
- Check: `rg -n "DebugLog\.\w+\(.*(token|Token|otp|phone|payload|url)" lib` → review each. (Reference: R3, R12.)
- Check: `rg -c "FlutterError.onError =" lib` → 1. (Reference: R1.)
- Check: `rg -n "usesCleartextTraffic=\"true\"|http://" android/app/src/main/AndroidManifest.xml lib/layers/core` → review.
- Check: `rg -n -B5 "badCertificateCallback" lib` shows guard. (Reference: R8.)
- Check: review `DeepLinkService`, `NotificationHandlerRegistry`. (Reference: R13.)
- Check: `rg -n "signingConfig signingConfigs.debug|signingConfig = signingConfigs.debug" android/app/build.gradle*` → must be empty. (Reference: R2.)
- P0 items R1–R5, P1 items R6–R8, R12, R13 in `profiles/reference/remediation-backlog.md`. ND-8 (token storage backend) is an open decision; until resolved, no new sensitive data may be added to `EncryptedStorage`.

## From `guardrails/state-management.md`

- Check: `wc -l lib/layers/presentation/{cubit,bloc}/**/*.dart | sort -n | tail`.
- Check: `rg -n "Future.delayed" lib/layers/presentation/{cubit,bloc}`.
- Legacy flag states (`AuthState`, `CreateOrbitState`), `isClosed` gaps (`AuthBloc`, `LocationCubit`), dead `CompleteProfileEvent`, `UserProfileBloc` public methods — tracked in `profiles/reference/remediation-backlog.md` R9, R18, R26.

## From `guardrails/testing.md`

- Check: `rg -n "sl<|GetIt|Future.delayed|Dio\(" test` → must be empty (except boot smoke tests explicitly named).
- Zero tests exist. TEST-1..4 apply to all new and modified code immediately; backfill tracked as R24 (`profiles/reference/remediation-backlog.md`). Test stack decision ND-9 defaults to `bloc_test` + `mocktail`.

## From `guardrails/ui.md`

- **UI-1** — Widgets MUST NOT resolve services from the container (`sl<>`), call repositories, data sources or the HTTP gateway, or access storage directly. Values come from state or constructor parameters.
- Check: `rg -n "sl<|AppStorage|Hive\.|GetStorage" lib/layers/presentation/ui lib/layers/presentation/commonWidgets lib/layers/presentation/shared lib/layers/presentation/auth | rg -v "BlocProvider\(|wrappedRoute|create:"` → must be empty.
- Check: `rg -n "await .*[Rr]epository|decryptString\(|distanceBetween\(" lib/layers/presentation/ui`.
- Check: `rg -n "Colors\.(?!transparent)|Color\(0x|fontSize:" lib/layers/presentation --glob '!**/core/theme/**'` → new hits are violations (reference legacy: 1769 / 169 / 186).
- Check: `rg -l "class \w*(Button|TextField|Loader|Loading|NetworkImage|Avatar)\w* extends" lib/layers/presentation lib/layers/core/widgets` and compare with new classes in the PR.
- Check: `rg -n "Text\(\s*'[A-Za-z]" lib/layers/presentation --glob '!**/app_string*.dart'` → new hits are violations.
- Check: `rg -n "ListView\(\s*children:" lib/layers/presentation/ui` → review.
- Check: `rg -n "Future.delayed" lib/layers/presentation/ui` → review each; only intentional UX delays with a named constant are allowed.
- Check: `rg -n "Image\.network\(|CachedNetworkImage\(" lib/layers/presentation --glob '!**/my_network_image*.dart' --glob '!**/core/widgets/**'`.
- Check: `rg -n "appContext" lib/layers/presentation`.
- Tracked: R14 (`sl<>` in widgets), R17 (god files), R20 (duplicate kits), R21 (hardcoded colors), R23 (`Future.delayed`), R26 (`old_chat_screen.dart`), ND-6 (l10n), ND-7 (loader style).

## From `sop/README.md`

- and an evidence confidence (`HIGH` / `MEDIUM` / `LOW`). Rules with LOW confidence are never mandatory.
- SOPs were stress-tested against a real L3 app (snapshot in [`../profiles/reference`](.)). Where a SOP says "reference project", that means **optional examples** — not the active stack. Active choices live in [`../project`](../../../../../../docs/project/flutter) + ADRs. Patterns were promoted to UNIVERSAL only when sound in isolation; harmful ones became LEGACY or ANTI-PATTERN.

## From `sop/architecture.md`

- The reference project snapshot is **L3, layer-first** (example ADR-0001 in `docs/adr/`; see `profiles/reference/`). That example is **not** the greenfield default.
| Anti-pattern | Why it hurts | Observed in reference project |
| Widget resolves services from the container | Hidden dependencies, untestable widgets | ~170 `sl<` hits in `presentation/ui` |
| Domain imports presentation models | Reverses dependency direction | `general_repository.dart:1` |

## From `sop/async-programming.md`

- Store every `StreamSubscription`; cancel in `close()` / `dispose()`. Reference leaks: `NetworkRequestQueue`, `NotificationManager`, `NotificationRemoteDataSource`, `VerifyOTPScreen`, `selfie_camera_screen` (R10).
- A subscription helper mixin (reference `EventSubscriberMixin`) must both cancel **and clear** its list (R11).
- `Future.delayed` is acceptable only for **intentional UX delays** (splash minimum, animation sequencing), never to wait for another component to be ready. Reference has ~50 uses, many as readiness hacks (cold-start notification 1 s, deep link 400–500 ms) — ANTI-PATTERN (R23). Replace with a `Completer`/`onAppReady` signal or a stream event.
- Fix: `network_request_queue.dart:28-32` unstored listen; `event_subscriber_mixin.dart:17-21` no clear.

## From `sop/bloc.md`

- `part`/`part of` for event/state files is OPTIONAL; pick one style per project. The reference project mixes both (NEEDS-DECISION → default: separate files with imports, freezed state).
- The reference project does not use `bloc_concurrency` (ND-3). Until decided, Cubits use the right-hand column; new Blocs that need per-intent policy should propose adding `bloc_concurrency` (dev cost: one dependency, no code changes elsewhere).
- No `sl<>()`/`GetIt.I` inside the class body (observed violations: `location_cubit.dart:262`).
- Reference `BaseCubit` (`lib/layers/base/base_cubit.dart`): network-restore hook, staleness, `handleFailure → stateWithFailure`. Adopt it for every data-loading Cubit (ND-1 default: adopt).

## From `sop/code-quality.md`

- ### Lints (RECOMMENDED; ND-10 for reference)
- No commented-out code blocks in merged code (reference: `old_chat_screen.dart` 1483 lines, `cubit/auth/*` 512 lines — delete, R26).
- Periodic check: `dart run dart_code_metrics:metrics check-unused-code lib` (or `flutter analyze` `unused_element`) — reference dead items listed in R26.
- Before writing: search for an existing helper/widget/model/endpoint (`rg`). Three similar lines are fine; a copied method or widget is not. Reference: duplicate widget kits, duplicate endpoint constants.
- Allowed only with a trailing reason: `// ignore: avoid_dynamic_calls — Hive returns dynamic here`. `ignore_for_file` only in generated files. Reference: ~1450 ignores, mostly generated; audit the hand-written ones.

## From `sop/configuration.md`

- ### Mechanism (UNIVERSAL, HIGH; ADR-0008)
- One pin source (`.fvmrc` **or** `.tool-versions`) plus `environment.sdk` in `pubspec.yaml`; README states the version. Reference has `.fvmrc` 3.32.6 and `.tool-versions` 3.38.3 (ND-11) — align.
- `pubspec.yaml` `flutter.assets` lists only asset directories. Source directories are never assets (reference lists `lib/layers/data/models/responseModels/` — R22).

## From `sop/dependency-injection.md`

- ### Container (RECOMMENDED; PROJECT-SPECIFIC choice: get_it, ADR-0002)
- Expose one alias (`sl` in the reference project) and never call `GetIt.I` elsewhere.
- Split registrations into modules by kind and call them in dependency order from one `setupLocator()`. Document the order (the reference project's `service_locator.dart` comment block is the model).
- ### Resolution points — where `sl<>()` is allowed (UNIVERSAL, HIGH)
- If a widget needs a value (current user id, a config URL), it comes from **state** (a Cubit exposes it) or from a **constructor parameter**, not from `sl<AuthStateProvider>().userID` (observed ~170 times in the reference UI — ANTI-PATTERN).
- Bad (reference): `heat_map_button.dart:53` `sl<AppStorage>()` inside a widget; `chat_details_helpers.dart` `sl<AuthStateProvider>()`; `ChatDraftRepositoryImpl()` opening a Hive box by name internally; `GlobalVariable.appContext` used by `Dimensions`.

## From `sop/dependency-management.md`

- 5. **Every dependency has a documented purpose** (the reference project's commented `pubspec.yaml` groups are a good practice — keep it).
- Keep `pubspec.yaml` grouped by category with a one-line purpose comment per package (reference project does this). Add a `## Dependencies` section to the project README linking to `profiles/reference/dependency-inventory.md`.
- Vendored incorrectly: `country_code_picker` inside `lib/layers/app/custom/`.

## From `sop/error-handling.md`

- Reference project has `Failure(error, statusCode)` with app codes 101 (unexpected), 110 (no internet), -1 (timeout). Adding `kind` is RECOMMENDED so UI branches on an enum rather than magic numbers.
- `FlutterError.onError` and `PlatformDispatcher.instance.onError` set **once**, both logging to console in debug and recording to Crashlytics (or equivalent). Reference sets `FlutterError.onError` three times, last one dropping Crashlytics (R1).
- Good (reference): `network_api_impl.dart:62-100` — catches Dio/Socket/Type/Format/fallback separately; `BaseCubit.handleFailure` distinguishes no-internet and "has data".
- Fix (reference): `app_initializer.dart:40-49`; empty catches listed in audit §10; `update_ui_mixin.dart:55` stack trace in user message.

## From `sop/feature-architecture.md`

| Part | Add when | Reference-project precedent |
| Part | Feature First | Layer First (reference) |
- ### Layer First thin feature (reference)
- Example list-feature template:

## From `sop/git-and-pr.md`

- Reference project uses `phase_two_master`, `chat_master`, `ui_refactoring` (NEEDS-DECISION ND-13); adopt the scheme above for new branches.
- [ ] no secrets / no new hardcoded design values / no new `sl<>` in widgets
- No scratch files at root (reference: `0`, `inspect_picker.dart`, `test_empty_notification.dart` — R27).

## From `sop/models-and-data.md`

| Layer | Create when | Reference project |
| Domain entity | API shape is unstable, multiple backends, or business logic needs a different shape | **Not used** — API models flow to UI (ADR-0005) |
- FlutterJsonBeanFactory (`lib/generated/json/`) and any IDE-plugin generator are LEGACY in the reference project (23 models): fix bugs only, never add models, migrate opportunistically (ND-5).
- Model files listed as Flutter assets (`pubspec.yaml` lists `lib/layers/data/models/responseModels/` — remove).

## From `sop/naming-conventions.md`

- Each row: current reference-project convention → universal standard. Where they differ, new code follows the universal column; existing code is LEGACY.
| Item | Reference project (observed) | Universal standard | Class |
| Item | Reference project | Universal standard |
| Item | Reference project | Universal standard |
| Screen (routed) | `XScreen` (~91) | `XScreen` |
| Item | Reference project (mixed) | Universal standard | Class |
| Item | Reference project (mixed) | Universal standard |
| Response model | `OrbitEntity`, `LoginResponseModelEntity`, `ModelChatListResponseEntity` | `XEntity` for API response models when no separate domain entity exists (reference-project choice); universally `XDto`/`XModel` when a domain entity also exists. Never `Model*Response*Entity`. |
| Endpoint constants | `fetchOrbitListAPI`, `login`, `aboutUs`/`aboutUsAPI` | `lowerCamelCase` verb-noun, no `API` suffix, no duplicates: `fetchOrbitList`, `login`, `aboutUs` (reference's `API` suffix is LEGACY) |
- Renames of existing public names are out of scope for feature PRs; schedule hygiene PRs (see `profiles/reference/remediation-backlog.md` R30).

## From `sop/networking.md`

- ### Gateway (UNIVERSAL; reference: `BaseApiService` / `NetworkAPIImpl`, ADR-0005)
- Connect 15–30 s, receive 30 s, send 30 s; uploads override per request. The reference project's 120 s everywhere is NEEDS-DECISION (ND-14).
- Repository receives `dynamic` JSON from the gateway and parses with the model's `fromJson`. Large payloads parse in an isolate (`compute`). Parsing errors become `Failure`, not crashes. Reference: `UpdateUiMixin.backToUI` + `parseResponse` (PROJECT-SPECIFIC helper implementing this universal rule).
- No `badCertificateCallback` that returns `true` in release builds. Reference project trusts any cert for the staging host — must be compiled out (`kReleaseMode`) or removed (R8).
- Socket transport wrapped in a client class; a manager handles connect/auth/reconnect; handlers translate raw events to typed events on a bus. Auth token goes in headers/auth payload, **never** in the URL query string (reference violates this — R3).
- Reference (fix): `dio_injection.dart` cert bypass; `socket_manager.dart:164-171` token in URL.

## From `sop/performance.md`

- Fix (reference): 896 `context.read` / 7 `BlocSelector` suggests wide rebuilds — migrate hot screens (chat, home) to `BlocSelector`/`buildWhen`; uncancelled subscriptions (R10); unbounded marker cache.

## From `sop/project-structure.md`

- ### L3 Layer First (PROJECT-SPECIFIC when chosen) — reference project
- Example ADR-0001 documents this tree for the reference snapshot. Greenfield projects write their own ADR-0001; do not copy this layout unless Layer First was chosen.
- **Directories `snake_case`** (UNIVERSAL, HIGH). The reference project mixes `chatDetailsScreen` and `profile_setting`; new directories must be snake_case, existing ones are LEGACY and renamed only in dedicated hygiene PRs.
- **Generated files** (`*.g.dart`, `*.freezed.dart`, `*.gr.dart`): commit them (RECOMMENDED — simpler CI, reviewable diffs) or ignore them, but never mix. The reference project commits them.
- **Vendored packages** live in `packages/<name>` with a `path:` dependency, never under `lib/` (ANTI-PATTERN observed: `lib/layers/app/custom/CountryCodePicker/` with its own `ios/` and `.github/`).
- **Assets**: only `assets/**` (and package flag folders). Source directories must not be listed under `flutter.assets` (ANTI-PATTERN observed: `lib/layers/data/models/responseModels/`).
- Good (Layer First): `lib/layers/presentation/cubit/orbitListCubit/{orbit_list_cubit.dart, orbit_list_state.dart, orbit_list_state.freezed.dart}` — cohesive, generated file beside source (directory casing aside).
- Bad: `lib/layers/presentation/cubit/interest_selection_cubit.dart` loose at the cubit root while every other cubit has a folder.
- Same concept in two folders (`commonWidgets/`, `shared/`, `core/widgets/` all hold shared widgets in the reference project). Pick one home per kind.

## From `sop/repository.md`

- Reference project uses API models throughout (no domain entities, ADR-0005). Repository interfaces therefore import `data/models`. Universally, if a domain entity layer exists, the interface returns entities and the impl maps.
- Fix: `general_repository.dart` imports `presentation/.../agreement_content.dart` (move model to data); `contacts_repository_impl.dart:116` `UnimplementedError`.

## From `sop/routing.md`

- ### Package (RECOMMENDED; reference: auto_route, ADR-0004)
- Never navigate to a protected screen from a link before the session is restored; queue until app ready (reference does this after login — keep, but validate ids: R13).
- Good (reference): `create_orbit_screen.dart:95-108` — `BlocListener` navigates on success; `app_router.dart` nested `DashboardTabRoute` children with guard.
- Full-screen media viewers or overlays that need custom transitions may use `Navigator.push` with a `PageRouteBuilder` **if** they are not addressable screens; add a comment referencing this exception. (Reference: `message_action_route.dart` overlay.)

## From `sop/security.md`

- Build-time values via `--dart-define-from-file=config/<env>.json` (gitignored) → typed config object (ADR-0008). Native-side keys (Maps) via `manifestPlaceholders` / xcconfig fed from the same source.
- Reference violations: Google key literal `utils/extensions.dart:974`; Maps keys in manifest/plist (R4, R5).
- Never in URL query strings (reference socket URL — R3). Sockets authenticate via `auth` payload or headers.
- Logout clears **all** session-scoped keys (reference `clearSession` leaves keys — R7).
- Reference project's AES-over-GetStorage with a key derived from the package name is obfuscation, not protection (R6, ND-8). Universal rule: derive keys from OS secure storage or a server-issued secret, never from public app metadata.
- Never log: tokens, FCM tokens, OTPs, phone numbers, emails, full request/response bodies containing PII, full notification payloads, socket URLs with credentials. Reference logs FCM token and socket URL (R3, R12).
- No `badCertificateCallback` returning `true` in release (reference staging bypass must be `kReleaseMode`-guarded or removed — R8).
- Validate host, path, id format; require an active session for protected destinations; ignore unknown links with a log (R13).
- Release signing with a release keystore from `key.properties` (gitignored); never `signingConfigs.debug` for release (reference — R2).
- Good (reference): dart-define config (ADR-0008); `PrettyDioLogger(enabled: kDebugMode)`; encrypted chat cache; `AuthInterceptor` scoped by `requiresAuth`.
- Fix (reference): R1–R8, R12, R13 in `profiles/reference/remediation-backlog.md`.

## From `sop/state-management.md`

- **One `Status` enum project-wide** (`none, initial, loading, paginating, success, failure, noInternet, syncing` in the reference project). Do not create per-feature status enums.
- Boolean flag soups (`isLoading` + `isSuccess` + `hasError` + sticky `error`) are ANTI-PATTERN (observed: `AuthState`, `CreateOrbitState`). They allow impossible combinations and lose data on reload.
- The reference project has four pagination variants (NEEDS-DECISION) — new code uses this contract.
- Cubits never call other cubits. They communicate through a typed event bus (`GlobalEventBus` + `EventSubscriberMixin` in the reference project, ADR-0007) or repository streams.
- Root providers should stay under ~10. The reference project has 21 (NEEDS-DECISION).
- Navigation, toasts, dialogs, blocking loaders, haptics: only in `BlocListener` / `listener:` callbacks. Never in a Cubit/Bloc, repository, or data source. The reference project complies (0 hits) — keep it that way.
- Extend a project `BaseCubit` that centralises `handleFailure`, no-internet retry, staleness (`isStale`, `markFresh`). Reference: `lib/layers/base/base_cubit.dart`.
- Cubit holding a `BuildContext` or reading another bloc via context (`chat_details_user_ui.dart:83`).

## From `sop/testing.md`

- The reference project has **zero tests**. The standard applies to all new and modified code from now on; backfilling is tracked (R24).
- ### Stack (RECOMMENDED; ND-9 for reference)
- Mock the gateway (`BaseApiService`), return fixture JSON, assert parsed model; return `left(Failure)`, assert pass-through; return malformed JSON, assert `Failure(kind: parse)`.
- Reference project: none exist. First candidates: `OrbitListCubit`, `AuthBloc`, `OrbitsRepositoryImpl`, `DioErrorMapper`, `AuthInterceptor`.

## From `sop/ui-architecture.md`

- A shared **state-render widget** (`StateView`: loading / error+retry / empty / content) is RECOMMENDED; the reference project lacks one and repeats `if (status == ...)` in every screen.
- Before creating a widget: search the shared folders. The reference project has 5 button widgets, 4 text fields, 3 loaders, 4 image paths (ANTI-PATTERN, R20).
- No `Colors.*`, `Color(0x...)`, `fontSize:`, `TextStyle(...)`, magic `EdgeInsets` numbers in feature code. Reference: 1769 `Colors.*` + 169 `Color(0x` (ANTI-PATTERN, R21). Exception: `Colors.transparent`.
- Never `Text('literal')` in feature code. Reference: `AppString` + ~100 literals (NEEDS-DECISION ND-6).
- Fix (reference): `join_orbit_section.dart:70-90` distance check in widget; `all_contacts_screen.dart:179-233` filtering in screen; `login_screen.dart:236-285` validation in screen; `common_dialogs.dart` 1224 lines.
- `sl<>()` in widgets.

## From `checklists/architecture-compliance.md`

- Adapt paths to the recorded orientation (`docs/project/flutter/README.md`). Layer First uses `lib/layers/...`. Feature First uses `lib/features/...` and `lib/core`.
- $D -- lib | rg "^\+.*sl<" | rg -v "BlocProvider|wrappedRoute|create:" && echo "FAIL DI-2/UI-1"
- $D --name-only -- lib | rg "^lib/layers/" > /tmp/lf_paths || true
- $D -- lib/layers/domain lib/layers/data | rg "^\+.*(BuildContext|Navigator\.|EasyLoading|Fluttertoast|showDialog|showModalBottomSheet)" && echo "FAIL ARCH-2"
- $D -- lib/layers/presentation | rg "^\+.*(Colors\.(?!transparent)|Color\(0x|fontSize:)" && echo "FAIL UI-3"
- $D -- lib/layers/presentation | rg "^\+.*Text\(\s*'[A-Za-z]" && echo "FAIL UI-5"
- $D -- lib/layers/presentation | rg "^\+.*(Navigator\.push|CupertinoPageRoute|MaterialPageRoute)" && echo "FAIL ROUTE-1"
- $D -- lib/layers/presentation/cubit lib/layers/presentation/bloc | rg "^\+.*(BuildContext|context\.read|Navigator|EasyLoading)" && echo "FAIL STATE-6"
- $D -- lib/layers/domain/repositories | rg "^\+.*Future<(?!Either)" && echo "FAIL ERR-1"
- Location:    lib/layers/presentation/ui/orbits/widgets/orbit_image.dart:43
- Evidence:    final referer = sl<AppConfiguration>().awsReferer;
- Fix:         Expose `awsReferer` via a config-aware image wrapper constructed at the composition root; tracked R14.

## From `checklists/definition-of-done.md`

- [ ] No new files under `lib/generated/json/`, `lib/layers/app/custom/`, or at repo root.
- [ ] Orientation respected (ARCH-7): a feature is not split across `lib/features/` and `lib/layers/`. Stay: no new `lib/features/` unless that is already the tree. No bulk tree move.
- [ ] Constructor injection; `sl<>()` only at composition roots (DI-1, DI-2).
- [ ] No business logic, `sl<>()`, repository or storage access in widgets (UI-1, UI-2).
- [ ] Strings from `AppString`/l10n (UI-5).

## From `checklists/greenfield-kickoff.md`

- Run **before** creating any `lib/` files or inventing a folder tree. The agent MUST stop and wait for answers. Do not copy example ADR-0001 or `profiles/reference/`.
- Write **this project's** ADR-0001 from `docs/adr/TEMPLATE.md`. Do not copy example `docs/adr/0001-layer-first-structure.md` unless Layer First was chosen **and** it matches this app.


# Stack-specific rule lines generalised in rules/ (verbatim originals)

## From rules/bloc.rules
MUST      DI-1    Constructor-inject abstractions (XRepository, NetworkMonitor, GlobalEventBus, AuthStateProvider).
MUST-NOT  STATE-7 Call sl<>() inside a Cubit/Bloc.
MUST      BLOC-7  Provide via BlocProvider(create: (_) => sl<XCubit>()..load()) in AutoRouteWrapper.wrappedRoute for screen state.

## From rules/ai-agent.rules
MUST      AI-21  No new mid-layer container lookups (adapt pattern to the project's DI: e.g. `sl<` outside composition roots, or `ref.read` of infra inside widgets' business logic).
MUST      AI-22  `git diff -U0 | rg "^\+.*(Colors\.(?!transparent)|Color\(0x|fontSize:|Text\('[A-Za-z])"` is empty.

## From rules/dependency.rules
MUST      DI-4   Add registrations to the module matching the type; preserve order Config -> EventBus -> LifeCycle -> MainConfig -> External -> Hive -> AppLevel -> DataSources -> Repositories -> DomainServices -> Blocs -> Cubits -> Boot.

## From rules/naming.rules
MUST      NAME-2  Generated suffixes: x.g.dart, x.freezed.dart, app_router.gr.dart. Test files: <source>_test.dart mirroring the lib path.
SHOULD    NAME-9  Constants holders as plural nouns for new classes (AppStrings, AppConstants); keep existing AppString/AppConstant as-is.
MUST-NOT  NAME-11 Prefix an interface with Base (Base means inheritance helper, not contract). Existing BaseApiService is LEGACY naming — keep, do not copy.
MUST      NAME-20 Local (Hive) models: XEntity + XEntityAdapter (existing) — for new ones prefer XLocalModel + XLocalModelAdapter.

## From rules/error.rules
MUST      ERR-1   Return Future<Either<Failure, T>> from every repository method; never throw across the repository boundary; never return raw Map/dynamic.
MUST      ERR-4   Keep Failure.error user-safe (from AppString/generic); log stack traces, never put them in state.error.
MUST      ERR-3b  Every catch: return left(Failure), rethrow, or DebugLog with context + a comment stating why continuing is safe.
MUST      ERR-6   Log via DebugLog (kDebugMode-gated). Never print/debugPrint in lib/.
SHOULD    ERR-19  Log with context: DebugLog.e('<Class.method> <what failed>', e, st).

## From rules/networking.rules
MUST      NET-1  Route all HTTP through BaseApiService.executeAPI(ApiRequest). Import/construct Dio only in core/network and core/di/dioInjection.
MUST      NET-4  Describe every call with ApiRequest(url, method, query, body, requiresAuth, allowQueued, apiType, onSendProgress). requiresAuth: false for public/third-party and login/OTP endpoints.
MUST      ERR-1  Interface in domain/repositories returning Future<Either<Failure, T>> (Unit for void, Stream<T> for live data); impl in data/repositoryImpl with `Impl` suffix.
MUST      REPO-1 Wrap calls with backToUI<T>(() => _apiService.executeAPI(...), parseJson: (r) => parseResponse(r, T.fromJson)).
MUST      REPO-4 Constructor-inject the gateway, data sources, session provider, config; no sl<>() inside.
MUST      ERR-8  New models: @freezed + json_serializable with `part 'x.g.dart'`; factory fromJson. Handwritten fromJson only for <= 3 fields.
MUST      RT-1   Socket ingress: SocketClient -> GlobalSocketRouter -> <Domain>SocketHandler -> typed AppRealtimeEvent on GlobalEventBus.

## From rules/flutter.rules
MUST      FL-3   Keep analysis_options.yaml including flutter_lints; enabled extras: prefer_const_*, prefer_final_locals, prefer_single_quotes, always_declare_return_types, avoid_print, avoid_dynamic_calls, unawaited_futures, cancel_subscriptions, close_sinks, use_key_in_widget_constructors, require_trailing_commas, directives_ordering (ND-10: adopt when touching the file).
MUST-NOT  FL-5   Use `print`/`debugPrint` in lib/; use DebugLog.
MUST      FL-21  Regenerate with `dart run build_runner build --delete-conflicting-outputs`; never hand-edit *.g.dart/*.freezed.dart/*.gr.dart; commit generated files (project convention).
MUST      FL-22  One Flutter version pin (align .fvmrc and .tool-versions — ND-11 default 3.38.3) matching pubspec environment and README.

## From rules/performance.rules
SHOULD    PERF-10 Defer heavy init (all Hive boxes, socket connect) until after first frame or on demand; measure with --trace-startup.
SHOULD    ASYNC-10 Prefer async/await over .then chains; Future.wait for independent calls with per-call Either.

## From rules/security.rules
MUST      SEC-6   Store access/refresh tokens and encryption keys in OS secure storage (flutter_secure_storage or equivalent) behind AppStorage. Never derive keys from package name or use constant IVs for new data.
MUST      SEC-8   On logout clear all session-scoped StorageKeys, in-memory session, offline queue, socket connection, sensitive caches.
MUST      SEC-23  Attach Bearer only when ApiRequest.requiresAuth and apiType == private.
MUST      SEC-11  Log only via DebugLog (kDebugMode-gated); never print.

## From rules/testing.rules
MUST      TEST-2  New/modified repository impl -> tests mocking BaseApiService: successful parse, gateway failure pass-through, malformed payload -> Failure.
MUST      TEST-11 Keep bloc_test/mocktail under dev_dependencies.

## From rules/routing.rules
MUST      ROUTE-1  Register every screen in AppRouter.routes as @RoutePage() class XScreen -> generated XRoute.
MUST      ROUTE-10 After adding/renaming a screen, regenerate and commit app_router.gr.dart in the same PR.
SHOULD    ROUTE-8  Provide screen Cubits in AutoRouteWrapper.wrappedRoute, not in main.dart.

## From rules/ui.rules
MUST-NOT  UI-1   Call sl<>(), repositories, data sources, the gateway, Hive/GetStorage/AppStorage from a widget; take values from state or constructor params.
MUST      UI-15  Screen = @RoutePage() XScreen (StatelessWidget unless it owns controllers/observers) implementing AutoRouteWrapper to provide its Cubit; initial load in wrappedRoute (..load()) or initState.
MUST      UI-7   One loader style per state: blocking EasyLoading from a listener OR inline LoadingWidget from the builder — never both.
MUST      UI-3   Use AppColors, Dimensions, context.fontStyle*/AppStyles. No new Colors.* (except transparent), Color(0x...), fontSize:, inline TextStyle(...) or magic EdgeInsets in feature code.
MUST      UI-5   Take user-facing strings from AppString (until l10n adopted); never Text('literal') in feature code.
DECISION  ND-6   Localization (.arb + AppLocalizations) not adopted; keep AppString.
MUST      UI-13  Load network images through MyNetworkImage/MyCircleNetworkImage/UserAvatar; no raw Image.network or unwrapped CachedNetworkImage; set cache sizes for large images.



# Inline reference notes removed from sop/ (verbatim originals)

## From `sop/async-programming.md`
- Never ignore a returned `Future`. Use `await`, or `unawaited(...)` with a comment saying why fire-and-forget is safe (reference uses `unawaited` for uploads — correct).
- JSON decode/parse of large payloads via `compute` (reference: `parseResponse` for > 50 keys, Dio `BackgroundTransformer` — good).
- App-level lifecycle handler (reference `AppLifeCycleHandler`) is the single place reacting to foreground/background for sockets, badges, caches.
- Realtime event arrives during initial load → reducer must merge, not overwrite (reference chat reducer handles this).

## From `sop/code-quality.md`
- Baseline: `include: package:flutter_lints/flutter.yaml` (reference) plus:
- Fix (reference): minimal lint set; 11 `print(`, 32 `debugPrint(`; commented mega-blocks; `depend_on_referenced_packages` ignores in `app_initializer.dart`.

## From `sop/configuration.md`
- Every key in the JSON is consumed (reference: `TENOR_API_KEY` unused — remove or wire). Every field in the config class has a key.
- `Environment` enum derived from a `ENV` key if runtime branching is needed; otherwise omit (reference declares an unused enum — remove).
- Good (reference): `ConfigInjection` + `AppConfiguration`; gitignored `config/*.json`.
- Fix (reference): missing `.json.example` files; unused key/enum; version pin mismatch; Maps keys hardcoded natively.

## From `sop/dependency-injection.md`
- Good (reference): `repository_injection.dart`, `cubits_injection.dart` — constructor injection, abstractions, factories for cubits.

## From `sop/dependency-management.md`
- Importing a transitive dependency directly with `// ignore: depend_on_referenced_packages` (reference: `photo_manager`, `google_maps_flutter_platform_interface`). Declare it or don't use it.

## From `sop/error-handling.md`
| HTML body (proxy/ngrok) | mapper | server failure with generic message (reference handles this — good) |
- Messages come from the string constants/l10n, never raw exception text (reference `Failure('Parse error: $e\n$st')` leaks stack traces into `state.error` — fix by logging the trace and returning a generic message).
- A `Result` extension on `Either` for `getOrElse`, `fold` shortcuts (reference: `either_extension_function.dart`).

## From `sop/git-and-pr.md`
- Never reuse a commit message verbatim across commits (reference: one 11-point paragraph repeated on 10+ commits — ANTI-PATTERN).
- No behaviour change; state "no functional change" in the summary; tests unchanged or added, never removed. Renames of directories/files in dedicated hygiene PRs (reference camelCase → snake_case).
- Bad commit: branch name + 11-point paragraph reused across ten commits (reference).

## From `sop/models-and-data.md`
- Response `XEntity` (reference) or `XDto`; request `XReqModel`; never `Model*Response*Entity`.
- Run `dart run build_runner build --delete-conflicting-outputs`. Commit generated files consistently (reference commits them). Never hand-edit `*.g.dart`/`*.freezed.dart`.

## From `sop/networking.md`
- A single `ApiEndpoints` class with `static const` strings and `static String x(id)` functions. No inline URL strings in repositories. No duplicates (reference: `aboutUs` vs `aboutUsAPI` is LEGACY). Consistent leading slash convention.
- Compress media before upload (reference: `video_compress`, `flutter_image_compress`).

## From `sop/performance.md`
| `RepaintBoundary` around maps, videos, complex canvases (reference does this for maps) | isolated repaint areas |
| Marker/asset caches for maps (reference `MarkerUtils`) | repeated bitmap decoding |
- Firebase init and DI setup are acceptable before `runApp`; heavy Hive box opening and socket connect should be deferred (reference opens all boxes at boot — review).
- Watch for retained `BuildContext`, closures capturing `State`, global caches without bounds (reference `MarkerUtils` global cache — add bounds/eviction).
- Good (reference): `RepaintBoundary` on Google Maps; `compute` parsing; `ListView.builder` in home; `EasyDebounce` in search cubits.

## From `sop/project-structure.md`
- Layer First (reference NEEDS-DECISION): default `core/widgets` for design-system primitives, `presentation/commonWidgets` for domain-aware shared widgets, retire `shared/`.

## From `sop/repository.md`
- Introduce `XRemoteDataSource` / `XLocalDataSource` **only** when the repository coordinates 2+ sources. A single-source repository calls the gateway directly (reference: 18 of 20 repositories). The chat repository (remote + Hive cache + socket) is the correct use.
- Encrypt cached sensitive content (reference: chat bodies).
- One "GeneralRepository" that accumulates unrelated endpoints (reference: acceptable for static content; do not grow it).

## From `sop/routing.md`
| Non-widget code (notification tap, deep link, boot) | `NavigationService` wrapping the router (reference: `core/navigation/navigation_service.dart`) |
| Legacy `Navigator.push(context, CupertinoPageRoute(...))` for screens | LEGACY (reference: `navigateToPage`, 18 hits) — do not add |
- Type → handler registry → typed route (reference: `NotificationHandlerRegistry`). Handlers are pure functions of the payload; they call `NavigationService`.
- For analytics/active-screen tracking, one `RouteObserver` registered on the router (reference: `AppRouteObserver`).
- Keep `app_router.dart` grouped by feature with a one-line comment per route (reference does this).
- Legacy (reference): `edit_profile_screen.dart` → `navigateToPage(...)`.

## From `sop/security.md`
- Encrypt message bodies / PII at rest when cached (reference does for chat — keep).
- HTTP logger enabled only in debug (reference does this — keep) with header redaction.
- Every declared permission/background mode has a documented reason (reference `bluetooth-central` background mode appears unused — review).

## From `sop/state-management.md`
- Reference (legacy): `auth_bloc.dart` + `auth_state.dart` — flag soup, no `isClosed` after `await`.

## From `sop/ui-architecture.md`
- One theme stack. Remove unused parallel stacks (reference: `AppTheme/LightTheme/DarkTheme` unused).
- A base responsive view is OPTIONAL and only useful if breakpoints produce different layouts; returning the same widget for every breakpoint (reference `BaseResponsiveViewFull` usage) is LEGACY noise.
- Network: the project wrapper only. Asset: `Image.asset` with constants (`AppImage`). SVG via `flutter_svg` if used; icon fonts acceptable (reference: `MyCustomIcon`).
- `sop/code-quality.md`: - Within `lib/`, prefer `package:` imports over deep relative paths (`../../../../../..`). Reference mixes both; new files use `package:`.
- `sop/code-quality.md`: - Reference uses `/// ----> Section` banners inside methods; acceptable, but prefer extracting a named method.
- `sop/code-quality.md`: Limits are review triggers, not compile errors. Reference outliers: `common_dialogs.dart` 1224, `chat_contacts_base_cubit.dart` 758.
- `sop/networking.md`: ### Request value object (UNIVERSAL; reference: `ApiRequest`)
- `sop/networking.md`: ### Interceptor chain (UNIVERSAL pattern; reference order is correct)
- `sop/networking.md`: Token refresh, if the backend supports it, belongs in the auth-failure interceptor with a single-flight lock. The reference backend has no refresh (401 = logout); document this per project.
- `sop/networking.md`: ### Connectivity and offline (OPTIONAL, reference PROJECT-SPECIFIC)
- `sop/async-programming.md`: - One mechanism (`easy_debounce` in reference; a `Timer` field is acceptable at L1). Cancel in `close()`.
- `sop/repository.md`: | Emit domain events after successful mutations (OPTIONAL, reference uses `GlobalEventBus`) | Call other repositories' implementations directly (inject the interface if needed) |
- `sop/repository.md`: - Cache keys are versioned (`chat_messages_cache_v1_<id>` in reference — good).
- `sop/repository.md`: ### Model ownership (PROJECT-SPECIFIC for reference; see `models-and-data.md`)
- `sop/bloc.md`: - Every declared event has a registered `on<E>` handler (dead `CompleteProfileEvent` in reference is LEGACY).
- `sop/bloc.md`: One mechanism per project (`easy_debounce` in the reference). Always cancel in `close()`:
- `sop/project-structure.md`: - **Barrel files** (NEEDS-DECISION in reference; RECOMMENDED universally): a barrel may export **one layer or one feature only**. A barrel that re-exports Flutter, third-party packages and multiple layers (`utils/exports.dart`) hides layer violations and is discouraged for new code.
- `sop/performance.md`: | `const` constructors and `const` widget instances wherever possible (`prefer_const_constructors` lint on — reference has it) | skips rebuilds |
- `sop/ui-architecture.md`: - `Form` + `TextFormField` with `validator`s **or** Cubit-side validation exposing field errors in state — one approach per project. Reference uses imperative checks + toast (NEEDS-DECISION); default for new forms: Cubit-side validation with `fieldErrors` map in state.
