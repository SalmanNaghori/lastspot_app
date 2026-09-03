import 'dart:developer';

class SupabaseLogger {
  /// Wraps a Supabase API call to log its request, payload, duration, and response/error.
  ///
  /// [operationName] The name of the operation for logging purposes (e.g. 'getFeedSpots', 'updateProfile').
  /// [requestData] Any relevant payload or parameters being sent.
  /// [operation] The actual asynchronous function to execute.
  static Future<T> execute<T>({
    required String operationName,
    Map<String, dynamic>? requestData,
    required Future<T> Function() operation,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final response = await operation();
      stopwatch.stop();

      final buffer = StringBuffer();
      buffer.writeln(
        '========================================================================',
      );
      buffer.writeln('🚀 REQ: $operationName');
      if (requestData != null) {
        buffer.writeln('📦 PAYLOAD: $requestData');
      }
      buffer.writeln(
        '✅ RES: $operationName (${stopwatch.elapsedMilliseconds}ms)',
      );
      if (response != null) {
        buffer.writeln('📄 DATA: ${_formatData(response)}');
      } else {
        buffer.writeln('📄 DATA: (empty/void)');
      }
      buffer.write(
        '========================================================================',
      );

      log(buffer.toString(), name: 'Supabase');

      return response;
    } catch (e, st) {
      stopwatch.stop();
      final buffer = StringBuffer();
      buffer.writeln(
        '========================================================================',
      );
      buffer.writeln('🚀 REQ: $operationName');
      if (requestData != null) {
        buffer.writeln('📦 PAYLOAD: $requestData');
      }
      buffer.writeln(
        '❌ ERR: $operationName (${stopwatch.elapsedMilliseconds}ms)',
      );
      buffer.writeln('⚠️ ERROR: $e');
      buffer.writeln('📜 STACK: $st');
      buffer.write(
        '========================================================================',
      );

      log(buffer.toString(), name: 'Supabase');
      rethrow;
    }
  }

  static String _formatData(dynamic data) {
    if (data == null) return '(empty/void)';
    try {
      if (data is List) {
        return data.map((e) => _formatSingleData(e)).toList().toString();
      }
      return _formatSingleData(data);
    } catch (_) {
      return data.toString();
    }
  }

  static String _formatSingleData(dynamic item) {
    try {
      // ignore: avoid_dynamic_calls
      return item.toJson().toString();
    } catch (_) {
      return item.toString();
    }
  }
}
