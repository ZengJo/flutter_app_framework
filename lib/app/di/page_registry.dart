import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';

/// 用于在页面中注入Provider，以便在页面中使用
/// 使用方式：
/// PageScope(
///   provider: demoProvider,
///   child: child,
/// )
class PageScope<S> extends InheritedWidget {
  final ProviderListenable<S> provider;

  const PageScope({super.key, required this.provider, required super.child});

  static ProviderListenable<S> of<S>(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<PageScope<S>>();
    assert(scope != null, 'PageScope<$S> 没有找到 context');
    return scope!.provider;
  }

  @override
  bool updateShouldNotify(covariant PageScope oldWidget) => false;
}
