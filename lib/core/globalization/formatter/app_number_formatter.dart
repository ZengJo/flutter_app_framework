import 'package:intl/intl.dart';

import '../model/globalization_state.dart';

/// 全局数字格式化器。
class AppNumberFormatter {
  const AppNumberFormatter(this.state);

  final GlobalizationState state;

  String decimal(num value, {int? decimalDigits}) {
    final format = NumberFormat.decimalPattern(state.intlLocaleName);

    if (decimalDigits != null) {
      format
        ..minimumFractionDigits = decimalDigits
        ..maximumFractionDigits = decimalDigits;
    }

    return format.format(value);
  }

  String compact(num value) {
    return NumberFormat.compact(locale: state.intlLocaleName).format(value);
  }

  String percent(num value, {int decimalDigits = 0}) {
    final format = NumberFormat.percentPattern(state.intlLocaleName)
      ..minimumFractionDigits = decimalDigits
      ..maximumFractionDigits = decimalDigits;
    return format.format(value);
  }
}
