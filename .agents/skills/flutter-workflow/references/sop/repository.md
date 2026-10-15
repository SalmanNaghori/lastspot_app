# SOP: Repository

## Purpose

Define what a repository is responsible for, so that Cubits never know where data comes from and data sources never know who asked.

## Scope

Repository interfaces, implementations, data sources, caching, mapping, error translation, use cases.

## Principles

1. The repository is the **only** door from application logic to data.
2. It returns **domain-ready values** (`Either<Failure, T>`), never raw JSON, never exceptions.
3. It coordinates sources; it does not render, navigate, or know about widgets.
4. Interfaces exist to be mocked and to allow a second implementation — nothing more.

## Standard

### Contract (UNIVERSAL, HIGH)

```dart
abstract class ProductsRepository {
  Future<Either<Failure, ProductListEntity>> fetchProductList({required ProductListReqModel req});
  Future<Either<Failure, Unit>> leaveProduct({required String productId});
}
```

- Interface in the domain/application layer; implementation in data.
- Every method returns `Future<Either<Failure, T>>` (or `Stream<T>` for live data). `Unit` for void.
- Named parameters for more than one argument.
- Group by aggregate (products, chat, auth), not by screen. One repository per aggregate; check existing ones before adding.

### Responsibilities (UNIVERSAL)

| Does | Does not |
|------|----------|
| Build `ApiRequest`s, call the gateway | Import Flutter (`BuildContext`, widgets, `Navigator`, overlays) |
| Parse JSON into models (in isolate if large) | Hold UI state or presentation models |
| Coordinate remote + local sources, decide cache policy | Decide what to show the user |
| Translate storage/parse errors to `Failure` | Log business events to analytics |
| Emit domain events after successful mutations (OPTIONAL, via the event bus/streams in the ADR) | Call other repositories' implementations directly (inject the interface if needed) |

### Data sources (OPTIONAL, HIGH)

Introduce `XRemoteDataSource` / `XLocalDataSource` **only** when the repository coordinates 2+ sources. A single-source repository calls the gateway directly. A repository that combines remote + cache + socket is the correct use.

### Caching (OPTIONAL)

- Cache policy lives in the repository (`fetch(forceRefresh: false)`), not in the Cubit.
- Cache keys are versioned (e.g. `chat_messages_cache_v1_<id>`).
- Encrypt cached sensitive content.

### Use cases (OPTIONAL)

Add a use case class when logic spans 2+ repositories/services or is reused by 2+ Cubits. Otherwise the Cubit calls the repository. Do not create pass-through use cases.

### Dependencies (UNIVERSAL)

Constructor-injected: gateway, data sources, session provider, config. No service locator inside. No platform SDK that belongs to another concern (e.g. a repository depending on `FirebaseMessaging` only to read the push token — inject a `DeviceTokenProvider` instead).

### Model ownership (PROJECT-SPECIFIC; see `models-and-data.md`)

Projects that let API models flow to the UI (recorded in an ADR) have repository interfaces that import data models. Universally, if a domain entity layer exists, the interface returns entities and the impl maps.

## Recommended implementation

Template: one call-and-parse helper (REPO-1) per method. Keep methods short: one request, one parser.

Test template (`ApiGateway` / `send` stand for the project's gateway type and method):

```dart
final api = MockApiGateway();
final repo = ProductsRepositoryImpl(api: api);
when(() => api.send(any()))
    .thenAnswer((_) async => right(fixtureJson('product_list.json')));
final result = await repo.fetchProductList(req: const ProductListReqModel(...));
expect(result.isRight(), true);
```

## Examples

Good: one repository per aggregate, each method one request + one parser, all returning the PR-D2 result type.

Fix: a repository importing a presentation model (move the model to data); an impl method left as `UnimplementedError`.

## Anti-patterns

- Repository instantiated with `new` in a Cubit or widget.
- Repository showing a toast or loader.
- Repository returning `dynamic` or `Map<String, dynamic>`.
- One "GeneralRepository" that accumulates unrelated endpoints.
- Data source for a single-source feature.

## Exceptions

Repositories may accept a `ProgressCallback` for uploads (presentation-adjacent but not UI). Repositories may expose `Stream<T>` from local DB watchers.
