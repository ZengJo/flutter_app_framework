/// 时间显示偏好。
///
/// system: 根据当前 Locale 使用系统习惯格式。
/// h12: 强制 12 小时制。
/// h24: 强制 24 小时制。
enum AppHourCycle {
  system('system'),
  h12('h12'),
  h24('h24');

  const AppHourCycle(this.storageValue);

  final String storageValue;

  static AppHourCycle fromStorage(String? value) {
    return AppHourCycle.values.firstWhere(
      (item) => item.storageValue == value,
      orElse: () => AppHourCycle.system,
    );
  }
}
