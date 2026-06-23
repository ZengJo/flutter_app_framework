import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_framework/core/network/offline_queue/offline_queue_interceptor.dart';
import 'package:flutter_app_framework/core/network/providers/dio_provider.dart';
import 'package:flutter_app_framework/core/network/providers/network_providers.dart';
import 'package:flutter_app_framework/core/network/providers/offline_queue_provider.dart';

/// Dio拦截器提供器
final dioInterceptorsProvider = Provider<void>((ref) {
  /// Dio
  final dio = ref.watch(dioProvider);

  /// 离线队列管理器
  final queueManager = ref.watch(offlineQueueManagerProvider);

  /// 网络监控
  final monitor = ref.watch(networkMonitorProvider);

  /// 添加离线队列拦截器
  dio.interceptors.add(OfflineQueueInterceptor(monitor, queueManager, false));
});
