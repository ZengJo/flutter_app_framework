import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/config/application_config.dart';
import '../client/dio_holder.dart';
import '../client/http_client.dart';
import '../interceptors/logger_interceptor.dart';

/// Dio提供器
final dioProvider = Provider<Dio>((ref) {
  /// Dio实例
  final dio = Dio(
    BaseOptions(
      connectTimeout: ApplicationConfig.connectTimeout,
      receiveTimeout: ApplicationConfig.receiveTimeout,
    ),
  );

  //  Loading / Error 拦截器
  dio.interceptors.add(LoggerInterceptor());

  // 把 Dio 注入回旧体系
  DioClientHolder.instance.attach(dio);
  HttpClient.instance; // 确保 HttpClient 构造执行

  return dio;
});
