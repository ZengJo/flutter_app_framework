/// 本地缓存 Key，统一集中管理，避免字符串散落在业务代码里。
class StorageKeys {
  StorageKeys._();

  static const String token = 'TOKEN';
  static const String uid = 'UID';
  static const String currentEnv = 'CURRENT_ENV';
}
