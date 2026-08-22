import 'package:flutter/widgets.dart';

import '../config/globalization_config.dart';
import '../model/app_language.dart';

/// 系统 Locale -> App 支持语言解析器。
class LocaleResolver {
  const LocaleResolver._();

  static AppLanguage resolveLanguage({
    required bool followSystem,
    required String? storedLanguageCode,
    required List<Locale> systemLocales,
  }) {
    if (!followSystem) {
      final stored = AppLanguage.fromStorageCode(storedLanguageCode);
      if (stored != null &&
          GlobalizationConfig.supportedLanguages.contains(stored)) {
        return stored;
      }
    }

    // 按系统 Locale 优先级寻找 App 已支持的语言。
    for (final locale in systemLocales) {
      for (final language in GlobalizationConfig.supportedLanguages) {
        if (language.languageCode == locale.languageCode) {
          return language;
        }
      }
    }

    return GlobalizationConfig.fallbackLanguage;
  }
}
