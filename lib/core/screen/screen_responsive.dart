import 'package:flutter/material.dart';

/// 响应式尺寸适配工具。
///
/// 根据设计稿宽度按比例缩放尺寸，适用于：
///
/// - width
/// - height
/// - padding
/// - margin
/// - borderRadius
/// - fontSize
/// - iconSize
///
/// 默认设计稿宽度为 **375**。
///
/// ## 初始化
///
/// 推荐在每个页面的 `build` 方法开始调用：
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   ScreenResponsive.init(context);
///
///   return Scaffold(
///     body: ...
///   );
/// }
/// ```
///
/// 如果整个应用的设计稿宽度固定，也可以在应用入口初始化一次。
///
/// ## 使用
///
/// ```dart
/// Container(
///   width: 120.adapt,
///   height: 48.adapt,
///   padding: EdgeInsets.all(16.adapt),
///   margin: EdgeInsets.symmetric(horizontal: 20.adapt),
///   decoration: BoxDecoration(
///     borderRadius: BorderRadius.circular(12.adapt),
///   ),
///   child: Text(
///     'Hello',
///     style: TextStyle(
///       fontSize: 16.adapt,
///     ),
///   ),
/// )
/// ```
///
/// 等价于：
///
/// ```dart
/// ScreenResponsive.adapt(16);
/// ```
class ScreenResponsive {
  const ScreenResponsive._();

  static double _scale = 1.0;

  /// 初始化响应式缩放比例。
  ///
  /// [designWidth] 设计稿宽度，默认 375。
  ///
  /// [minScale]、[maxScale] 用于限制缩放范围，
  /// 防止超小屏或超大屏导致界面缩放过度。
  static void init(
    BuildContext context, {
    double designWidth = 375,
    double minScale = 0.85,
    double maxScale = 1.25,
  }) {
    final size = MediaQuery.of(context).size;
    final widthScale = size.width / designWidth;

    _scale = widthScale.clamp(minScale, maxScale);
  }

  /// 当前缩放比例。
  static double get scale => _scale;

  /// 返回适配后的尺寸。
  static double adapt(num value) => value * _scale;
}

/// 数值响应式扩展。
///
/// 示例：
///
/// ```dart
/// 16.adapt
/// 24.adapt
/// 120.adapt
/// ```
extension ResponsiveSizeExtension on num {
  /// 根据当前屏幕宽度返回适配后的尺寸。
  double get adapt => ScreenResponsive.adapt(this);
}
