import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_framework/core/network/offline_queue/offline_queue_manager.dart';
import 'package:flutter_app_framework/core/network/providers/dio_provider.dart';
import 'package:flutter_app_framework/core/network/providers/network_providers.dart';
import 'package:flutter_app_framework/core/network/providers/offline_queue_state_provider.dart';

/// 离线队列管理器提供器
final offlineQueueManagerProvider = Provider<OfflineQueueManager>((ref) {
  /// Dio
  final dio = ref.read(dioProvider);

  /// 网络监控
  final monitor = ref.read(networkMonitorProvider);

  /// 离线队列存储
  final storage = ref.read(offlineQueueStorageProvider);

  /// 创建离线队列管理器
  final manager = OfflineQueueManager(
    dio: dio,
    monitor: monitor,
    storage: storage,
  );

  // 不能 await，但要触发
  manager.init();

  /// 释放资源
  ref.onDispose(manager.dispose);

  /// 返回离线队列管理器
  return manager;
});
