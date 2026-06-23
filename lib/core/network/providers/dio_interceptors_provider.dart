import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../offline_queue/offline_queue_interceptor.dart';
import 'dio_provider.dart';
import 'network_providers.dart';
import 'offline_queue_provider.dart';

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
