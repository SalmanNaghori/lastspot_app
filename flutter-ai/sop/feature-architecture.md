# SOP: Feature Architecture

## Purpose

Define the minimum and maximum shape of a single feature so that features are consistent, reviewable, and neither under- nor over-engineered.

## Scope

Everything a feature needs: models, repository, state, screen, widgets, route, DI, tests. Applies to L2 and L3.

## Principles

1. A feature is complete only when every layer it touches is wired and tested.
2. Build the **thin** version first; add data sources, use cases, mappers only when a concrete need appears.
3. Reuse before create: search for an existing repository, model, widget, or event first.

## Standard

### Minimum feature (UNIVERSAL, HIGH)

| Part | Required | Notes |
|------|----------|-------|
| Request/response models | Yes (if API) | `@freezed` + `json_serializable` |
| Repository interface + impl | Yes (if data) | Returns `Future<Either<Failure, T>>` |
| Cubit (or Bloc / Notifier) + state | Yes (if any async or shared state) | Name follows the state ADR. Feature First: `features/<feature>/controller/`. Layer First: `presentation/cubit/` or `presentation/bloc/` |
| Screen | Yes | `@RoutePage()` `XScreen` (or project equivalent), provider scoped via route wrapper |
| Widgets folder | When screen > ~150 lines or a widget is reused | Feature First: `features/<feature>/widgets/`. Layer First: `presentation/ui/<feature>/widgets/` |
| Route registration | Yes | Typed route; guard if authenticated |
| DI registration | Yes | Repository lazy singleton; cubit factory |
| Tests | Yes | Cubit test + repository test minimum |

### Add only when needed (OPTIONAL, HIGH)

| Part | Add when | Reference-project precedent |
|------|----------|-----------------------------|
| Remote data source | Feature has 2+ sources (remote + cache) | `data/remote/chat_remote_data_source.dart` |
| Local data source | Offline cache / drafts | `data/localDB/chat_cache_data_source.dart` |
| Use case | Orchestration across 2+ repositories/services, or reused by 2+ cubits | `domain/usecases/chatMessageList/*` |
| Policy / domain service | Pure rule reused across UI (`canEdit`, visibility) | `domain/policies/*` |
| UI model / mapper | Presentation needs derived fields the API model lacks | `ui/chatDetailsScreen/.../models/chat_message_ui_model.dart` |
| Typed realtime events | Feature reacts to socket or cross-feature updates | `core/realtime/events/orbits_realtime_event.dart` |

### Where files go (UNIVERSAL)

Follow the project's orientation (`project/project-rules.md` PR-A2). Before creating a file, search which tree **this feature** already occupies; put the file there (Stay / Strangler). Brand-new features on a Strangler project go under `lib/features/<name>/`.

| Part | Feature First | Layer First (reference) |
|------|---------------|-------------------------|
| Screen | `lib/features/<x>/views/<x>_screen.dart` | `lib/layers/presentation/ui/<x>/<x>_screen.dart` |
| Widgets | `lib/features/<x>/widgets/` | `lib/layers/presentation/ui/<x>/widgets/` |
| Controller | `lib/features/<x>/controller/` | `lib/layers/presentation/cubit/<x>_cubit/` |
| Models | `lib/features/<x>/models/` | `lib/layers/data/models/...` |
| Service / repository | `lib/features/<x>/services/` | `domain/repositories/` + `data/repositoryImpl/` |
| Shared widgets | `lib/shared/widgets/` | `core/widgets` or `presentation/commonWidgets` |

### Feature completion sequence (UNIVERSAL)

1. Search: existing repository/model/widget/event that already covers part of the need. Search which tree this feature occupies.
2. Models → repository interface → repository impl (+ endpoint constants).
3. Cubit/Bloc/Notifier + state (in `controller/` or `presentation/cubit/` per orientation).
4. DI registration.
5. Screen + widgets + route.
6. Listeners for side effects (navigation, toast, loader).
7. Tests (cubit, repository, shared widget).
8. `dart format`, `flutter analyze`, tests green.
9. Compliance check (`checklists/architecture-compliance.md`).

## Recommended implementation

### Feature First thin feature (paths)

