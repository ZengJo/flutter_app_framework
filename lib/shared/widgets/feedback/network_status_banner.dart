import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/device/device_info_service.dart';
import '../../../core/globalization/extensions/localization_context_x.dart';
import '../../../core/network/providers/network_providers.dart';
import '../../../core/network/providers/offline_queue_state_provider.dart';

/// 网络状态栏。
///
/// 所有用户可见文案来自 ARB，切换语言后会自动刷新。
class NetworkStatusBanner extends ConsumerWidget {
  const NetworkStatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkAsync = ref.watch(networkStateProvider);
    final queueAsync = ref.watch(offlineQueueStateProvider);

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
  const _OfflineBanner({
    required this.isOffline,
    required this.pending,
    required this.replaying,
  });

  final bool isOffline;
  final int pending;
  final bool replaying;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final String text;
    if (isOffline) {
      text = pending > 0
          ? l10n.networkOfflinePending(pending)
          : l10n.networkUnavailable;
    } else if (replaying) {
      text = l10n.networkRecoveredReplaying(pending);
    } else {
      text = l10n.networkSyncComplete;
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
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.start,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
