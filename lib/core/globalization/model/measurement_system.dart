/// 单位制偏好。
///
/// [system] 只用于“用户偏好”；GlobalizationState 最终会解析成 metric 或 imperial。
enum MeasurementSystem {
  system('system'),
  metric('metric'),
  imperial('imperial');

  const MeasurementSystem(this.storageValue);

  final String storageValue;

  static MeasurementSystem fromStorage(String? value) {
    return MeasurementSystem.values.firstWhere(
      (item) => item.storageValue == value,
      orElse: () => MeasurementSystem.system,
    );
  }
}
