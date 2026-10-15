# SOP: Forms and Validation

## Purpose

Forms that validate consistently, are testable without widgets, never double-submit, and are accessible.

## Scope

Input fields, validation, submission, server-side errors, focus, autofill, sensitive input. Guardrails: UI-24..26, ERR-7, A11Y-7.

## Principles

1. Validation rules are business logic → state holder or pure validators, not widgets.
2. Field errors are **state**; server errors on fields map back to fields.
3. The submit path has exactly one in-flight request.

## Standard

### Where things live (UNIVERSAL, HIGH)

| Concern | Location |
|---------|----------|
| Field values + field errors + submit status | form state in the feature state holder |
| Validation rules | pure functions/classes (`EmailValidator`, `PasswordPolicy`) in `domain/` or `models/`, unit-tested |
| Error messages | `FieldError` enum/kind in state → mapped to l10n in the widget |
| `TextEditingController` / `FocusNode` | widget `State`, disposed (UI-11) |

### Validation timing (RECOMMENDED)

- Validate a field on blur or after the first submit attempt; do not show errors while the user is still typing for the first time.
- Re-validate all fields on submit; if invalid, move focus to the first invalid field and announce (A11Y-7).

### Submission (UNIVERSAL)

- Submit button disabled or showing progress while `status == submitting`; the state holder ignores submits while in flight.
- Server validation errors (e.g. 422 with field map) are parsed in the repository into a typed failure and mapped to field errors in state.
- On success, side effects (navigate, toast) run in the listener (STATE-12).

### Inputs (UNIVERSAL)

- Set `keyboardType`, `textInputAction` (`next` → `done`), `textCapitalization`, `autofillHints`, wrap related fields in `AutofillGroup`.
- Use `inputFormatters` for masks (phone, card) rather than post-hoc string surgery.
- Sensitive fields: `obscureText`, `enableSuggestions: false`, `autocorrect: false`; never logged (SEC-10); cleared from state after submit.
- Every field has a visible label (not placeholder-only).

## Recommended implementation

```dart
// state
@freezed
class SignUpState with _$SignUpState {
  const factory SignUpState({
    @Default('') String email,
    EmailError? emailError,
    @Default(Status.initial) Status status,
    @Default(false) bool submitted,
  }) = _SignUpState;
}

// validator (pure, unit-tested)
EmailError? validateEmail(String v) =>
    v.isEmpty ? EmailError.empty : (!_emailRegex.hasMatch(v) ? EmailError.invalid : null);
```

## Anti-patterns

- `validator: (v) => v!.isEmpty ? 'Required' : null` with literals and logic in the widget.
- A `Form` with `GlobalKey<FormState>` as the only source of truth for a multi-step flow.
- Toast-only errors for field problems (ERR-7).

## Exceptions

Trivial single-field dialogs (rename) may validate inline with a pure validator function, provided messages come from the string source.
