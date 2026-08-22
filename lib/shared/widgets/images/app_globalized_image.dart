import 'package:flutter/material.dart';

import '../../../core/globalization/assets/app_asset.dart';
import '../../../core/globalization/assets/app_asset_resolver.dart';
import 'app_image.dart';

/// 支持 Globalization 的统一图片组件。
///
/// 页面以后优先使用这个组件加载
/// 有语言 / RTL 差异的 Asset 图片。
///
/// 示例：
///
/// ```dart
/// AppGlobalizedImage(
///   asset: AppAssets.connectGuide,
/// )
/// ```
///
/// 组件会自动处理：
///
/// - 当前语言
/// - LTR
/// - RTL
/// - Arabic
/// - 后续 Hebrew 等 RTL 语言
class AppGlobalizedImage extends StatelessWidget {
  const AppGlobalizedImage({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.aspectRatio,
    this.fit,
    this.radius,
    this.borderRadius,
    this.iconColor,
    this.errorWidget,
  });

  /// 全球化图片定义。
  final AppAsset asset;

  final double? width;

  final double? height;

  final double? aspectRatio;

  final BoxFit? fit;

  final double? radius;

  final BorderRadiusGeometry? borderRadius;

  final Color? iconColor;

  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    /// 根据当前 Locale 和 Directionality
    /// 解析最终应该显示哪张图。
    final resolved = AppAssetResolver.resolve(context, asset);

    return AppImage(
      src: resolved.path,
      width: width,
      height: height,
      aspectRatio: aspectRatio,
      fit: fit,
      radius: radius,
      borderRadius: borderRadius,
      iconColor: iconColor,
      errorWidget: errorWidget,
      matchTextDirection: resolved.matchTextDirection,
    );
  }
}
