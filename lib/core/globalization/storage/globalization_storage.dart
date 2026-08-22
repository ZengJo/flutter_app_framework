import '../../storage/preferences_service.dart';
import '../../storage/storage_keys.dart';
import '../model/globalization_preferences.dart';

/// Globalization 偏好持久化。
///
/// 整套配置使用一个 JSON Key 保存，后续版本升级时更容易做迁移。
class GlobalizationStorage {
  const GlobalizationStorage._();

  static Future<GlobalizationPreferences> load() async {
    final raw = await PreferencesService.getJson<dynamic>(
      StorageKeys.globalizationPreferences,
    );

    if (raw is! Map) {
      return const GlobalizationPreferences();
    }

    try {
      return GlobalizationPreferences.fromJson(
        Map<String, dynamic>.from(raw),
      );
    } catch (_) {
      // 本地配置损坏时回退默认值，不能阻塞 App 启动。
      return const GlobalizationPreferences();
    }
  }

  static Future<void> save(GlobalizationPreferences preferences) async {
    await PreferencesService.setJson(
      StorageKeys.globalizationPreferences,
      preferences.toJson(),
    );
  }

  static Future<void> reset() async {
    await PreferencesService.remove(StorageKeys.globalizationPreferences);
  }
}
