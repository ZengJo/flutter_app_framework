import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 全局 Navigator Key，只放真正需要全局访问的入口。
final GlobalKey<NavigatorState> globalKeyNavigatorKey = GlobalKey<NavigatorState>();

BuildContext? get maybeGlobalContext => globalKeyNavigatorKey.currentContext;

BuildContext get globalContext {
  final context = maybeGlobalContext;
  if (context == null) {
    throw StateError('Global context is not ready yet.');
  }
  return context;
}

/// App 启动状态：后续建议改成 Riverpod StateProvider。
int globalAppStatus = 0;

String globalDeviceId = '';

late PackageInfo globalPackageInfo;
