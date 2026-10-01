import 'dart:developer';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../network_exceptions.dart';
import '../../utils/result.dart';

/// A base repository that abstracts the Supabase API call, logging,
/// and try-catch error handling into a single reusable method.
abstract class BaseRepository {
  /// Executes a Supabase API call or any async function, logs its request/response,
  /// handles exceptions safely, and returns a [Result<T, Exception>].
  Future<Result<T, Exception>> executeApi<T>({
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

      return Success(response);
    } on SocketException catch (_) {
      stopwatch.stop();
      _logError(
        operationName,
        requestData,
        stopwatch.elapsedMilliseconds,
        'NoInternetException',
      );
      return const Failure(NoInternetException());
    } on AuthException catch (e) {
      stopwatch.stop();
      _logError(operationName, requestData, stopwatch.elapsedMilliseconds, e);
      return Failure(e);
    } on PostgrestException catch (e) {
      stopwatch.stop();
      _logError(operationName, requestData, stopwatch.elapsedMilliseconds, e);
      return Failure(e);
    } on Exception catch (e, st) {
      stopwatch.stop();
      _logError(
        operationName,
        requestData,
        stopwatch.elapsedMilliseconds,
        e,
        st,
      );
      return Failure(e);
    } catch (e, st) {
      stopwatch.stop();
      _logError(
        operationName,
        requestData,
        stopwatch.elapsedMilliseconds,
        e,
        st,
      );
      return Failure(Exception(e.toString()));
    }
  }

  /// Executes a Supabase API call, logs its request/response,
  /// and rethrows exceptions instead of returning a Result.
  /// Use this for repositories that have not yet migrated to the Result<T, Exception> pattern.
  Future<T> executeApiRaw<T>({
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
      _logError(
        operationName,
        requestData,
        stopwatch.elapsedMilliseconds,
        e,
        st,
      );
      rethrow;
    }
  }

  void _logError(
    String operationName,
    Map<String, dynamic>? requestData,
    int ms,
    dynamic error, [
    StackTrace? st,
  ]) {
    final buffer = StringBuffer();
    buffer.writeln(
      '========================================================================',
    );
    buffer.writeln('🚀 REQ: $operationName');
    if (requestData != null) {
      buffer.writeln('📦 PAYLOAD: $requestData');
    }
    buffer.writeln('❌ ERR: $operationName (${ms}ms)');
    buffer.writeln('⚠️ ERROR: $error');
    if (st != null) {
      buffer.writeln('📜 STACK: $st');
    }
    buffer.write(
      '========================================================================',
    );
    log(buffer.toString(), name: 'Supabase');
  }

  String _formatData(dynamic data) {
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

  String _formatSingleData(dynamic item) {
    try {
      // ignore: avoid_dynamic_calls
      return item.toJson().toString();
    } catch (_) {
      return item.toString();
    }
  }
}
