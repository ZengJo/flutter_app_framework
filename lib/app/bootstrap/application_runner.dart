// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume_kit_device/flutter_ume_kit_device.dart';
import 'package:flutter_ume_kit_dio/flutter_ume_kit_dio.dart';
import 'package:flutter_ume_kit_show_code/flutter_ume_kit_show_code.dart';
import 'package:flutter_app_framework/core/network/client/dio_holder.dart';
import 'package:flutter_app_framework/main.dart';
import 'package:flutter_app_framework/shared/widgets/feedback/network_status_banner.dart';

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
      ..register(DioInspector(dio: DioClientHolder.instance.dio));
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: UMEWidget(
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
