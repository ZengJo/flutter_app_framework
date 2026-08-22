import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/globalization/config/globalization_config.dart';
import '../../../../core/globalization/model/app_language.dart';
import '../../../../core/globalization/model/globalization_preferences.dart';
import '../../../../core/globalization/model/globalization_state.dart';
import '../../../../core/globalization/providers/globalization_providers.dart';
import '../../../../core/globalization/resolver/locale_resolver.dart';
import '../../../../core/globalization/system/globalization_system_service.dart';

/// 语言 / Globalization 设置页面真正需要的只读状态。
///
/// 页面本身不保存任何全球化状态，只从 [globalizationProvider] 派生展示数据。
/// 真正的状态源仍然只有 GlobalizationController / GlobalizationState 一份。
class LanguageSettingsState {
  const LanguageSettingsState({
    required this.followSystem,
    required this.effectiveLanguage,
    required this.systemLanguage,
    required this.supportedLanguages,
    required this.globalization,
    required this.preferences,
  });

  /// 用户是否选择“跟随系统语言”。
  final bool followSystem;

  /// App 当前真正生效的语言。
  final AppLanguage effectiveLanguage;

  /// 当前设备系统语言映射到 App 支持语言后的结果。
  final AppLanguage systemLanguage;

  /// 当前项目开放给用户选择的语言。
  final List<AppLanguage> supportedLanguages;

  /// App 当前真正生效的完整全球化状态。
  ///
  /// 包含：
  /// - language
  /// - locale
  /// - apiLanguageCode
  /// - regionCode
  /// - currencyCode
  /// - timeZoneId
  /// - measurementSystem
  /// - hourCycle
  /// - textDirection
  final GlobalizationState globalization;

  /// 用户保存的全球化偏好。
  ///
  /// 主要用于判断某个最终值来自：
  /// - 跟随系统
  /// - 跟随地区
  /// - 用户手动设置
  final GlobalizationPreferences preferences;

  /// 判断某个语言项当前是否选中。
  ///
  /// [language] == null 表示“跟随系统”。
  bool isSelected(AppLanguage? language) {
    if (language == null) {
      return followSystem;
    }

    return !followSystem && effectiveLanguage == language;
  }
}

/// Language Settings 页面只读 Provider。
///
/// 这里不会创建第二份 Globalization 状态，只负责把页面需要的数据整理出来。
final languageSettingsProvider = Provider<LanguageSettingsState>((ref) {
  /// watch 当前 GlobalizationState。
  ///
  /// 语言、地区、货币、时区、单位制或时间格式发生变化时，
  /// 页面都会自动重新构建。
  final globalization = ref.watch(globalizationProvider);

  /// Preferences 表示“用户选择了什么”，
  /// GlobalizationState 表示“最终真正生效了什么”。
  final preferences = ref.read(globalizationProvider.notifier).preferences;

  /// 单独解析设备真实系统语言。
  ///
  /// 即使用户当前手动选择 English，
  /// “跟随系统”选项仍然可以显示当前设备真实系统语言。
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
    globalization: globalization,
    preferences: preferences,
  );
});
