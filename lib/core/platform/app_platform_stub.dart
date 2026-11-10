/// Web 等没有 dart:io 的平台使用的占位实现。
class AppPlatform {
  const AppPlatform._();

  static bool get isAndroid => false;

  static bool get isIOS => false;

  static String get operatingSystem => 'web';

  static String get operatingSystemVersion => '';
}
