import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/device/device_info_service.dart';
import '../../../core/network/providers/network_providers.dart';
import '../../../core/network/providers/offline_queue_state_provider.dart';

/// 网络状态栏
class NetworkStatusBanner extends ConsumerWidget {
  const NetworkStatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 网络状态
    final networkAsync = ref.watch(networkStateProvider);

    /// 离线队列状态
    final queueAsync = ref.watch(offlineQueueStateProvider);

    /// 构建网络状态栏
    return networkAsync.when(
      data: (network) {
        return queueAsync.when(
          data: (queue) {
            final isOffline = network.isOffline;
            final pending = queue.pending;
            final replaying = queue.replaying;

            if (!isOffline && pending == 0 && !replaying) {
              return const SizedBox.shrink();
            }

            return _OfflineBanner(
              isOffline: isOffline,
              pending: pending,
              replaying: replaying,
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  final bool isOffline;
  final int pending;
  final bool replaying;

  const _OfflineBanner({
    required this.isOffline,
    required this.pending,
    required this.replaying,
  });

  @override
  Widget build(BuildContext context) {
    String text;

    if (isOffline) {
      text = pending > 0 ? '离线中，已缓存 $pending 条操作' : '网络不可用，操作将在恢复后同步';
    } else if (replaying) {
      text = '网络已恢复，正在同步 $pending 条操作…';
    } else {
      text = '同步完成';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: DeviceInfoService.top(context), bottom: 12),
      color: Colors.red.withValues(alpha: 0.95),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
