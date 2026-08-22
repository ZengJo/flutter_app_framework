import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/app_hour_cycle.dart';
import '../model/app_language.dart';
import '../model/globalization_preferences.dart';
import '../model/globalization_state.dart';
import '../model/measurement_system.dart';
import '../providers/globalization_bootstrap_provider.dart';
import '../resolver/globalization_resolver.dart';
import '../resolver/region_resolver.dart';
import '../storage/globalization_storage.dart';
import '../system/globalization_runtime.dart';
import '../system/globalization_system_service.dart';

/// Globalization 全局控制器。
///
/// 所有语言、地区、货币、时区、单位制修改都从这里进入。
class GlobalizationController extends Notifier<GlobalizationState> {
  late GlobalizationPreferences _preferences;
  late List<Locale> _systemLocales;
  late String _systemTimeZoneId;
  late bool _systemUses24HourFormat;

  GlobalizationPreferences get preferences => _preferences;

  @override
  GlobalizationState build() {
    final bootstrap = ref.watch(globalizationBootstrapProvider);

    _preferences = bootstrap.preferences;
    _systemLocales = List<Locale>.from(bootstrap.systemLocales);
    _systemTimeZoneId = bootstrap.systemTimeZoneId;
    _systemUses24HourFormat = bootstrap.systemUses24HourFormat;

    final initialState = _resolve();
    GlobalizationRuntime.apply(initialState);
    return initialState;
  }

  /// language == null 表示恢复“跟随系统语言”。
  Future<void> setLanguage(AppLanguage? language) async {
    _preferences = _preferences.copyWith(
      followSystemLanguage: language == null,
      languageCode: language?.storageCode,
    );
    _apply();
    await _save();
  }

  /// regionCode == null 表示恢复“跟随系统地区”。
  ///
  /// 返回 false 表示传入的 ISO 3166-1 Alpha-2 地区码无效。
  Future<bool> setRegion(String? regionCode) async {
    final normalized = RegionResolver.normalizeRegionCode(regionCode);

    if (regionCode != null &&
        (normalized == null || RegionResolver.findCountry(normalized) == null)) {
      return false;
    }

    _preferences = _preferences.copyWith(
      followSystemRegion: regionCode == null,
      regionCode: regionCode == null ? null : normalized,
    );
    _apply();
    await _save();
    return true;
  }

  /// currencyCode == null 表示“跟随地区默认货币”。
  ///
  /// 基础框架按 ISO 4217 三位字母做格式校验。
  Future<bool> setCurrency(String? currencyCode) async {
    final normalized = currencyCode?.trim().toUpperCase();
    if (currencyCode != null &&
        (normalized == null ||
            normalized.length != 3 ||
            !RegExp(r'^[A-Z]{3}$').hasMatch(normalized))) {
      return false;
    }

    _preferences = _preferences.copyWith(
      followRegionCurrency: currencyCode == null,
      currencyCode: currencyCode == null ? null : normalized,
    );
    _apply();
    await _save();
    return true;
  }

  /// timeZoneId == null 表示“跟随系统时区”。
  ///
  /// 返回 false 表示传入的 IANA 时区无效。
  Future<bool> setTimeZone(String? timeZoneId) async {
    if (timeZoneId != null &&
        !GlobalizationSystemService.isValidTimeZone(timeZoneId)) {
      return false;
    }

    _preferences = _preferences.copyWith(
      followSystemTimeZone: timeZoneId == null,
      timeZoneId: timeZoneId,
    );
    _apply();
    await _save();
    return true;
  }

  Future<void> setMeasurementSystem(MeasurementSystem value) async {
    _preferences = _preferences.copyWith(measurementSystem: value);
    _apply();
    await _save();
  }

  Future<void> setHourCycle(AppHourCycle value) async {
    _preferences = _preferences.copyWith(hourCycle: value);
    _apply();
    await _save();
  }

  /// 系统语言/地区变化时由 Application 的 WidgetsBindingObserver 调用。
  void updateSystemLocales(List<Locale>? locales) {
    _systemLocales = (locales == null || locales.isEmpty)
        ? GlobalizationSystemService.systemLocales
        : List<Locale>.from(locales);

    if (_preferences.followSystemLanguage || _preferences.followSystemRegion) {
      _apply();
    }
  }

  /// App 从后台回到前台时刷新可能被用户在系统设置中修改的值。
  Future<void> refreshSystemSettings() async {
    final newTimeZoneId = await GlobalizationSystemService.currentTimeZoneId();
    final newUses24HourFormat =
        GlobalizationSystemService.systemUses24HourFormat;

    final timeZoneChanged = newTimeZoneId != _systemTimeZoneId;
    final hourCycleChanged =
        newUses24HourFormat != _systemUses24HourFormat;

    _systemTimeZoneId = newTimeZoneId;
    _systemUses24HourFormat = newUses24HourFormat;

    if ((_preferences.followSystemTimeZone && timeZoneChanged) ||
        (_preferences.hourCycle == AppHourCycle.system && hourCycleChanged)) {
      _apply();
    }
  }

  /// 恢复全部全球化默认设置。
  Future<void> reset() async {
    _preferences = const GlobalizationPreferences();
    _systemLocales = GlobalizationSystemService.systemLocales;
    _systemTimeZoneId = await GlobalizationSystemService.currentTimeZoneId();
    _systemUses24HourFormat =
        GlobalizationSystemService.systemUses24HourFormat;
    _apply();
    await GlobalizationStorage.reset();
  }

  GlobalizationState _resolve() {
    return GlobalizationResolver.resolve(
      preferences: _preferences,
      systemLocales: _systemLocales,
      systemTimeZoneId: _systemTimeZoneId,
      systemUses24HourFormat: _systemUses24HourFormat,
    );
  }

  void _apply() {
    final nextState = _resolve();
    GlobalizationRuntime.apply(nextState);
    state = nextState;
  }

  Future<void> _save() {
    return GlobalizationStorage.save(_preferences);
  }
}
