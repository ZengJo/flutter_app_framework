import 'package:dio/dio.dart';

/// 全局 Dio 持有器，用于兼容旧的 HttpClient 调用方式。
class DioClientHolder {
  DioClientHolder._();

  static final DioClientHolder instance = DioClientHolder._();

  Dio? _dio;

  Dio get dio {
    final value = _dio;
    if (value == null) {
      throw StateError('Dio has not been initialized. Read dioProvider first.');
    }
    return value;
  }

  Dio? get maybeDio => _dio;

  void attach(Dio dio) {
    _dio = dio;
  }
}
