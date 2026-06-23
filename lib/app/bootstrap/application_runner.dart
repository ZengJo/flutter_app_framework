// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/client/dio_holder.dart';
import '../../shared/widgets/feedback/network_status_banner.dart';
import '../app.dart';

/// 运行应用
void runAppHandle(
  Widget startPage,
  ProviderContainer container, {
  bool needRegisterUme = true,
}) {
  if (needRegisterUme) {
    PluginManager.instance
      ..register(const ShowCode())
      ..register(const DeviceInfoPanel())
      ..register(const MemoryInfoPage())
      ..register(CpuInfoPage())
      ..register(Console())
      ..register(Performance())
      ..register(DioInspector(dio: DioClientHolder.instance.dio));
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: UMEWidget(
        icon: const FlutterLogo(),
        enable: true,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Application(startPage: startPage),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: NetworkStatusBanner(),
            ),
          ],
        ),
      ),
    ),
  );
}
