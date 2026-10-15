/// The mobile recovery callback is intentionally separate from the web/admin
/// reset page at lastspot_backend/reset-password.
class PasswordRecoveryConfig {
  PasswordRecoveryConfig._();

  static const String mobileRedirectUrl = 'com.lastspot.app://reset-password';
}
