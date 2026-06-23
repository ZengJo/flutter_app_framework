import 'package:flutter_app_framework/core/storage/preferences_service.dart';
import 'offline_request.dart';

/// 离线队列存储
class OfflineQueueStorage {
  /// 队列键
  static const _queueKey = 'offline_queue';

  /// 死亡队列键
  static const _deadKey = 'offline_dead_queue';

  /// 加载队列
  Future<List<OfflineRequest>> loadQueue() async {
    final list = await PreferencesService.getStringList(_queueKey);
    return list.map(OfflineRequest.decode).toList();
  }

  /// 加载死亡队列
  Future<List<OfflineRequest>> loadDead() async {
    final list = await PreferencesService.getStringList(_deadKey);
    return list.map(OfflineRequest.decode).toList();
  }

  /// 保存队列
  Future<void> saveQueue(List<OfflineRequest> list) async {
    await PreferencesService.setStringList(_queueKey, list.map((e) => e.encode()).toList());
  }

  /// 保存死亡队列
  Future<void> saveDead(List<OfflineRequest> list) async {
    await PreferencesService.setStringList(_deadKey, list.map((e) => e.encode()).toList());
  }
}
