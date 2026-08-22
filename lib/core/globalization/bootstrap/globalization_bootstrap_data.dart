import 'package:flutter/widgets.dart';

import '../model/globalization_preferences.dart';

/// ProviderContainer 创建前预读取的 Globalization 数据。
///
/// 这样可以保证 App 第一帧就是正确语言、地区、时区与时间制式，
/// 不会先用默认值渲染后再闪到用户设置。
class GlobalizationBootstrapData {
  const GlobalizationBootstrapData({
    required this.preferences,
    required this.systemLocales,
    required this.systemTimeZoneId,
    required this.systemUses24HourFormat,
  });

  final GlobalizationPreferences preferences;
  final List<Locale> systemLocales;
  final String systemTimeZoneId;
  final bool systemUses24HourFormat;
}
