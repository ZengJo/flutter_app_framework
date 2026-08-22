import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bootstrap/globalization_bootstrap_data.dart';

/// ProviderContainer 创建时由 ApplicationBootstrapper 注入。
final globalizationBootstrapProvider = Provider<GlobalizationBootstrapData>(
  (ref) => throw StateError(
    'globalizationBootstrapProvider must be overridden during bootstrap.',
  ),
);
