import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BootstrapContext {
  /// 容器
  final ProviderContainer container;

  /// 启动页面
  final Widget? startPage;

  /// 初始化
  BootstrapContext({required this.container, this.startPage});
}
