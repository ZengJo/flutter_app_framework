import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logger/app_logger.dart';

/// Central Riverpod observer for logging and diagnostics.
final class AppProviderObserver extends ProviderObserver {
  const AppProviderObserver();

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    if (kDebugMode) {
      AppLogger.info(
        'Provider updated: ${context.provider.name ?? context.provider.runtimeType}',
      );
    }
  }
}
