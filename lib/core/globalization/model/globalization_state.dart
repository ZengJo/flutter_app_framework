import 'package:flutter/widgets.dart';

import 'app_hour_cycle.dart';
import 'app_language.dart';
import 'measurement_system.dart';

/// App 当前真正生效的全球化状态。
///
/// UI、网络层、格式化层只依赖这个 State，不直接读取 SharedPreferences。
class GlobalizationState {
  const GlobalizationState({
    required this.language,
    required this.locale,
    required this.apiLanguageCode,
    required this.regionCode,
    required this.currencyCode,
    required this.timeZoneId,
    required this.measurementSystem,
    required this.hourCycle,
    required this.textDirection,
  });

  final AppLanguage language;
  final Locale locale;
  final String apiLanguageCode;
  final String regionCode;
  final String currencyCode;
  final String timeZoneId;

  /// 运行时只会是 metric 或 imperial，不会是 system。
  final MeasurementSystem measurementSystem;

  /// 运行时只会是 h12 或 h24；system 会在 Resolver 中解析为系统真实设置。
  final AppHourCycle hourCycle;
  final TextDirection textDirection;

  bool get isRtl => textDirection == TextDirection.rtl;

  /// intl 包使用下划线形式更加稳妥，例如 zh_Hans_CN。
  String get intlLocaleName => locale.toLanguageTag().replaceAll('-', '_');

  /// 默认写入 HTTP Header 的全球化字段。
  Map<String, dynamic> toRequestHeaders() {
    return <String, dynamic>{
      // 自定义后端语言码，可在 AppLanguage 中按接口规范调整。
      'language': apiLanguageCode,
      // 标准 BCP-47 Locale，方便通用服务直接识别。
      'locale': locale.toLanguageTag(),
      // 标准 HTTP 语言请求头。
      'Accept-Language': locale.toLanguageTag(),
      'region': regionCode,
      'currency': currencyCode,
      'timezone': timeZoneId,
      'measurementSystem': measurementSystem.storageValue,
    };
  }
}
