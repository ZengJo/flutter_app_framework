import 'dart:io';

import '../../../app/config/app_globals.dart';
import '../../device/device_info_service.dart';
import '../../logger/app_logger.dart';
import '../../storage/preferences_service.dart';

/// 公共请求头。
///
/// 设备信息和包信息不需要每次请求都重新读取，因此这里做内存缓存；
/// 如需刷新，可调用 [clearCache]。
class RequestHeaders {
  RequestHeaders({
    this.platform = '',
    this.applicationChannel = '',
    this.appVersion = '',
    this.appTheme = 'light',
    this.language = '',
    this.osVersion = '',
    this.deviceId = '',
    this.deviceBrand = '',
    this.system = '',
    this.deviceModel = '',
    this.deviceType = '',
  });

  static const String _cacheKey = 'HTTP_HEADERS_CACHE';
  static Map<String, dynamic>? _memoryCache;

  final String platform;
  final String applicationChannel;
  final String appVersion;
  final String appTheme;
  final String language;
  final String osVersion;
  final String deviceId;
  final String deviceBrand;
  final String system;
  final String deviceModel;
  final String deviceType;

  static Future<RequestHeaders> initHttpHeaders() async {
    final deviceInfo = await DeviceInfoService.getDeviceInfo();
    final platform = Platform.operatingSystem;

    return RequestHeaders(
      platform: platform,
      appVersion: globalPackageInfo.version,
      appTheme: 'light',
      osVersion: Platform.operatingSystemVersion,
      deviceId: globalDeviceId,
      deviceBrand: deviceInfo['deviceBrand']?.toString() ?? '',
      system: Platform.operatingSystemVersion,
      deviceModel: deviceInfo['deviceModel']?.toString() ?? '',
      deviceType: deviceInfo['deviceType']?.toString() ?? '',
      applicationChannel: platform == 'ios' ? 'ios' : 'android',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'platform': platform,
      'appVersion': appVersion,
      'appTheme': appTheme,
      'language': language,
      'osVersion': osVersion,
      'deviceId': deviceId,
      'deviceBrand': deviceBrand,
      'system': system,
      'deviceModel': deviceModel,
      'deviceType': deviceType,
      'channel': applicationChannel,
    };
  }

  static Future<void> saveHeadersToCache(Map<String, dynamic> headers) async {
    try {
      _memoryCache = Map<String, dynamic>.from(headers);
      await PreferencesService.setJson(_cacheKey, headers);
    } catch (error) {
      AppLogger.error('保存 HTTP Headers 到缓存失败: $error');
    }
  }

  static Future<Map<String, dynamic>?> getHeadersFromCache() async {
    if (_memoryCache != null) return Map<String, dynamic>.from(_memoryCache!);

    try {
      final cachedData = await PreferencesService.getJson<dynamic>(_cacheKey);
      if (cachedData is Map) {
        _memoryCache = Map<String, dynamic>.from(cachedData);
        return Map<String, dynamic>.from(_memoryCache!);
      }
    } catch (error) {
      AppLogger.error('从缓存获取 HTTP Headers 失败: $error');
    }
    return null;
  }

  static Future<Map<String, dynamic>> getHeaders({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cachedHeaders = await getHeadersFromCache();
      if (cachedHeaders != null) return cachedHeaders;
    }

    final headers = (await initHttpHeaders()).toJson();
    await saveHeadersToCache(headers);
    return headers;
  }

  static void clearCache() {
    _memoryCache = null;
  }
}
