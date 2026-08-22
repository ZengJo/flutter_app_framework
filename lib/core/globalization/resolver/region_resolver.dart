import 'package:country/country.dart';
import 'package:flutter/widgets.dart';

import '../config/globalization_config.dart';
import '../model/app_language.dart';
import '../model/measurement_system.dart';

/// 国家/地区相关解析。
///
/// 使用 ISO 3166-1 Alpha-2，例如 US / CN / SA。
class RegionResolver {
  const RegionResolver._();

  static String resolveRegion({
    required bool followSystem,
    required String? storedRegionCode,
    required List<Locale> systemLocales,
    required AppLanguage language,
  }) {
    if (!followSystem) {
      final stored = normalizeRegionCode(storedRegionCode);
      if (stored != null && findCountry(stored) != null) return stored;
    }

    for (final locale in systemLocales) {
      final systemRegion = normalizeRegionCode(locale.countryCode);
      if (systemRegion != null && findCountry(systemRegion) != null) {
        return systemRegion;
      }
    }

    final languageRegion = normalizeRegionCode(language.defaultRegionCode);
    if (languageRegion != null) return languageRegion;

    return GlobalizationConfig.fallbackRegionCode;
  }

  static Country? findCountry(String? regionCode) {
    final normalized = normalizeRegionCode(regionCode);
    if (normalized == null) return null;

    for (final country in Countries.values) {
      if (country.alpha2.toUpperCase() == normalized) return country;
    }
    return null;
  }

  static String currencyCodeForRegion(String regionCode) {
    return findCountry(regionCode)?.currencyCode.toUpperCase() ??
        GlobalizationConfig.fallbackCurrencyCode;
  }

  static MeasurementSystem measurementSystemForRegion(String regionCode) {
    final country = findCountry(regionCode);
    if (country == null) return MeasurementSystem.metric;

    // country 包为不同地区提供默认距离单位。
    // 使用 wireName 判断，避免业务层依赖具体枚举成员名称。
    final distanceUnit = country.distanceUnit.wireName.toLowerCase();
    return distanceUnit.contains('mile')
        ? MeasurementSystem.imperial
        : MeasurementSystem.metric;
  }

  static String? normalizeRegionCode(String? value) {
    final normalized = value?.trim().toUpperCase();
    if (normalized == null || normalized.length != 2) return null;
    return normalized;
  }
}
