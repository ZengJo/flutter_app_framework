import 'app_hour_cycle.dart';
import 'measurement_system.dart';

/// 用户主动选择的全球化偏好。
///
/// Preferences 与最终运行时 State 必须分开：
/// - Preferences 保存“用户想怎么设置”，例如“语言跟随系统”。
/// - State 保存“当前真正生效的值”，例如当前实际解析为 ar-SA。
class GlobalizationPreferences {
  const GlobalizationPreferences({
    this.version = currentVersion,
    this.followSystemLanguage = true,
    this.languageCode,
    this.followSystemRegion = true,
    this.regionCode,
    this.followSystemTimeZone = true,
    this.timeZoneId,
    this.followRegionCurrency = true,
    this.currencyCode,
    this.measurementSystem = MeasurementSystem.system,
    this.hourCycle = AppHourCycle.system,
  });

  static const int currentVersion = 1;
  static const Object _unset = Object();

  final int version;

  final bool followSystemLanguage;
  final String? languageCode;

  final bool followSystemRegion;
  final String? regionCode;

  final bool followSystemTimeZone;
  final String? timeZoneId;

  final bool followRegionCurrency;
  final String? currencyCode;

  final MeasurementSystem measurementSystem;
  final AppHourCycle hourCycle;

  GlobalizationPreferences copyWith({
    bool? followSystemLanguage,
    Object? languageCode = _unset,
    bool? followSystemRegion,
    Object? regionCode = _unset,
    bool? followSystemTimeZone,
    Object? timeZoneId = _unset,
    bool? followRegionCurrency,
    Object? currencyCode = _unset,
    MeasurementSystem? measurementSystem,
    AppHourCycle? hourCycle,
  }) {
    return GlobalizationPreferences(
      version: currentVersion,
      followSystemLanguage: followSystemLanguage ?? this.followSystemLanguage,
      languageCode: identical(languageCode, _unset)
          ? this.languageCode
          : languageCode as String?,
      followSystemRegion: followSystemRegion ?? this.followSystemRegion,
      regionCode: identical(regionCode, _unset)
          ? this.regionCode
          : regionCode as String?,
      followSystemTimeZone:
          followSystemTimeZone ?? this.followSystemTimeZone,
      timeZoneId: identical(timeZoneId, _unset)
          ? this.timeZoneId
          : timeZoneId as String?,
      followRegionCurrency:
          followRegionCurrency ?? this.followRegionCurrency,
      currencyCode: identical(currencyCode, _unset)
          ? this.currencyCode
          : currencyCode as String?,
      measurementSystem: measurementSystem ?? this.measurementSystem,
      hourCycle: hourCycle ?? this.hourCycle,
    );
  }

  factory GlobalizationPreferences.fromJson(Map<String, dynamic> json) {
    return GlobalizationPreferences(
      version: json['version'] as int? ?? currentVersion,
      followSystemLanguage: json['followSystemLanguage'] as bool? ?? true,
      languageCode: json['languageCode'] as String?,
      followSystemRegion: json['followSystemRegion'] as bool? ?? true,
      regionCode: json['regionCode'] as String?,
      followSystemTimeZone: json['followSystemTimeZone'] as bool? ?? true,
      timeZoneId: json['timeZoneId'] as String?,
      followRegionCurrency: json['followRegionCurrency'] as bool? ?? true,
      currencyCode: json['currencyCode'] as String?,
      measurementSystem: MeasurementSystem.fromStorage(
        json['measurementSystem'] as String?,
      ),
      hourCycle: AppHourCycle.fromStorage(json['hourCycle'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'version': currentVersion,
      'followSystemLanguage': followSystemLanguage,
      'languageCode': languageCode,
      'followSystemRegion': followSystemRegion,
      'regionCode': regionCode,
      'followSystemTimeZone': followSystemTimeZone,
      'timeZoneId': timeZoneId,
      'followRegionCurrency': followRegionCurrency,
      'currencyCode': currencyCode,
      'measurementSystem': measurementSystem.storageValue,
      'hourCycle': hourCycle.storageValue,
    };
  }
}
