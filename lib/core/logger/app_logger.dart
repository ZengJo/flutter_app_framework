import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._();

  static const int _chunkSize = 1000;

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 10,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: kReleaseMode ? Level.warning : Level.trace,
  );

  static bool get _enableNetworkLog => !kReleaseMode;

  // =========================
  // Basic Log
  // =========================

  static void trace(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t('⚪ TRACE | $message', error: error, stackTrace: stackTrace);
  }

  static void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d('🔵 DEBUG | $message', error: error, stackTrace: stackTrace);
  }

  static void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i('🟢 INFO  | $message', error: error, stackTrace: stackTrace);
  }

  static void warning(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _logger.w('🟡 WARN  | $message', error: error, stackTrace: stackTrace);
  }

  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e('🔴 ERROR | $message', error: error, stackTrace: stackTrace);
  }

  static void fatal(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f('💀 FATAL | $message', error: error, stackTrace: stackTrace);
  }

  // =========================
  // Business Log
  // =========================

  static void network(String message) {
    if (!_enableNetworkLog) return;
    _printLong('🌐 NETWORK\n$message');
  }

  static void mqtt(String message) {
    _printLong('📡 MQTT\n$message');
  }

  static void bluetooth(String message) {
    _printLong('📶 BLE\n$message');
  }

  static void device(String message) {
    _printLong('🤖 DEVICE\n$message');
  }

  // =========================
  // JSON
  // =========================

  static void json(dynamic data, {Level level = Level.debug}) {
    _printLong(_pretty(data), level: level);
  }

  // =========================
  // Dio Request
  // =========================

  static void request(RequestOptions options) {
    if (!_enableNetworkLog) return;

    final message =
        '''
      🟦 REQUEST
      METHOD : ${options.method}
      URL    : ${options.uri}

      HEADERS
      ${_pretty(options.headers)}

      QUERY
      ${_pretty(options.queryParameters)}

      BODY
      ${_pretty(options.data)}
      ''';

    _printLong(message, level: Level.debug);
  }

  static void response(Response response) {
    if (!_enableNetworkLog) return;

    final message =
        '''
      🟩 RESPONSE
      STATUS : ${response.statusCode}
      URL    : ${response.requestOptions.uri}

      DATA
      ${_pretty(response.data)}
      ''';

    _printLong(message, level: Level.info);
  }

  static void dioError(DioException error) {
    final message =
        '''
      🟥 ERROR
      METHOD : ${error.requestOptions.method}
      URL    : ${error.requestOptions.uri}

      MESSAGE
      ${error.message}

      RESPONSE
      ${_pretty(error.response?.data)}
      ''';

    _printLong(message, level: Level.error);
  }

  // =========================
  // Helpers
  // =========================

  static String _pretty(dynamic data) {
    try {
      if (data == null) {
        return 'null';
      }

      if (data is String) {
        try {
          final decoded = jsonDecode(data);
          return const JsonEncoder.withIndent('  ').convert(decoded);
        } catch (_) {
          return data;
        }
      }

      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }

  static void _printLong(String text, {Level level = Level.info}) {
    void printByLevel(String message) {
      switch (level) {
        case Level.trace:
          _logger.t(message);
          break;
        case Level.debug:
          _logger.d(message);
          break;
        case Level.info:
          _logger.i(message);
          break;
        case Level.warning:
          _logger.w(message);
          break;
        case Level.error:
          _logger.e(message);
          break;
        case Level.fatal:
          _logger.f(message);
          break;
        default:
          _logger.i(message);
      }
    }

    if (text.length <= _chunkSize) {
      printByLevel(text);
      return;
    }

    for (int i = 0; i < text.length; i += _chunkSize) {
      final end = (i + _chunkSize < text.length) ? i + _chunkSize : text.length;
      printByLevel(text.substring(i, end));
    }
  }
}
