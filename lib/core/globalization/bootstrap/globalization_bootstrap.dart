import '../storage/globalization_storage.dart';
import '../system/globalization_system_service.dart';
import 'globalization_bootstrap_data.dart';

/// Globalization 冷启动初始化。
class GlobalizationBootstrap {
  const GlobalizationBootstrap._();

  static Future<GlobalizationBootstrapData> load() async {
    GlobalizationSystemService.initializeTimeZoneDatabase();

    // 本地偏好与系统时区可以并行读取，减少冷启动等待。
    final preferencesFuture = GlobalizationStorage.load();
    final timeZoneFuture = GlobalizationSystemService.currentTimeZoneId();

    return GlobalizationBootstrapData(
      preferences: await preferencesFuture,
      systemLocales: GlobalizationSystemService.systemLocales,
      systemTimeZoneId: await timeZoneFuture,
      systemUses24HourFormat:
          GlobalizationSystemService.systemUses24HourFormat,
    );
  }
}
