/// 图片资源的全球化处理策略。
///
/// fixed:
/// 图片与语言、文字方向无关。
///
/// mirrorOnRtl:
/// LTR 和 RTL 共用同一张图片，RTL 环境自动水平镜像。
///
/// directional:
/// LTR / RTL 分别使用不同图片。
///
/// localized:
/// 根据当前语言选择不同图片。
enum AppAssetStrategy { fixed, mirrorOnRtl, directional, localized }

/// 全球化图片资源定义。
///
/// 业务页面不应该自己判断：
///
/// ```dart
/// if (isArabic) {
///   ...
/// }
/// ```
///
/// 而应该把图片的处理规则定义在这里，
/// 页面只负责使用 AppAsset。
class AppAsset {
  /// 普通固定图片。
  ///
  /// 适合：
  /// - Logo
  /// - 商品图
  /// - 头像
  /// - 二维码
  /// - 国旗
  /// - 实拍照片
  const AppAsset.fixed(String this.path)
    : strategy = AppAssetStrategy.fixed,
      ltrPath = null,
      rtlPath = null,
      localizedPaths = const <String, String>{},
      fallbackPath = null;

  /// RTL 环境自动水平镜像。
  ///
  /// 适合：
  /// - 箭头
  /// - 手势指引
  /// - 简单流程图
  ///
  /// 不适合：
  /// - 带文字的图片
  /// - Logo
  /// - 手机 UI 截图
  /// - 带明显左右光影的图片
  const AppAsset.mirrorOnRtl(String this.path)
    : strategy = AppAssetStrategy.mirrorOnRtl,
      ltrPath = null,
      rtlPath = null,
      localizedPaths = const <String, String>{},
      fallbackPath = null;

  /// LTR / RTL 分别提供独立图片。
  ///
  /// 适合复杂方向性图片。
  ///
  /// 例如：
  ///
  /// ```text
  /// connect_guide_ltr.webp
  /// connect_guide_rtl.webp
  /// ```
  const AppAsset.directional({required String ltr, required String rtl})
    : strategy = AppAssetStrategy.directional,
      path = null,
      ltrPath = ltr,
      rtlPath = rtl,
      localizedPaths = const <String, String>{},
      fallbackPath = null;

  /// 按语言提供独立图片。
  ///
  /// 适合：
  /// - 图片中已经包含文字
  /// - UI 截图
  /// - 不同市场完全不同的 Banner
  ///
  /// paths 示例：
  ///
  /// ```dart
  /// {
  ///   'en': 'xxx_en.webp',
  ///   'zh': 'xxx_zh.webp',
  ///   'ar': 'xxx_ar.webp',
  /// }
  /// ```
  const AppAsset.localized({
    required Map<String, String> paths,
    required String this.fallbackPath,
  }) : strategy = AppAssetStrategy.localized,
       path = null,
       ltrPath = null,
       rtlPath = null,
       localizedPaths = paths;

  /// 图片处理策略。
  final AppAssetStrategy strategy;

  /// fixed / mirrorOnRtl 使用。
  final String? path;

  /// LTR 图片。
  final String? ltrPath;

  /// RTL 图片。
  final String? rtlPath;

  /// 不同 Locale 对应的图片。
  ///
  /// 支持：
  ///
  /// en
  /// en-US
  /// zh
  /// zh-Hans
  /// zh-Hans-CN
  /// ar
  /// ar-SA
  final Map<String, String> localizedPaths;

  /// localized 找不到对应语言资源时使用。
  final String? fallbackPath;
}
