import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../config/globalization_config.dart';
import '../model/app_hour_cycle.dart';
import '../model/globalization_state.dart';

/// 日期时间格式化器。
///
/// 约定：
/// - API / Database 尽量统一保存 UTC。
/// - 展示时在这里转换成用户当前 Globalization 时区。
class AppDateFormatter {
  const AppDateFormatter(this.state);

  final GlobalizationState state;

  String shortDate(DateTime value) {
    return DateFormat.yMd(state.intlLocaleName).format(_toUserTimeZone(value));
  }

  String longDate(DateTime value) {
    return DateFormat.yMMMMd(
      state.intlLocaleName,
    ).format(_toUserTimeZone(value));
  }

  String time(DateTime value) {
    final local = _toUserTimeZone(value);

    switch (state.hourCycle) {
      case AppHourCycle.h12:
        return DateFormat('h:mm a', state.intlLocaleName).format(local);
      case AppHourCycle.h24:
        return DateFormat('HH:mm', state.intlLocaleName).format(local);
      case AppHourCycle.system:
        return DateFormat.jm(state.intlLocaleName).format(local);
    }
  }

  String dateTime(DateTime value) {
    final local = _toUserTimeZone(value);
    final date = DateFormat.yMd(state.intlLocaleName).format(local);
    final formattedTime = time(local);
    return '$date $formattedTime';
  }

  tz.TZDateTime _toUserTimeZone(DateTime value) {
    try {
      final location = tz.getLocation(state.timeZoneId);
      return tz.TZDateTime.from(value.toUtc(), location);
    } catch (_) {
      final fallback = tz.getLocation(GlobalizationConfig.fallbackTimeZoneId);
      return tz.TZDateTime.from(value.toUtc(), fallback);
    }
  }
}
