enum Reachability { unknown, online, offline }

/// 网络状态
class NetworkState {
  /// 网络状态
  final Reachability internet;

  /// 构造函数
  const NetworkState(this.internet);

  /// 明确在线
  bool get isOnline => internet == Reachability.online;

  /// 明确离线（只能这个才算离线）
  bool get isOffline => internet == Reachability.offline;

  /// 状态未知（启动 / 切网瞬间）
  bool get isUnknown => internet == Reachability.unknown;
}
