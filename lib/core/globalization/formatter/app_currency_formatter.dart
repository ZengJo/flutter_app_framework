import 'package:intl/intl.dart';

import '../model/globalization_state.dart';

/// 货币格式化器。
///
/// 这里只负责“显示格式”，不负责汇率换算。
/// 例如 USD 100 切换成 EUR 时，必须先由业务层完成真实汇率换算。
class AppCurrencyFormatter {
  const AppCurrencyFormatter(this.state);

  final GlobalizationState state;

  String format(
    num amount, {
    String? currencyCode,
    int? decimalDigits,
  }) {
    final code = (currencyCode ?? state.currencyCode).toUpperCase();
    final format = NumberFormat.simpleCurrency(
      locale: state.intlLocaleName,
      name: code,
      decimalDigits: decimalDigits,
    );
    return format.format(amount);
  }
}
