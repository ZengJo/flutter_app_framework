import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/globalization/config/globalization_config.dart';
import '../../../../core/globalization/model/app_language.dart';
import '../../../../core/globalization/providers/globalization_providers.dart';
import '../../../../core/globalization/resolver/locale_resolver.dart';
import '../../../../core/globalization/system/globalization_system_service.dart';

/// 语言设置页面真正需要的只读状态。
/// [effectiveLanguage] 是 App 当前真正生效的语言；
/// [systemLanguage] 是当前设备系统语言解析后的结果；
/// [followSystem] 用来区分：
/// “系统刚好是中文”和“用户手动选择了中文”。
class LanguageSettingsState {
  const LanguageSettingsState({
    required this.followSystem,
    required this.effectiveLanguage,
    required this.systemLanguage,
    required this.supportedLanguages,
  });

  /// 用户是否选择“跟随系统语言”。
  final bool followSystem;

  /// App 当前真正生效的语言。
  final AppLanguage effectiveLanguage;

  /// 当前系统语言映射到 App 支持语言后的结果。
  final AppLanguage systemLanguage;

  /// 当前项目开放给用户选择的语言。
  final List<AppLanguage> supportedLanguages;

  /// 判断某个语言项当前是否选中。
  ///
  /// language == null 表示“跟随系统”。
  bool isSelected(AppLanguage? language) {
    if (language == null) {
      return followSystem;
    }

    return !followSystem && effectiveLanguage == language;
  }
}

/// 语言设置页面 Provider。
/// 页面只消费这个 Provider，不直接读 SharedPreferences。
/// 所有持久化仍然由 GlobalizationController 统一负责。
final languageSettingsProvider = Provider<LanguageSettingsState>((ref) {
  /// watch 当前 GlobalizationState，语言发生变化后页面会自动刷新。
  final globalization = ref.watch(globalizationProvider);

  /// preferences 需要通过 Controller 读取，
  /// 因为“跟随系统”是用户偏好，不属于最终运行时 Locale 本身。
  final preferences = ref.read(globalizationProvider.notifier).preferences;

  /// 单独解析真实系统语言。
  /// 即使用户当前手动选择了 English，
  /// “跟随系统”这一行仍然可以正确显示设备系统实际使用的语言。
  final systemLanguage = LocaleResolver.resolveLanguage(
    followSystem: true,
    storedLanguageCode: null,
    systemLocales: GlobalizationSystemService.systemLocales,
  );

  return LanguageSettingsState(
    followSystem: preferences.followSystemLanguage,
    effectiveLanguage: globalization.language,
    systemLanguage: systemLanguage,
    supportedLanguages: GlobalizationConfig.supportedLanguages,
  );
});
