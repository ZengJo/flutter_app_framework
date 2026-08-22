import '../model/globalization_state.dart';
import '../model/measurement_system.dart';
import 'app_number_formatter.dart';

/// 单位制转换与展示。
///
/// 入参统一使用公制基础值，展示时根据当前 GlobalizationState 转换。
class AppUnitFormatter {
  const AppUnitFormatter(this.state);

  final GlobalizationState state;

  AppNumberFormatter get _number => AppNumberFormatter(state);

  String temperatureCelsius(double celsius, {int decimalDigits = 0}) {
    if (state.measurementSystem == MeasurementSystem.imperial) {
      final fahrenheit = celsius * 9 / 5 + 32;
      return '${_number.decimal(fahrenheit, decimalDigits: decimalDigits)} °F';
    }
    return '${_number.decimal(celsius, decimalDigits: decimalDigits)} °C';
  }

  String distanceKilometers(double kilometers, {int decimalDigits = 1}) {
    if (state.measurementSystem == MeasurementSystem.imperial) {
      final miles = kilometers * 0.6213711922;
      return '${_number.decimal(miles, decimalDigits: decimalDigits)} mi';
    }
    return '${_number.decimal(kilometers, decimalDigits: decimalDigits)} km';
  }

  String weightKilograms(double kilograms, {int decimalDigits = 1}) {
    if (state.measurementSystem == MeasurementSystem.imperial) {
      final pounds = kilograms * 2.2046226218;
      return '${_number.decimal(pounds, decimalDigits: decimalDigits)} lb';
    }
    return '${_number.decimal(kilograms, decimalDigits: decimalDigits)} kg';
  }
}
