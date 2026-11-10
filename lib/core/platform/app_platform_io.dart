import 'dart:io';

/// 有 dart:io 的平台读取真实系统信息。
class AppPlatform {
  const AppPlatform._();

  static bool get isAndroid => Platform.isAndroid;

  static bool get isIOS => Platform.isIOS;

  static String get operatingSystem => Platform.operatingSystem;

  static String get operatingSystemVersion => Platform.operatingSystemVersion;
}
