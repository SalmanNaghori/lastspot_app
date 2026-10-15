import 'package:flutter_test/flutter_test.dart';
import 'package:lastspot_app/core/services/password_recovery_link_monitor.dart';

void main() {
  group('PasswordRecoveryLinkMonitor', () {
    final monitor = PasswordRecoveryLinkMonitor.instance;

    setUp(monitor.clear);

    test('recognizes a Supabase callback for the configured mobile URI', () {
      final isAuthCallback = monitor.detectSessionInUri(
        Uri.parse('com.lastspot.app://reset-password?code=abc123'),
      );

      expect(isAuthCallback, isTrue);
      expect(monitor.isPending, isTrue);
      expect(monitor.lastWasMalformed, isFalse);
    });

    test('marks a callback without auth data as malformed', () {
      final isAuthCallback = monitor.detectSessionInUri(
        Uri.parse('com.lastspot.app://reset-password'),
      );

      expect(isAuthCallback, isFalse);
      expect(monitor.isPending, isTrue);
      expect(monitor.lastWasMalformed, isTrue);
    });

    test('ignores unrelated callback URLs', () {
      final isAuthCallback = monitor.detectSessionInUri(
        Uri.parse('https://example.com/reset-password?code=abc123'),
      );

      expect(isAuthCallback, isFalse);
      expect(monitor.isPending, isFalse);
    });

    test('recognizes implicit error responses in the URI fragment', () {
      final isAuthCallback = monitor.detectSessionInUri(
        Uri.parse(
          'com.lastspot.app://reset-password#'
          'error=access_denied&error_code=otp_expired',
        ),
      );

      expect(isAuthCallback, isTrue);
      expect(monitor.isPending, isTrue);
      expect(monitor.lastWasMalformed, isFalse);
    });
  });
}
