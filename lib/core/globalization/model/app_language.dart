import 'package:flutter/widgets.dart';

/// App 当前内置支持的语言。
///
/// 注意：
/// 1. 这里描述的是“语言能力”，不是国家/地区。
/// 2. [apiCode] 与 Flutter Locale 分开维护，避免后端语言码规则与 UI Locale 强耦合。
/// 3. 新增语言时，只需要在这里增加枚举项并增加对应 ARB 文件。
enum AppLanguage {
  english(
    storageCode: 'en',
    languageCode: 'en',
    defaultRegionCode: 'US',
    apiCode: 'en-US',
    nativeName: 'English',
    isRtl: false,
  ),
  simplifiedChinese(
    storageCode: 'zh-Hans',
    languageCode: 'zh',
    scriptCode: 'Hans',
    defaultRegionCode: 'CN',
    apiCode: 'zh-CN',
    nativeName: '简体中文',
    isRtl: false,
  ),
  arabic(
    storageCode: 'ar',
    languageCode: 'ar',
    defaultRegionCode: 'SA',
    apiCode: 'ar-SA',
    nativeName: 'العربية',
    isRtl: true,
  );

  const AppLanguage({
    required this.storageCode,
    required this.languageCode,
    this.scriptCode,
    required this.defaultRegionCode,
    required this.apiCode,
    required this.nativeName,
    required this.isRtl,
  });

  /// 保存到本地配置中的稳定编码。
  final String storageCode;

  /// Flutter Locale 的 languageCode。
  final String languageCode;

  /// BCP-47 Script Code，例如简体中文使用 Hans。
  final String? scriptCode;

  /// 当前语言在没有可用系统地区时使用的默认地区。
  final String defaultRegionCode;

  /// 发送给后端的语言编码。
  ///
  /// 如果你的后端要求 en / zh / ar，可直接在这里修改，不影响 Flutter Locale。
  final String apiCode;

  /// 语言自己的名称。语言选择页建议优先显示 nativeName。
  final String nativeName;

  /// 是否为 RTL 语言。
  final bool isRtl;

  /// 根据最终地区构建 Flutter Locale。
  Locale localeForRegion(String regionCode) {
    return Locale.fromSubtags(
      languageCode: languageCode,
      scriptCode: scriptCode,
      countryCode: regionCode,
    );
  }

  /// 从本地存储编码恢复语言。
  static AppLanguage? fromStorageCode(String? value) {
    if (value == null || value.isEmpty) return null;

    for (final language in AppLanguage.values) {
      if (language.storageCode == value) return language;
    }
    return null;
  }
}
