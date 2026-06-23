import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../connectivity/network_monitor.dart';
import '../connectivity/network_state.dart';

/// 网络监控提供器
final networkMonitorProvider = Provider<NetworkMonitor>((ref) {
  /// 网络监控实例
  final monitor = NetworkMonitor();

  /// 启动即监听
  monitor.start(); //  启动即监听

  /// 释放资源
  ref.onDispose(monitor.dispose);

  /// 返回网络监控实例
  return monitor;
});

/// 网络状态提供器
final networkStateProvider = StreamProvider<NetworkState>((ref) {
  final monitor = ref.watch(networkMonitorProvider);
  return monitor.stream;
});
