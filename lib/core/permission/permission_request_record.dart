import 'package:shared_preferences/shared_preferences.dart';

import 'permission_request.dart';

/// 权限申请记录
class PermissionRequestRecord {
  PermissionRequestRecord._internal();

  static final PermissionRequestRecord instance =
      PermissionRequestRecord._internal();

  String _key(PermissionRequest request) =>
      "permission_requested_${request.name}";

  /// 是否已经申请过该权限
  Future<bool> hasRequested(PermissionRequest request) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key(request)) ?? false;
  }

  /// 标记该权限已经申请过
  Future<void> markRequested(PermissionRequest request) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key(request), true);
  }

  /// 清除标记（调试或特殊场景可用）
  Future<void> clearRequested(PermissionRequest request) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(request));
  }
}
