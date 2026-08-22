import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../model/globalization_state.dart';

/// 将 GlobalizationState 同步到第三方国际化运行时。
///
/// 即使业务代码偶尔直接使用 Intl / tz.local，也能获得与 App 当前设置一致的结果。
class GlobalizationRuntime {
  const GlobalizationRuntime._();

  static void apply(GlobalizationState state) {
    Intl.defaultLocale = state.intlLocaleName;

    try {
      tz.setLocalLocation(tz.getLocation(state.timeZoneId));
    } catch (_) {
      // GlobalizationResolver 已做过时区校验，这里仅做最后兜底。
    }
  }
}
