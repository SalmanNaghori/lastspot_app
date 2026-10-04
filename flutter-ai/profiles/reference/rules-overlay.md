# Reference rules overlay (historical)

These PROJECT / LEGACY / DECISION lines belonged with the reference profile.
Active projects use `project/project-rules.md` instead.

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
PROJECT   PR-D1..D7 See project/project-rules.md §D.
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
PROJECT   PR-E1..E4 See project/project-rules.md §E. Route naming via replaceInRouteName: 'Screen,Route'.
PROJECT   PR-E5  auto_route deep-link resolution is disabled (deepLinkBuilder -> defaultPath); DeepLinkService handles links after login (ADR-0004). Do not re-enable without an ADR.
DECISION  ND-12  Deep-link id validation and session binding — add (R13).
LEGACY    L-R1   navigateToPage + Navigator.push (18 hits) — do not add; migrate when touching those screens.
LEGACY    L-R2   21 root BlocProviders in main.dart — do not add more; scope new state per route.

# From security.rules
## Project
PROJECT   PR-G1..G3 See project/project-rules.md §G.
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
PROJECT   PR-F1..F4 See project/project-rules.md §F.
PROJECT   PR-F2  Reuse: MyButton/MyOutLineButton (core/widgets), MyTextField, MyNetworkImage, LoadingWidget, ErrorView, AppConstant.showToast, CustomBottomSheet.
LEGACY    L-U1   1769 Colors.* / 169 Color(0x / 186 fontSize: in presentation — never add; migrate when touching a file (R21).
LEGACY    L-U2   Duplicate kits (ButtonWidget, LoginBottomNavButton, LoginTextField, ExpandTextField, EmptyLoaderWidget...) — do not extend (R20).
LEGACY    L-U3   old_chat_screen.dart, BaseResponsiveViewFull, webview_page.dart naming, common_dialogs.dart 1224 lines — do not extend (R17, R26, R30).
LEGACY    L-U4   ~170 sl<>() in widgets — do not add; when touching a widget, replace with state/params (R14).

