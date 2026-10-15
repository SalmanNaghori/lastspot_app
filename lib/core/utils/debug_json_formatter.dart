import 'dart:collection';
import 'dart:convert';

/// Converts API values and Freezed models into safe, readable debug JSON.
abstract final class DebugJsonFormatter {
  static const _redacted = '[REDACTED]';
  static const _sensitiveKeyParts = [
    'access_token',
    'refresh_token',
    'token',
    'password',
    'secret',
    'authorization',
    'cookie',
    'fcm',
    'device_token',
    'api_key',
    'email',
    'phone',
    'mobile',
    'full_name',
    'message',
    'content',
  ];

  static String format(Object? value) {
    if (value == null) return '(empty/void)';
    return const JsonEncoder.withIndent(
      '  ',
    ).convert(_toJsonValue(value, HashSet<Object>.identity()));
  }

  static Object? _toJsonValue(Object? value, Set<Object> visited) {
    if (value == null || value is String || value is num || value is bool) {
      return value;
    }
    if (value is DateTime) return value.toIso8601String();
    if (value is Enum) return value.name;

    if (!visited.add(value)) return '<circular>';
    try {
      if (value is Map) {
        return {
          for (final entry in value.entries)
            entry.key.toString(): _isSensitiveKey(entry.key.toString())
                ? _redacted
                : _toJsonValue(entry.value, visited),
        };
      }
      if (value is Iterable) {
        return value.map((item) => _toJsonValue(item, visited)).toList();
      }

      try {
        // Freezed and json_serializable models expose this API.
        // ignore: avoid_dynamic_calls
        final json = (value as dynamic).toJson();
        if (json is Map || json is Iterable) {
          return _toJsonValue(json, visited);
        }
      } on NoSuchMethodError {
        // Raw response values can also be scalars, which were handled above.
      }
      return '<${value.runtimeType}>';
    } finally {
      visited.remove(value);
    }
  }

  static bool _isSensitiveKey(String key) {
    final normalized = key
        .replaceAllMapped(
          RegExp(r'([a-z0-9])([A-Z])'),
          (match) => '${match[1]}_${match[2]}',
        )
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '_');
    return _sensitiveKeyParts.any(normalized.contains);
  }
}
