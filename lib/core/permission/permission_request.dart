import 'package:permission_handler/permission_handler.dart';

enum PermissionRequest {
  microphone("麦克风"),
  camera("相机"),
  photos("相册"),
  notification("通知"),
  phone("电话"),
  audio("音频"),
  storage("存储"),
  wifi("Wi-Fi"),
  bluetooth("蓝牙");

  const PermissionRequest(this.label);

  final String label;
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
