# SOP: Testing

## Purpose

Tests exist to make change safe. This SOP defines the minimum that must exist for a change to be considered done, what is worth testing beyond that, and how tests are written so they stay cheap.

## Scope

Unit, Bloc/Cubit, repository, widget, integration, golden tests; naming, structure, mocks, fixtures.

## Principles

1. **Test behaviour at boundaries**: what a Cubit emits, what a repository returns, what a widget shows.
2. **Mock only what you own or what crosses a boundary** (repository interface, gateway). Don't mock models.
3. **Tests are code**: same naming, formatting and review rules.
4. **No test is worse than a flaky test**, and a flaky test is worse than no test.

## Standard

### Minimum required (UNIVERSAL, HIGH)

| Change | Required tests |
|--------|----------------|
| New or modified Cubit/Bloc | success path, failure path, no-internet path (if applicable), pagination/refresh rules, `isClosed` safety where async |
| New or modified repository | each method: success parse, gateway failure pass-through, parse failure → `Failure` |
| New or modified shared widget (design system) | widget test: renders, callbacks fire, states (disabled/loading) |
| New model with custom JSON handling | `fromJson`/`toJson` round-trip against a fixture |
| New route | widget/integration test that the route builds with args |
| Bug fix | a regression test reproducing the bug |

The reference project has **zero tests**. The standard applies to all new and modified code from now on; backfilling is tracked (R24).

### Should test (RECOMMENDED)

- Use cases and policies (pure logic — cheapest tests).
- Error mapper (`DioException` → `Failure` table).
- Interceptors (auth header attached only when `requiresAuth`; 401 triggers logout).
- Reducers (realtime merge logic).
- Critical screens: one widget test per state (loading/error/empty/content).

### Usually not worth testing (UNIVERSAL)

- Generated code.
- Simple `copyWith`/freezed equality.
- Pure layout widgets with no logic or state.
- DI registration (covered by a single boot smoke test).

### Stack (RECOMMENDED; ND-9 for reference)

| Need | Package |
|------|---------|
| Bloc/Cubit | `bloc_test` |
| Mocks | `mocktail` (no codegen) |
| Widgets | `flutter_test` |
| Golden | `golden_toolkit` or `alchemist` (OPTIONAL) |
| Integration | `integration_test` (SDK) |

### Structure and naming (UNIVERSAL)

```text
test/
  fixtures/                     real API JSON, named <endpoint>_response.json
  helpers/                      fixture loader, pump helpers, mock classes
  <mirror of lib path>/<file>_test.dart
```

- `group('<ClassName>')` → nested `group('<method>')` → `test('<behaviour>')`.
- Test names describe behaviour: `'emits [loading, failure] when repository returns Failure'`.
- Mocks: `class MockOrbitsRepository extends Mock implements OrbitsRepository {}`; register fallback values in `setUpAll`.
- Fixtures loaded once per group; never inline 200-line JSON.

### Bloc/Cubit test template (UNIVERSAL)

```dart
void main() {
  late MockOrbitsRepository repo;
  late MockNetworkMonitor monitor;

  setUp(() {
    repo = MockOrbitsRepository();
    monitor = MockNetworkMonitor();
    when(() => monitor.onStatusChange).thenAnswer((_) => const Stream.empty());
  });

  group('OrbitListCubit', () {
    blocTest<OrbitListCubit, OrbitListState>(
      'emits [loading, success] with hasMore=false when all records received',
      build: () {
        when(() => repo.fetchOrbitCategories()).thenAnswer((_) async => right(['A']));
        when(() => repo.fetchOrbitList(req: any(named: 'req')))
            .thenAnswer((_) async => right(OrbitListEntity(records: twoOrbits, total: 2)));
        return OrbitListCubit(repository: repo, bus: GlobalEventBus(), networkMonitor: monitor);
      },
      seed: () => const OrbitListState(lat: 1, lng: 1),
      act: (c) => c.fetchOrbits(),
      expect: () => [
        isA<OrbitListState>().having((s) => s.status, 'status', Status.loading),
        isA<OrbitListState>()
            .having((s) => s.status, 'status', Status.success)
            .having((s) => s.hasMore, 'hasMore', false),
      ],
    );
  });
}
```

### Repository test template (UNIVERSAL)

Mock the gateway (`BaseApiService`), return fixture JSON, assert parsed model; return `left(Failure)`, assert pass-through; return malformed JSON, assert `Failure(kind: parse)`.

### Widget tests (UNIVERSAL)

Wrap with `MaterialApp` + `BlocProvider.value(value: mockCubit)`; stub `state` and `stream` (`whenListen` from `bloc_test`). Assert by semantics/text/keys, not by widget tree depth.

### Integration tests (OPTIONAL at L2, RECOMMENDED at L3+)

Critical journeys only (login → home; create item; send message). Run on CI against a mock server or staging.

### Golden tests (OPTIONAL)

Design-system components only; update goldens deliberately in dedicated commits.

## Recommended implementation

- CI runs `flutter analyze` and `flutter test --coverage`; coverage gate on **changed files** (e.g. ≥ 70 %), not the whole repo, so legacy code does not block.
- `test/helpers/test_di.dart` builds Cubits with mocks — never the real container.

## Examples

Reference project: none exist. First candidates: `OrbitListCubit`, `AuthBloc`, `OrbitsRepositoryImpl`, `DioErrorMapper`, `AuthInterceptor`.

## Anti-patterns

- Testing implementation details (`verify(repo.fetch()).called(1)` as the only assertion).
- Sleeping in tests (`await Future.delayed`) instead of `pump`/`pumpAndSettle`/fake async.
- Sharing mutable mocks across tests without `setUp`.
- Skipping tests "because the project has none".

## Exceptions

Spike branches (`spike/*`) may omit tests; they are not merged.
