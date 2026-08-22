import 'dart:io';

import '../../../app/config/app_globals.dart';
import '../../device/device_info_service.dart';

/// 公共“静态”请求头。
///
/// 这里只保存应用运行过程中基本不会变化的数据：
/// device / appVersion / platform 等。
///
/// language / region / currency / timezone 等动态字段由
/// GlobalizationInterceptor 在每一次请求发送前实时注入。
class RequestHeaders {
  RequestHeaders._();

  static Map<String, dynamic>? _staticHeaders;

  /// App 启动阶段预初始化一次，避免每次请求重新读取设备信息。
  static Future<void> initialize() async {
    _staticHeaders = await _buildStaticHeaders();
  }

  static Future<Map<String, dynamic>> _buildStaticHeaders() async {
    final deviceInfo = await DeviceInfoService.getDeviceInfo();
    final platform = Platform.operatingSystem;

    return <String, dynamic>{
      'platform': platform,
      'appVersion': globalPackageInfo.version,
      'osVersion': Platform.operatingSystemVersion,
      'deviceId': globalDeviceId,
      'deviceBrand': deviceInfo['deviceBrand']?.toString() ?? '',
      'system': Platform.operatingSystemVersion,
      'deviceModel': deviceInfo['deviceModel']?.toString() ?? '',
      'deviceType': deviceInfo['deviceType']?.toString() ?? '',
      'channel': platform == 'ios' ? 'ios' : 'android',
    };
  }

  /// 获取静态请求头。
  ///
  /// 保留原 getHeaders 命名，减少旧业务代码迁移成本。
  static Future<Map<String, dynamic>> getHeaders({
    bool forceRefresh = false,
  }) async {
    if (forceRefresh || _staticHeaders == null) {
      await initialize();
    }

    return Map<String, dynamic>.from(_staticHeaders!);
  }

  /// 清除内存缓存，下次 getHeaders 时会重新生成。
  static void clearCache() {
    _staticHeaders = null;
  }
}
