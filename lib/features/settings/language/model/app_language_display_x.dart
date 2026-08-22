import '../../../../core/globalization/generated/app_localizations.dart';
import '../../../../core/globalization/model/app_language.dart';

/// AppLanguage 在语言选择页面中的展示扩展。
///
/// 核心 Globalization 层只保存稳定的语言数据，例如：
/// languageCode、apiCode、nativeName。
///
/// “英语 / English / الإنجليزية”这种跟当前界面语言相关的文案，
/// 放在 Feature 层通过 AppLocalizations 获取，避免 Core 依赖具体页面文案。
extension AppLanguageDisplayX on AppLanguage {
  /// 当前界面语言下的语言名称。
  ///
  /// 例如当前 App 是中文：
  /// English -> 英语
  /// العربية -> 阿拉伯语
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case AppLanguage.english:
        return l10n.languageEnglish;
      case AppLanguage.simplifiedChinese:
        return l10n.languageSimplifiedChinese;
      case AppLanguage.arabic:
        return l10n.languageArabic;
    }
  }

  /// 语言列表左侧的小标识。
  ///
  /// 这里只是 UI 标识，不作为真正语言编码使用。
  String get badgeText {
    switch (this) {
      case AppLanguage.english:
        return 'EN';
      case AppLanguage.simplifiedChinese:
        return '中';
      case AppLanguage.arabic:
        return 'ع';
    }
  }
}
