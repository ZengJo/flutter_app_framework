import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/device/device_info_service.dart';
import '../../core/globalization/bootstrap/globalization_bootstrap.dart';
import '../../core/globalization/bootstrap/globalization_bootstrap_data.dart';
import '../../core/globalization/providers/globalization_bootstrap_provider.dart';
import '../../core/globalization/providers/globalization_providers.dart';
import '../../core/network/headers/request_headers.dart';
import '../../core/network/providers/dio_interceptors_provider.dart';
import '../../core/network/providers/dio_provider.dart';
import '../../core/network/providers/network_providers.dart';
import '../../core/network/providers/offline_queue_provider.dart';
import '../../features/example/presentation/pages/order_page.dart';
import '../config/app_globals.dart';
import 'application_runner.dart';

/// 应用启动入口：只负责启动顺序，不放业务逻辑。
class ApplicationBootstrapper {
  ApplicationBootstrapper._();

  static final ApplicationBootstrapper instance = ApplicationBootstrapper._();

  late final ProviderContainer _container;
  late GlobalizationBootstrapData _globalizationBootstrapData;

  bool _bootstrapped = false;

  Future<void> bootstrap() async {
    if (_bootstrapped) return;
    _bootstrapped = true;

    WidgetsFlutterBinding.ensureInitialized();

    await _initBase();
    _container = _initDependencies();
    _run(const OrderPage());
  }

  Future<void> _initBase() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    globalPackageInfo = await PackageInfo.fromPlatform();
    globalDeviceId = await DeviceInfoService.getDeviceId() ?? '';

    // Globalization 必须在 runApp 前加载，保证第一帧就是正确语言/地区。
    _globalizationBootstrapData = await GlobalizationBootstrap.load();

    // 静态 HTTP Header 在启动时初始化一次。
    await RequestHeaders.initialize();
  }

  ProviderContainer _initDependencies() {
    final container = ProviderContainer(
      overrides: [
        // 将启动阶段读取到的语言、地区、时区等信息注入 Riverpod。
        globalizationBootstrapProvider.overrideWithValue(
          _globalizationBootstrapData,
        ),
      ],
    );

    // 先构建 Globalization，确保后续网络请求能直接读取当前状态。
    container.read(globalizationProvider);

    // 先初始化网络状态，再初始化 Dio 和依赖 Dio 的模块。
    container.read(networkMonitorProvider);
    container.read(dioProvider);
    container.read(dioInterceptorsProvider);
    container.read(offlineQueueManagerProvider);

    return container;
  }

  void _run(Widget startPage, {bool needRegisterUme = true}) {
    runAppHandle(startPage, _container, needRegisterUme: needRegisterUme);
  }
}
