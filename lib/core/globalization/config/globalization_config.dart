import '../model/app_language.dart';

/// Globalization 模块统一配置。
///
/// 具体业务项目如果只支持部分语言，可直接修改 [supportedLanguages]。
class GlobalizationConfig {
  const GlobalizationConfig._();

  static const AppLanguage fallbackLanguage = AppLanguage.english;
  static const String fallbackRegionCode = 'US';
  static const String fallbackCurrencyCode = 'USD';
  static const String fallbackTimeZoneId = 'Etc/UTC';

  /// 基础框架默认验证三类最典型语言：
  /// - English：LTR / 拉丁字符
  /// - 简体中文：CJK
  /// - العربية：RTL
  static const List<AppLanguage> supportedLanguages = <AppLanguage>[
    AppLanguage.english,
    AppLanguage.simplifiedChinese,
    AppLanguage.arabic,
  ];
}
