/// 本地缓存 Key，统一集中管理，避免字符串散落在业务代码里。
class StorageKeys {
  StorageKeys._();

  static const String token = 'TOKEN';
  static const String uid = 'UID';
  static const String currentEnv = 'CURRENT_ENV';

  /// Globalization 用户偏好。
  ///
  /// 使用 V1 后缀，后续数据结构升级时可以平滑迁移到 V2。
  static const String globalizationPreferences =
      'GLOBALIZATION_PREFERENCES_V1';
}
