import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../globalization/generated/app_localizations.dart';

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

  /// 根据当前语言返回权限名称。
  Future<String> resolveLabel(
    Permission permission,
    AppLocalizations l10n,
  ) async {
    if (permission == Permission.microphone) {
      return l10n.permissionMicrophone;
    }

    if (permission == Permission.camera) {
      return l10n.permissionCamera;
    }

    if (permission == Permission.notification) {
      return l10n.permissionNotification;
    }

    if (permission == Permission.phone) {
      return l10n.permissionPhone;
    }

    if (permission == Permission.photos) {
      return l10n.permissionPhotos;
    }

    if (permission == Permission.location) {
      return l10n.permissionLocation;
    }

    if (permission == Permission.bluetooth ||
        permission == Permission.bluetoothScan ||
        permission == Permission.bluetoothConnect) {
      return l10n.permissionBluetooth;
    }

    if (permission == Permission.storage) {
      if (Platform.isAndroid && (await androidSdkInt()) < 33) {
        return l10n.permissionPhotos;
      }
      return l10n.permissionStorage;
    }

    return l10n.permissionGeneric;
  }
}
