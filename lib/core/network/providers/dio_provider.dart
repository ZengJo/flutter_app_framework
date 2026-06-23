import 'package:dio/dio.dart';
import 'package:flutter_app_framework/core/network/interceptors/logger_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_framework/core/network/client/dio_holder.dart';
import 'package:flutter_app_framework/core/network/client/http_client.dart';

/// Dio提供器
final dioProvider = Provider<Dio>((ref) {
  /// Dio实例
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
    ),
  );

  //  Loading / Error 拦截器
  dio.interceptors.add(LoggerInterceptor());

  // 把 Dio 注入回旧体系
  DioClientHolder.instance.attach(dio);
  HttpClient.instance; // 确保 HttpClient 构造执行

  return dio;
});
