import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import 'permission_request.dart';

class PermissionResolver {
  PermissionResolver._internal();

  static final PermissionResolver instance = PermissionResolver._internal();

  Future<int> androidSdkInt() async {
    if (!Platform.isAndroid) return 0;

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt;
  }

  Future<bool> isAndroid13OrAbove() async {
    if (!Platform.isAndroid) return false;
    return (await androidSdkInt()) >= 33;
  }

  Future<List<Permission>> resolveList(PermissionRequest request) async {
    switch (request) {
      case PermissionRequest.wifi:
        return _resolveWifiPermissions();

      case PermissionRequest.bluetooth:
        return _resolveBluetoothPermissions();

      default:
        return [await resolve(request)];
    }
  }

  Future<Permission> resolve(PermissionRequest request) async {
    final staticPermission = request.staticPermission;
    if (staticPermission != null) return staticPermission;

    switch (request) {
      case PermissionRequest.photos:
        return _resolvePhotosPermission();

      case PermissionRequest.wifi:
        return Permission.location;

      case PermissionRequest.bluetooth:
        if (Platform.isAndroid) {
          final sdkInt = await androidSdkInt();
          return sdkInt >= 31
              ? Permission.bluetoothConnect
              : Permission.bluetooth;
        }
        return Permission.bluetooth;

      case PermissionRequest.microphone:
      case PermissionRequest.audio:
      case PermissionRequest.camera:
      case PermissionRequest.notification:
      case PermissionRequest.phone:
      case PermissionRequest.storage:
        return request.staticPermission ?? Permission.unknown;
    }
  }

  Future<Permission> _resolvePhotosPermission() async {
    if (Platform.isIOS) return Permission.photos;

    if (Platform.isAndroid) {
      final sdkInt = await androidSdkInt();
      return sdkInt >= 33 ? Permission.photos : Permission.storage;
    }

    return Permission.photos;
  }

  Future<List<Permission>> _resolveWifiPermissions() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return const [];
    }

    return [Permission.location];
  }

  Future<List<Permission>> _resolveBluetoothPermissions() async {
    if (Platform.isAndroid) {
      final sdkInt = await androidSdkInt();

      if (sdkInt >= 31) {
        return [Permission.bluetoothScan, Permission.bluetoothConnect];
      }

      return [Permission.bluetooth];
    }

    if (Platform.isIOS) {
      return [Permission.bluetooth];
    }

    return const [];
  }

  Future<String> resolveLabel(Permission permission) async {
    if (permission == Permission.microphone) {
      return PermissionRequest.microphone.label;
    }

    if (permission == Permission.camera) {
      return PermissionRequest.camera.label;
    }

    if (permission == Permission.notification) {
      return PermissionRequest.notification.label;
    }

    if (permission == Permission.phone) {
      return PermissionRequest.phone.label;
    }

    if (permission == Permission.photos) {
      return PermissionRequest.photos.label;
    }

    if (permission == Permission.location) {
      return "定位";
    }

    if (permission == Permission.bluetooth ||
        permission == Permission.bluetoothScan ||
        permission == Permission.bluetoothConnect) {
      return PermissionRequest.bluetooth.label;
    }

    if (permission == Permission.storage) {
      if (Platform.isAndroid && (await androidSdkInt()) < 33) {
        return PermissionRequest.photos.label;
      }

      return PermissionRequest.storage.label;
    }

    return "权限";
  }
}
