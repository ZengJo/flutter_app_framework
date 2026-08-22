import '../../core/globalization/assets/app_asset.dart';

/// App 图片资源统一管理。
///
/// 以后不要在业务页面里面大量直接写：
///
/// ```dart
/// 'assets/images/xxx.webp'
/// ```
///
/// 统一在这里定义。
class AppAssets {
  const AppAssets._();

  // ============================================================
  // 普通固定资源
  // ============================================================

  /// App Logo。
  ///
  /// Logo 与 LTR / RTL 无关，
  /// 所以永远不能镜像。
  static const AppAsset logo = AppAsset.fixed('assets/images/common/logo.webp');

  /// 商品图片。
  ///
  /// 商品实拍图也不应该镜像。
  static const AppAsset product = AppAsset.fixed(
    'assets/images/common/product.webp',
  );

  // ============================================================
  // RTL 自动镜像资源
  // ============================================================

  /// 简单箭头。
  ///
  /// English / 中文：
  ///
  /// →
  ///
  /// Arabic：
  ///
  /// ←
  ///
  /// 不需要准备第二张图。
  static const AppAsset guideArrow = AppAsset.mirrorOnRtl(
    'assets/images/directional/guide_arrow.webp',
  );

  // ============================================================
  // LTR / RTL 独立资源
  // ============================================================

  /// Onboarding 引导图。
  static const AppAsset onboardingGuide = AppAsset.directional(
    ltr: 'assets/images/directional/onboarding_guide_ltr.webp',
    rtl: 'assets/images/directional/onboarding_guide_rtl.webp',
  );

  // ============================================================
  // 按语言提供独立资源
  // ============================================================
  /// 首页 Banner。
  ///
  /// 如果图片本身带文字，
  /// 就必须根据语言准备不同版本。
  static const AppAsset homeBanner = AppAsset.localized(
    paths: <String, String>{
      'en': 'assets/images/localized/home_banner_en.webp',

      'zh': 'assets/images/localized/home_banner_zh.webp',

      'zh-Hans': 'assets/images/localized/home_banner_zh.webp',

      'ar': 'assets/images/localized/home_banner_ar.webp',
    },

    /// 找不到对应语言时默认用英语。
    fallbackPath: 'assets/images/localized/home_banner_en.webp',
  );
}
