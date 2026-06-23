import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_framework/core/network/offline_queue/offline_queue_storage.dart';
import 'package:flutter_app_framework/core/network/providers/offline_queue_provider.dart';

import '../offline_queue/offline_queue_state.dart';

/// 离线队列状态提供器
final offlineQueueStateProvider = StreamProvider<OfflineQueueState>((ref) {
  final manager = ref.watch(offlineQueueManagerProvider);
  return manager.stateStream;
});

/// 离线队列存储提供器
final offlineQueueStorageProvider = Provider<OfflineQueueStorage>((ref) {
  return OfflineQueueStorage();
});
