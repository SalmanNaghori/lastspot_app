# SOP: Models and Data

## Purpose

Decide how many model layers a project needs and how models are serialized, so that adding a field is a one-file change and parsing never crashes the app.

## Scope

Request models, response models/DTOs, domain entities, local DB models, UI models, mappers, serialization tooling, nullability.

## Principles

1. **Separate models only when the separation provides meaningful architectural value.** A DTO that is identical to the entity is duplication, not architecture.
2. **One serialization stack per project.**
3. **Models are immutable value types** with generated equality and `copyWith`.
4. **Parsing is defensive**: unknown fields ignored, missing fields defaulted or nullable, never a runtime crash.

## Standard

### Model layers (UNIVERSAL, HIGH)

| Layer | Create when | Example |
|-------|-------------|-------------------|
| Request model | Endpoint takes > 2 parameters or a body | `XReqModel` with `toJson`/`toQueryParams()` |
| Response model (DTO) | Always for JSON responses | `XEntity` (API shape) |
| Domain entity | API shape is unstable, multiple backends, or business logic needs a different shape | Optional — some apps let API models flow to UI (record in an ADR) |
| Local DB model | Persisted schema differs from API or needs adapters | Hive `XEntity` + `TypeAdapter` |
| UI model | Presentation needs derived fields (formatted dates, grouping flags) | `ChatMessageUIModel` |
| Mapper | Whenever two of the above coexist for one concept | inline / extensions |

Decision rule: start with request + response models. Add an entity layer only via ADR when the trigger above appears. Add UI models per screen when the widget tree would otherwise compute derived values in `build`.

### Serialization (UNIVERSAL, HIGH)

Use the serializer recorded in PR-D3. The following example applies only when `freezed` + `json_serializable` is selected; use the equivalent conventions for other serializers.

```dart
@freezed
abstract class FeedEntity with _$FeedEntity {
  const factory FeedEntity({
    @JsonKey(name: '_id') @Default('') String id,
    @Default('') String title,
    @Default([]) List<String> tags,
    DateTime? createdAt,
  }) = _FeedEntity;
  factory FeedEntity.fromJson(Map<String, dynamic> json) => _$FeedEntityFromJson(json);
}
```

- Handwritten `fromJson` OPTIONAL for ≤ 3-field models.
- IDE-plugin generators (e.g. FlutterJsonBeanFactory) are LEGACY where present: fix bugs only, never add models, migrate opportunistically.
- Enums from the API: use `@JsonEnum` / `unknownEnumValue` so new server values do not crash.

### Nullability and defaults (UNIVERSAL)

- Required-by-contract fields: non-null with `@Default` for primitives/lists.
- Optional fields: nullable, no default.
- Never `!` on parsed values in UI; provide getters on the model.
- Dates: parse to `DateTime` in the model, not in widgets.

### Naming (see `naming-conventions.md`)

Response `XEntity` or `XDto`; request `XReqModel`; never `Model*Response*Entity`.

### Request query/body helpers (UNIVERSAL)

`toQueryParams()` returns `Map<String, dynamic>` with all values stringified where the backend requires; `toFormDataMap()` for multipart. Keep them on the request model, not in the repository.

### Generated code (UNIVERSAL)

Run `dart run build_runner build --delete-conflicting-outputs`. Commit generated files consistently. Never hand-edit `*.g.dart`/`*.freezed.dart`.

## Recommended implementation

- A `test/fixtures/` folder with real API responses; every response model has a `fromJson(fixture)` test.
- A `build.yaml` limiting `json_serializable` to `lib/**/models/**` to speed up builds.

## Examples

Good: a freezed response model with `@JsonKey(name: '_id')`, defaults for optional fields, and `unknownEnumValue` on enums.

Legacy: `user_info_response_model_entity.dart` (FJBF `$XFromJson`), `nearby_places_response.dart` (handwritten for a large model).

## Anti-patterns

- Three serialization stacks in one project.
- `Map<String, dynamic>` passed to Cubits or widgets.
- Model files listed as Flutter assets (remove them from `flutter.assets`).
- DTO ↔ entity mappers that copy every field for no shape change.
- Business logic methods on DTOs (keep them in policies/services); simple derived getters are fine.

## Exceptions

Socket payloads may be parsed by dedicated handler code into the same response models; do not create a parallel "socket model" unless the shape differs.
