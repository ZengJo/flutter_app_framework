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

  OfflineQueueInterceptor(this.monitor, this.manager, this.isNeedQueueRequest);

  ///是否需要队列请求
  bool isNeedQueueRequest = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final state = monitor.current;

    // 0) 非离线请求（明确不需要队列）
    if (options.extra['offline'] != true) {
      handler.next(options);
      return;
    }

    // replay 请求必须永远放行（避免重放时再次入队/死循环）
    if (options.extra['replay'] == true) {
      handler.next(options);
      return;
    }

    // 1) unknown：一律放行（冷启动必须）
    if (state.isUnknown) {
      handler.next(options);
      return;
    }

    // 2) 明确离线：入队并 cancel
    if (state.isOffline && isNeedQueueRequest) {
      /// 获取额外信息
      final extra = options.extra;

      /// 创建离线请求
      final req = OfflineRequest(
        id: const Uuid().v4(),
        idempotencyKey: extra['idempotencyKey'],
        priority: QueuePriority
            .values[(extra['priority'] as int?) ?? QueuePriority.normal.index],
        category:
            QueueCategory.values[(extra['category'] as int?) ??
                QueueCategory.userAction.index],
        method: options.method,
        path: options.path,
        query: options.queryParameters,
        body: options.data,
        headers: Map<String, dynamic>.from(options.headers),
      );

      /// 入队
      manager.enqueue(req);

      /// 拒绝请求
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
          message: 'OFFLINE_QUEUED',
        ),
      );
      return;
    }

    // 3) 在线：正常请求
    handler.next(options);
  }
}
