/// 离线队列状态
class OfflineQueueState {
  /// 待重放请求数
  final int pending;

  /// 死亡请求数
  final int dead;

  /// 重放中
  final bool replaying;

  const OfflineQueueState({
    required this.pending,
    required this.dead,
    required this.replaying,
  });

  static const empty = OfflineQueueState(pending: 0, dead: 0, replaying: false);
}
