# Remediation Backlog — LastSpot

Proposals only — nothing here is applied until a dedicated, approved change.

| # | Pri | Item | Evidence | Proposed Fix | Rule |
|---|-----|------|----------|--------------|------|
| **REM-01** | High | Remove debug `print()` statements | 10 `print()` calls in `lib/features/spot/data/datasources/spot_remote_datasource.dart` | Replace with `LoggerUtils` or remove debug prints | ERR-6, `avoid_print` |
| **REM-02** | Med | Migrate raw `Colors.*` to theme tokens | 46 occurrences of `Colors.*` in `create_spot_screen_mobile.dart`, `onboarding_screen.dart`, etc. | Replace with `context.colorScheme`, `context.primaryColor`, or `AppColor` | UI-3, GEMINI Rule 4 |
| **REM-03** | Low | Add logging to empty `catch (_)` blocks | 15 `catch (_)` blocks across `notifications_list_cubit.dart`, `device_remote_datasource.dart`, etc. | Log caught exceptions via `LoggerUtils` instead of silent suppression | ERR-3 |
| **REM-04** | Low | Consolidate strings into `intl_en.arb` | Parallel usage of `AppString` and `AppLocalizations` | Move user-facing strings from `AppString` into `intl_en.arb` | UI-5, GEMINI Rule 5 |
