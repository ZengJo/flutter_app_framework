import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';

class DeviceInfoService {
  ///设备屏幕宽度
  static screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  ///设备屏幕高度
  static screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  ///设备顶部刘海高度
  static top(BuildContext context) {
    double d = MediaQueryData.fromView(View.of(context)).padding.top;
    return d <= 0 ? 12.0 : d;
  }

  ///设备底部安全距离
  static bottom(BuildContext context) {
    double d = MediaQueryData.fromView(View.of(context)).padding.bottom;
    return d <= 0 ? 0.0 : d;

    /// 没有安全距离的设备，返回0，多设备适配
  }

  ///设备左边安全距离
  static left(BuildContext context) {
    double d = MediaQueryData.fromView(View.of(context)).padding.left;
    return d <= 0 ? 12.0 : d;
  }

  ///设备右边安全距离
  static right(BuildContext context) {
    double d = MediaQueryData.fromView(View.of(context)).padding.right;
    return d <= 0 ? 12.0 : d;
  }

  ///设备状态栏尺寸
  static Size appBarSize() {
    return AppBar().preferredSize;
  }

  /// 状态栏与导航栏的高度
  static Size appBarSizeWithPadding(BuildContext context) {
    final appBarHeight = DeviceInfoService.appBarSize().height;
    final deviceTop = top(context);
    return Size(double.maxFinite, appBarHeight + deviceTop);
  }

  ///设备id
  static Future<String?> getDeviceId() async {
    return await FlutterUdid.udid;
  }

  ///判断是否为真机
  static Future<bool> isRealDevice() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return info.isPhysicalDevice;
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      return info.isPhysicalDevice;
    } else {
      return true;
    }
  }

  /// 获取设备信息（仅包含设备型号、品牌、类型）
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    String deviceModel = "";
    String deviceBrand = "";
    // String deviceId = "";
    String deviceType = "";

    final deviceInfo = DeviceInfoPlugin();
    String platform = Platform.operatingSystem;
    if (platform == "android") {
      final android = await deviceInfo.androidInfo;
      deviceModel = android.model;
      deviceBrand = android.brand;
      deviceType = android.type;
    } else if (platform == "ios") {
      final iosInfo = await deviceInfo.iosInfo;
      deviceModel = iosInfo.model;
      deviceBrand = iosInfo.systemName;
      deviceType = iosInfo.utsname.sysname;
    }
    return {
      'deviceModel': deviceModel,
      'deviceBrand': deviceBrand,
      'deviceType': deviceType,
    };
  }
}