```text
lib/features/foo/
  views/foo_list_screen.dart
  widgets/          # when the screen is large or a widget is reused
  controller/foo_list_cubit.dart   # or foo_list_notifier.dart / foo_list_controller.dart
  controller/foo_list_state.dart
  models/foo_list_entity.dart
  models/foo_list_req_model.dart
  services/foo_repository.dart
  services/foo_repository_impl.dart   # if an interface is justified
test/features/foo/...
```

Views and widgets do not call the service. The controller talks to the service. Do not also create files under `lib/layers/` for this feature.

### Layer First thin feature (reference)

Reference-project template for a list feature, derived from `orbitListCubit`:

```dart
// domain/repositories/foo_repository.dart
abstract class FooRepository {
  Future<Either<Failure, FooListEntity>> fetchFoos({required FooListReqModel req});
}

// data/repositoryImpl/foo_repository_impl.dart
class FooRepositoryImpl with UpdateUiMixin implements FooRepository {
  FooRepositoryImpl({required BaseApiService apiService}) : _apiService = apiService;
  final BaseApiService _apiService;

  @override
  Future<Either<Failure, FooListEntity>> fetchFoos({required FooListReqModel req}) =>
      backToUI<FooListEntity>(
        () => _apiService.executeAPI(
          apiRequest: ApiRequest(
            url: ApiEndpoints.fetchFoosAPI,
            method: HttpMethod.get,
            query: req.toQueryParams(),
            allowQueued: false,
          ),
        ),
        parseJson: (r) => parseResponse(r, FooListEntity.fromJson),
      );
}

// presentation/cubit/foo_list_cubit/foo_list_state.dart
@freezed
abstract class FooListState with _$FooListState {
  const factory FooListState({
    @Default(Status.initial) Status status,
    @Default([]) List<FooEntity> items,
    @Default(true) bool hasMore,
    @Default('') String error,
    @Default(unExpectedErrorCode) int errorCode,
  }) = _FooListState;
}

// presentation/cubit/foo_list_cubit/foo_list_cubit.dart
class FooListCubit extends BaseCubit<FooListState> {
  FooListCubit({required FooRepository repository, required NetworkMonitor networkMonitor})
      : _repository = repository, super(const FooListState(), networkMonitor: networkMonitor);
  final FooRepository _repository;
  static const _limit = 10;

  Future<void> fetch({bool loadMore = false}) async {
    if (loadMore && !state.hasMore) return;
    if (state.status == Status.loading) return;
    emit(state.copyWith(status: loadMore ? Status.paginating : Status.loading));
    final result = await _repository.fetchFoos(
      req: FooListReqModel(skip: loadMore ? state.items.length : 0, limit: _limit),
    );
    if (isClosed) return;
    result.fold(
      handleFailure,
      (data) => emit(state.copyWith(
        status: Status.success,
        items: loadMore ? [...state.items, ...data.records] : data.records,
        hasMore: (loadMore ? state.items.length : 0) + data.records.length < data.total,
      )),
    );
  }

  @override
  void onInternetRestored() { if (state.status == Status.noInternet) fetch(); }

  @override
  FooListState stateWithFailure({required Status status, required String error, required int errorCode}) =>
      state.copyWith(status: status, error: error, errorCode: errorCode);
}
```

Screen scoping:

```dart
@RoutePage()
class FooListScreen extends StatelessWidget implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider(create: (_) => sl<FooListCubit>()..fetch(), child: this);
  // build: BlocBuilder + BlocListener; no sl<> here
}
```

## Examples

- Thin feature done right (Layer First reference): orbits list (`orbit_list_cubit.dart`, `orbits_repository_impl.dart`).
- Thin feature done right (Feature First): all of `foo` under `lib/features/foo/{views,widgets,controller,models,services}`.
- Thick feature justified: chat message list (remote + cache + realtime + use cases + reducer).
- Strangler: new `payments` under `lib/features/payments/`; existing `orbits` stays in `lib/layers/...`.

## Anti-patterns

- Copying the chat feature's full stack (data source + 7 use cases + policies) for a simple list.
- Creating a new repository when an existing one already owns the endpoint (check `ApiEndpoints` and existing repositories first).
- Splitting one feature across Feature First and Layer First trees.
- A screen `wrappedRoute` providing 30 cubits (`single_chat_screen.dart`) — group into a scope widget or reduce cubit count.
- A feature without tests "because the project has none" — the standard applies to new work regardless.

## Exceptions

Prototype/spike branches may skip tests and DI registration if the branch is explicitly labelled `spike/` and is never merged as-is.
