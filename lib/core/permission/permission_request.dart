import 'package:permission_handler/permission_handler.dart';

/// 业务层使用的权限类型。
///
/// 不在枚举里保存任何中文/英文 label，用户可见文案统一交给 ARB。
enum PermissionRequest {
  microphone,
  camera,
  photos,
  notification,
  phone,
  audio,
  storage,
  wifi,
  bluetooth,
}

extension PermissionRequestExt on PermissionRequest {
  Permission? get staticPermission {
    switch (this) {
      case PermissionRequest.microphone:
        return Permission.microphone;
      case PermissionRequest.camera:
        return Permission.camera;
      case PermissionRequest.notification:
        return Permission.notification;
      case PermissionRequest.phone:
        return Permission.phone;
      case PermissionRequest.storage:
        return Permission.storage;
      case PermissionRequest.audio:
      case PermissionRequest.photos:
      case PermissionRequest.wifi:
      case PermissionRequest.bluetooth:
        return null;
    }
  }
}
