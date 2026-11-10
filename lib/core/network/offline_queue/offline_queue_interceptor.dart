import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../connectivity/network_monitor.dart';
import 'offline_queue_manager.dart';
import 'offline_request.dart';

/// 离线队列拦截器
class OfflineQueueInterceptor extends Interceptor {
  /// 网络监控
  final NetworkMonitor monitor;

  /// 离线队列管理器
  final OfflineQueueManager manager;

  OfflineQueueInterceptor(this.monitor, this.manager);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final state = monitor.current;

    // 未标记离线队列，或正在重放的请求，直接放行。
    if (options.extra['offline'] != true || options.extra['replay'] == true) {
      handler.next(options);
      return;
    }

    // unknown：一律放行（冷启动必须）
    if (state.isUnknown || !state.isOffline) {
      handler.next(options);
      return;
    }

    final extra = options.extra;
    final idempotencyKey = extra['idempotencyKey'];
    final req = OfflineRequest(
      id: const Uuid().v4(),
      idempotencyKey: idempotencyKey is String ? idempotencyKey : '',
      priority: QueuePriority.values[_enumIndex(
        extra['priority'],
        QueuePriority.normal.index,
        QueuePriority.values.length,
      )],
      category: QueueCategory.values[_enumIndex(
        extra['category'],
        QueueCategory.userAction.index,
        QueueCategory.values.length,
      )],
      method: options.method,
      path: options.path,
      query: options.queryParameters,
      body: options.data,
      headers: Map<String, dynamic>.from(options.headers),
    );

    manager.enqueue(req);
    handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.cancel,
        message: 'OFFLINE_QUEUED',
      ),
    );
  }
}

int _enumIndex(Object? value, int fallback, int length) {
  if (value is int && value >= 0 && value < length) return value;
  return fallback;
}
