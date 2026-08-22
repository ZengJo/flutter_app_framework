import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../globalization/network/globalization_interceptor.dart';
import '../../globalization/providers/globalization_providers.dart';
import '../interceptors/logger_interceptor.dart';
import '../offline_queue/offline_queue_interceptor.dart';
import 'dio_provider.dart';
import 'network_providers.dart';
import 'offline_queue_provider.dart';

/// Dio 拦截器统一注册点。
final dioInterceptorsProvider = Provider<void>((ref) {
  final dio = ref.watch(dioProvider);
  final queueManager = ref.watch(offlineQueueManagerProvider);
  final monitor = ref.watch(networkMonitorProvider);

  /// 1. 每次请求实时写入语言、地区、货币、时区、单位制。
  /// 使用 ref.read 而不是 ref.watch，切换语言时不需要重新创建 Dio。
  dio.interceptors.add(
    GlobalizationInterceptor(
      readState: () => ref.read(globalizationProvider),
    ),
  );

  /// 2. 离线队列在 Globalization 之后执行，确保入队时已有当前 Header。
  dio.interceptors.add(OfflineQueueInterceptor(monitor, queueManager, false));

  /// 3. 最后记录请求日志，此时可以看到最终 Header。
  dio.interceptors.add(LoggerInterceptor());
});
