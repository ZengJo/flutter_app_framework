import 'package:flutter/widgets.dart';

import '../config/globalization_config.dart';
import '../model/app_hour_cycle.dart';
import '../model/globalization_preferences.dart';
import '../model/globalization_state.dart';
import '../model/measurement_system.dart';
import '../system/globalization_system_service.dart';
import 'locale_resolver.dart';
import 'region_resolver.dart';

/// 将“用户偏好 + 当前系统信息”解析为最终 GlobalizationState。
class GlobalizationResolver {
  const GlobalizationResolver._();

  static GlobalizationState resolve({
    required GlobalizationPreferences preferences,
    required List<Locale> systemLocales,
    required String systemTimeZoneId,
    required bool systemUses24HourFormat,
  }) {
    final language = LocaleResolver.resolveLanguage(
      followSystem: preferences.followSystemLanguage,
      storedLanguageCode: preferences.languageCode,
      systemLocales: systemLocales,
    );

    final regionCode = RegionResolver.resolveRegion(
      followSystem: preferences.followSystemRegion,
      storedRegionCode: preferences.regionCode,
      systemLocales: systemLocales,
      language: language,
    );

    final locale = language.localeForRegion(regionCode);

    final currencyCode = preferences.followRegionCurrency
        ? RegionResolver.currencyCodeForRegion(regionCode)
        : _normalizeCurrencyCode(preferences.currencyCode) ??
              RegionResolver.currencyCodeForRegion(regionCode);

    final measurementSystem =
        preferences.measurementSystem == MeasurementSystem.system
        ? RegionResolver.measurementSystemForRegion(regionCode)
        : preferences.measurementSystem;

    final timeZoneId = _resolveTimeZone(
      preferences: preferences,
      systemTimeZoneId: systemTimeZoneId,
    );

    return GlobalizationState(
      language: language,
      locale: locale,
      apiLanguageCode: language.apiCode,
      regionCode: regionCode,
      currencyCode: currencyCode,
      timeZoneId: timeZoneId,
      measurementSystem: measurementSystem,
      hourCycle: preferences.hourCycle == AppHourCycle.system
          ? (systemUses24HourFormat ? AppHourCycle.h24 : AppHourCycle.h12)
          : preferences.hourCycle,
      textDirection: language.isRtl ? TextDirection.rtl : TextDirection.ltr,
    );
  }

  static String _resolveTimeZone({
    required GlobalizationPreferences preferences,
    required String systemTimeZoneId,
  }) {
    if (!preferences.followSystemTimeZone &&
        GlobalizationSystemService.isValidTimeZone(preferences.timeZoneId)) {
      return preferences.timeZoneId!.trim();
    }

    if (GlobalizationSystemService.isValidTimeZone(systemTimeZoneId)) {
      return systemTimeZoneId;
    }

    return GlobalizationConfig.fallbackTimeZoneId;
  }

  static String? _normalizeCurrencyCode(String? value) {
    final normalized = value?.trim().toUpperCase();
    if (normalized == null || normalized.length != 3) return null;
    return normalized;
  }
}
