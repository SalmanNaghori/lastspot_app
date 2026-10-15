import 'dart:async';

/// Tracks only the mobile Supabase password recovery callback.
///
/// Supabase Flutter owns callback parsing and session exchange. This monitor
/// only lets the app distinguish a malformed or failed recovery link from an
/// unrelated auth callback.
class PasswordRecoveryLinkMonitor {
  PasswordRecoveryLinkMonitor._();

  static final PasswordRecoveryLinkMonitor instance =
      PasswordRecoveryLinkMonitor._();

  final StreamController<bool> _linkEvents = StreamController<bool>.broadcast(
    sync: true,
  );

  bool _pending = false;
  bool _lastWasMalformed = false;

  Stream<bool> get linkEvents => _linkEvents.stream;
  bool get isPending => _pending;
  bool get lastWasMalformed => _lastWasMalformed;

  bool detectSessionInUri(Uri uri) {
    if (!_isRecoveryCallback(uri)) return false;

    late final Map<String, String> parameters;
    try {
      parameters = <String, String>{
        ...uri.queryParameters,
        ...Uri.splitQueryString(uri.fragment),
      };
    } on FormatException {
      _pending = true;
      _lastWasMalformed = true;
      _linkEvents.add(true);
      return false;
    }
    final hasAuthPayload = const {
      'code',
      'access_token',
      'error',
      'error_code',
      'error_description',
    }.any(parameters.containsKey);

    _pending = true;
    _lastWasMalformed = !hasAuthPayload;
    _linkEvents.add(_lastWasMalformed);
    return hasAuthPayload;
  }

  void clear() {
    _pending = false;
    _lastWasMalformed = false;
  }

  bool _isRecoveryCallback(Uri uri) =>
      uri.scheme.toLowerCase() == 'com.lastspot.app' &&
      uri.host.toLowerCase() == 'reset-password' &&
      (uri.path.isEmpty || uri.path == '/');
}
