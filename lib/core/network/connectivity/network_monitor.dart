import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_app_framework/core/logger/app_logger.dart';

import 'network_state.dart';

/// 网络监控
class NetworkMonitor {
  /// 网络状态流
  final _controller = StreamController<NetworkState>.broadcast();

  /// 网络检测
  final Connectivity _connectivity = Connectivity();

  /// 网络状态
  NetworkState _state = const NetworkState(Reachability.unknown);

  /// 网络变化监听
  StreamSubscription<List<ConnectivityResult>>? _sub;

  /// 网络状态流
  Stream<NetworkState> get stream => _controller.stream;

  /// 当前网络状态
  NetworkState get current => _state;

  /// 启动网络监控
  void start() {
    // 1) 监听网络变化（新 API：List<ConnectivityResult>）
    _sub = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final online = _isOnline(results);
        _setOnline(online);
      },
      onError: (e, _) {
        // 防御：不要因为监听异常把整个 monitor 弄死
        AppLogger.error('[NetworkMonitor] connectivity error: $e');
      },
    );

    // 2) 冷启动主动检查一次
    _connectivity.checkConnectivity().then(
      (List<ConnectivityResult> results) {
        final online = _isOnline(results);
        _setOnline(online);
      },
      onError: (e, _) {
        AppLogger.error('[NetworkMonitor] checkConnectivity error: $e');
      },
    );
  }

  /// 判断是否在线
  bool _isOnline(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    if (results.contains(ConnectivityResult.none)) return false;
    return true;
  }

  /// 设置网络状态
  void _setOnline(bool online) {
    final next = NetworkState(
      online ? Reachability.online : Reachability.offline,
    );

    AppLogger.info(
      '[NetworkMonitor] setOnline=$online '
      'from=${_state.internet} to=${next.internet}',
    );

    if (next.internet != _state.internet) {
      _state = next;
      _controller.add(_state);
    }
  }

  /// 释放网络监控
  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}
