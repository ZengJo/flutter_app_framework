import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/globalization_controller.dart';
import '../formatter/app_currency_formatter.dart';
import '../formatter/app_date_formatter.dart';
import '../formatter/app_number_formatter.dart';
import '../formatter/app_unit_formatter.dart';
import '../model/globalization_state.dart';

/// App 当前全球化状态。
final globalizationProvider =
    NotifierProvider<GlobalizationController, GlobalizationState>(
      GlobalizationController.new,
    );

/// 日期时间格式化器。
final appDateFormatterProvider = Provider<AppDateFormatter>((ref) {
  return AppDateFormatter(ref.watch(globalizationProvider));
});

/// 数字格式化器。
final appNumberFormatterProvider = Provider<AppNumberFormatter>((ref) {
  return AppNumberFormatter(ref.watch(globalizationProvider));
});

/// 货币格式化器。
final appCurrencyFormatterProvider = Provider<AppCurrencyFormatter>((ref) {
  return AppCurrencyFormatter(ref.watch(globalizationProvider));
});

/// 单位格式化器。
final appUnitFormatterProvider = Provider<AppUnitFormatter>((ref) {
  return AppUnitFormatter(ref.watch(globalizationProvider));
});
