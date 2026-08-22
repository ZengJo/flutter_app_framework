import 'package:flutter/widgets.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../config/globalization_config.dart';

/// 读取系统层 Locale / TimeZone / 12-24 小时制等信息。
class GlobalizationSystemService {
  GlobalizationSystemService._();

  static bool _timeZoneDatabaseInitialized = false;

  /// 初始化 IANA 时区数据库。
  static void initializeTimeZoneDatabase() {
    if (_timeZoneDatabaseInitialized) return;
    tz_data.initializeTimeZones();
    _timeZoneDatabaseInitialized = true;
  }

  /// 当前系统 Locale 列表，按系统优先级排序。
  static List<Locale> get systemLocales {
    final locales = WidgetsBinding.instance.platformDispatcher.locales;
    if (locales.isEmpty) {
      return const <Locale>[Locale('en', 'US')];
    }
    return List<Locale>.unmodifiable(locales);
  }

  /// 系统当前是否要求 24 小时制。
  ///
  /// Android 会直接读取用户的“使用 24 小时制”设置；
  /// iOS 会结合系统 24 小时制开关与系统语言环境。
  static bool get systemUses24HourFormat {
    return WidgetsBinding.instance.platformDispatcher.alwaysUse24HourFormat;
  }

  /// 获取设备当前 IANA 时区，例如 America/Los_Angeles。
  static Future<String> currentTimeZoneId() async {
    initializeTimeZoneDatabase();

    try {
      final info = await FlutterTimezone.getLocalTimezone();
      final id = info.identifier.trim();
      if (id.isNotEmpty && isValidTimeZone(id)) {
        return id;
      }
    } catch (_) {
      // 插件异常不应阻塞应用启动。
    }

    return GlobalizationConfig.fallbackTimeZoneId;
  }

  /// 获取设备可用的 IANA 时区列表，可直接用于“时区选择页”。
  static Future<List<String>> availableTimeZoneIds() async {
    try {
      final values = await FlutterTimezone.getAvailableTimezones();
      final result = values
          .map((item) => item.identifier.trim())
          .where((item) => item.isNotEmpty)
          .toSet()
          .toList()
        ..sort();
      return result;
    } catch (_) {
      return const <String>[];
    }
  }

  /// 判断某个时区是否存在于内置 IANA 时区数据库。
  static bool isValidTimeZone(String? timeZoneId) {
    if (timeZoneId == null || timeZoneId.trim().isEmpty) return false;

    initializeTimeZoneDatabase();
    try {
      tz.getLocation(timeZoneId.trim());
      return true;
    } catch (_) {
      return false;
    }
  }
}
