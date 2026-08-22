import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/config/application_config.dart';
import '../client/dio_holder.dart';
import '../client/http_client.dart';

/// Dio 提供器。
///
/// 这里只负责创建 Dio；拦截器统一在 dio_interceptors_provider.dart 注册，
/// 避免拦截器顺序分散在多个文件中。
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: ApplicationConfig.connectTimeout,
      receiveTimeout: ApplicationConfig.receiveTimeout,
    ),
  );

  // 把 Dio 注入回旧体系。
  DioClientHolder.instance.attach(dio);
  HttpClient.instance; // 确保 HttpClient 构造执行。

  return dio;
});
